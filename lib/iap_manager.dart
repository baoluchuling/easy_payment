import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:retry/retry.dart';
import 'package:shared_preferences.dart';
import 'iap_error.dart';
import 'iap_result.dart';
import 'iap_purchase_info.dart';
import 'iap_service.dart';
import 'iap_purchase_state_storage.dart';
import 'iap_logger.dart';
import 'iap_logger_listener.dart';
import 'iap_config.dart';

/// IAP支付管理器
/// 
/// 用于管理应用内购买流程，包括：
/// * 初始化支付环境
/// * 查询商品信息
/// * 发起购买请求
/// * 验证购买结果
/// * 管理购买状态
/// * 处理未完成的购买
/// 
/// 基本使用示例:
/// ```dart
/// final manager = IAPManager.instance;
/// await manager.initialize(
///   service: YourIAPService(),
///   config: IAPConfig(
///     maxRetries: 3,
///     retryInterval: Duration(seconds: 2),
///   ),
/// );
/// 
/// try {
///   final result = await manager.purchase('product_id');
///   if (result.success) {
///     print('Purchase successful: ${result.orderId}');
///   }
/// } catch (e) {
///   print('Purchase failed: $e');
/// }
/// ```
class IAPManager {
  /// 单例实例
  static IAPManager? _instance;
  
  /// 获取单例实例
  static IAPManager get instance {
    _instance ??= IAPManager._();
    return _instance!;
  }

  /// IAP实例
  final InAppPurchase _iap = InAppPurchase.instance;
  
  /// 支付服务
  late final IAPService _service;
  
  /// 购买状态存储
  final _stateStorage = IAPPurchaseStateStorage();

  /// 日志管理器
  final _logger = IAPLogger.instance;

  /// 是否已初始化
  bool _isInitialized = false;

  /// 支付状态监听器
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  
  /// 获取状态流
  Stream<IAPPurchaseInfo> get purchaseStateStream => _stateStorage.stateStream;

  /// 配置
  final IAPConfig _config;

  /// 正在进行的购买队列
  final Set<String> _processingPurchases = {};

  IAPManager._() : _config = IAPConfig.defaultConfig;

  /// 初始化支付管理器
  /// 
  /// 必须在使用其他功能前调用此方法完成初始化。
  /// 
  /// 参数:
  /// * [service] - 实现了 [IAPService] 接口的支付服务实例，用于处理服务端逻辑
  /// * [loggerListener] - 可选的日志监听器，用于接收支付过程中的日志
  /// * [config] - 可选的配置项，如果不提供则使用默认配置
  /// 
  /// 异常:
  /// * [IAPError] - 当初始化失败时抛出，错误类型为 [IAPErrorType.notInitialized]
  /// 
  /// 示例:
  /// ```dart
  /// await manager.initialize(
  ///   service: MyIAPService(),
  ///   loggerListener: MyLoggerListener(),
  ///   config: IAPConfig(maxRetries: 3),
  /// );
  /// ```
  Future<void> initialize({
    required IAPService service,
    IAPLoggerListener? loggerListener,
    IAPConfig? config,
  }) async {
    if (_isInitialized) return;

    _service = service;
    
    if (config != null) {
      _config = config;
      // 更新其他组件的配置
      IAPError.setConfig(config);
      IAPLogger.instance.setConfig(config);
    }
    
    // 检查是否可用
    final bool available = await _iap.isAvailable();
    if (!available) {
      throw IAPError.notInitialized();
    }

    // 初始化状态存储
    await _stateStorage.initialize();

    // 设置日志监听器
    if (loggerListener != null) {
      IAPLogger.instance.addListener(loggerListener);
    }

    // 监听购买更新
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (error) {
        debugPrint('IAP Stream error: $error');
      },
    );

    _isInitialized = true;
  }

  /// 带重试的异步操作
  Future<T> _withRetry<T>(
    Future<T> Function() operation,
    String operationName,
  ) async {
    try {
      return await retry(
        operation,
        retryOptions: _config.retryOptions,
        onRetry: (exception, attempt) {
          _logger.logError(
            'retry',
            '${operationName}失败，准备第${attempt + 1}次重试',
            {'error': exception.toString()},
          );
        },
      );
    } catch (e) {
      if (e is IAPError) rethrow;
      throw IAPError.unknown('${operationName}失败', e);
    }
  }

  /// 检查是否可以购买商品
  Future<void> _checkPurchaseAvailability(String productId) async {
    // 检查是否已经在处理中
    if (_processingPurchases.contains(productId)) {
      throw IAPError.duplicatePurchase(productId);
    }

    // 检查是否有未完成的购买
    final existingState = await _stateStorage.getState(productId);
    if (existingState != null && !existingState.isTerminalState) {
      _logger.logError(productId, '存在未完成的购买，但允许继续');
    }

    if (Platform.isIOS) {
      // iOS 特殊处理：检查是否有未完成的交易
      final transactions = await SKPaymentQueueWrapper().transactions();
      final existingTransaction = transactions.firstWhere(
        (tx) => tx.payment.productIdentifier == productId,
        orElse: () => null,
      );
      
      if (existingTransaction != null) {
        _logger.logError(
          productId,
          '发现未完成的iOS交易',
          {'transactionId': existingTransaction.transactionIdentifier},
        );

        try {
          // 服务端验证
          await _withRetry(
            () => _service.verifyPurchase(
              productId: productId,
              transactionId: existingTransaction.transactionIdentifier,
              originalTransactionId: existingTransaction.originalTransactionIdentifier,
              receiptData: existingTransaction.transactionReceipt,
            ),
            '验证未完成交易',
          );
          
          // 完成购买
          if (_config.autoFinishTransaction) {
            await existingTransaction.finish();
          }
          
          // 更新购买状态
          final purchaseInfo = IAPPurchaseInfo(
            productId: productId,
            transactionId: existingTransaction.transactionIdentifier,
            originalTransactionId: existingTransaction.originalTransactionIdentifier,
            receiptData: existingTransaction.transactionReceipt,
            status: IAPPurchaseStatus.completed,
          );
          await _stateStorage.updateState(purchaseInfo);
          _logger.logStateUpdate(purchaseInfo);
          
        } catch (e) {
          _logger.logError(
            productId,
            '未完成交易验证失败',
            {
              'transactionId': existingTransaction.transactionIdentifier,
              'error': e.toString(),
            },
          );
        }
      }
    } else if (Platform.isAndroid) {
      // Android 平台：使用 InAppPurchaseAndroidPlatformAddition 查询未完成交易
      try {
        _logger.logError(productId, '开始检查Android未完成交易');
        
        final androidAddition = _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        
        // 查询历史购买记录
        final response = await androidAddition.queryPastPurchases();
        if (response.error != null) {
          _logger.logError(
            productId,
            'Android历史购买查询失败',
            {'error': response.error.toString()},
          );
          return;
        }
        
        // 查找当前商品的未完成购买
        final unfinishedPurchase = response.pastPurchases.firstWhere(
          (purchase) => purchase.productID == productId && purchase.pendingCompletePurchase,
          orElse: () => null,
        );
        
        if (unfinishedPurchase != null) {
          _logger.logError(
            productId,
            '发现未完成的Android交易',
            {
              'purchaseId': unfinishedPurchase.purchaseID,
              'orderId': unfinishedPurchase.orderId,
            },
          );
          
          try {
            // 服务端验证
            await _withRetry(
              () => _service.verifyPurchase(
                productId: productId,
                transactionId: unfinishedPurchase.purchaseID,
                orderId: unfinishedPurchase.orderId,
                receiptData: unfinishedPurchase.verificationData.serverVerificationData,
              ),
              '验证未完成交易',
            );
            
            // 完成购买
            if (_config.autoFinishTransaction) {
              await _iap.completePurchase(unfinishedPurchase);
            }
            
            // 更新购买状态
            final purchaseInfo = IAPPurchaseInfo(
              productId: productId,
              transactionId: unfinishedPurchase.purchaseID,
              orderId: unfinishedPurchase.orderId,
              receiptData: unfinishedPurchase.verificationData.serverVerificationData,
              status: IAPPurchaseStatus.completed,
            );
            await _stateStorage.updateState(purchaseInfo);
            _logger.logStateUpdate(purchaseInfo);
            
          } catch (e) {
            _logger.logError(
              productId,
              '未完成交易验证失败',
              {
                'purchaseId': unfinishedPurchase.purchaseID,
                'error': e.toString(),
              },
            );
          }
        }
      } catch (e) {
        _logger.logError(
          productId,
          'Android未完成交易检查失败',
          {'error': e.toString()},
        );
      }
    }
  }

  /// 获取商品详情
  Future<ProductDetails> _getProductDetails(String productId) async {
    _logger.logStateUpdate(IAPPurchaseInfo(
      productId: productId,
      status: IAPPurchaseStatus.pending,
    ));

    try {
      final ProductDetailsResponse response = await _iap.queryProductDetails({productId});

      if (response.error != null) {
        throw IAPError.unknown(
          'Failed to load product: ${response.error}',
          response.error,
        );
      }

      if (response.productDetails.isEmpty) {
        throw IAPError.productNotFound(productId);
      }

      return response.productDetails.first;
    } catch (e) {
      if (e is IAPError) rethrow;
      throw IAPError.unknown('Failed to load product', e);
    }
  }

  /// 处理购买更新
  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      _handlePurchaseUpdate(purchaseDetails);
    }
  }

  /// 处理单个购买更新
  Future<void> _handlePurchaseUpdate(PurchaseDetails purchaseDetails) async {
    final currentInfo = await _stateStorage.getState(purchaseDetails.productID);
    if (currentInfo == null) return;

    IAPPurchaseInfo updatedInfo;
    
    switch (purchaseDetails.status) {
      case PurchaseStatus.pending:
        updatedInfo = currentInfo.copyWith(
          status: IAPPurchaseStatus.processing,
          transactionId: purchaseDetails.purchaseID,
          originalTransactionId: purchaseDetails is AppStorePaymentQueueWrapper 
              ? purchaseDetails.originalTransactionIdentifier 
              : null,
          receiptData: purchaseDetails.verificationData.serverVerificationData,
        );
        await _stateStorage.updateState(updatedInfo);
        _logger.logStateUpdate(updatedInfo);
        break;

      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        try {
          // 服务端验证
          final verifyResult = await _withRetry(
            () => _verifyPurchase(purchaseDetails),
            '验证购买',
          );
          
          // 完成购买
          if (_config.autoFinishTransaction) {
            await _iap.completePurchase(purchaseDetails);
          }
          
          updatedInfo = currentInfo.copyWith(
            status: IAPPurchaseStatus.completed,
            transactionId: purchaseDetails.purchaseID,
            originalTransactionId: purchaseDetails is AppStorePaymentQueueWrapper 
                ? purchaseDetails.originalTransactionIdentifier 
                : null,
            receiptData: purchaseDetails.verificationData.serverVerificationData,
            verifyResult: verifyResult,
          );
          _logger.logPurchaseVerification(
            purchaseDetails.productID,
            purchaseDetails.purchaseID,
            true,
          );
        } catch (e) {
          updatedInfo = currentInfo.copyWith(
            status: IAPPurchaseStatus.failed,
            error: e.toString(),
            transactionId: purchaseDetails.purchaseID,
          );
          _logger.logPurchaseVerification(
            purchaseDetails.productID,
            purchaseDetails.purchaseID,
            false,
            e.toString(),
          );
        }
        await _stateStorage.updateState(updatedInfo);
        _logger.logStateUpdate(updatedInfo);
        break;

      case PurchaseStatus.error:
        updatedInfo = currentInfo.copyWith(
          status: IAPPurchaseStatus.failed,
          error: purchaseDetails.error?.message ?? 'Unknown error',
          transactionId: purchaseDetails.purchaseID,
        );
        await _stateStorage.updateState(updatedInfo);
        _logger.logStateUpdate(updatedInfo);
        _logger.logError(
          purchaseDetails.productID,
          purchaseDetails.error?.message ?? 'Unknown error',
          {'transactionId': purchaseDetails.purchaseID},
        );
        break;

      case PurchaseStatus.canceled:
        updatedInfo = currentInfo.copyWith(
          status: IAPPurchaseStatus.cancelled,
          transactionId: purchaseDetails.purchaseID,
        );
        await _stateStorage.updateState(updatedInfo);
        _logger.logStateUpdate(updatedInfo);
        break;
    }
  }

  /// 服务端验证购买
  Future<Map<String, dynamic>> _verifyPurchase(
    PurchaseDetails purchaseDetails,
  ) async {
    final purchaseInfo = await _stateStorage.getState(purchaseDetails.productID);
    
    try {
      final result = await _service.verifyPurchase(
        productId: purchaseDetails.productID,
        orderId: purchaseInfo?.orderId,
        transactionId: purchaseDetails.purchaseID,
        originalTransactionId: purchaseDetails is AppStorePaymentQueueWrapper 
            ? purchaseDetails.originalTransactionIdentifier 
            : null,
        receiptData: purchaseDetails.verificationData.serverVerificationData,
        businessProductId: purchaseInfo?.businessProductId,
      );

      if (!result.success) {
        _logger.logPurchaseVerification(
          purchaseDetails.productID,
          purchaseDetails.purchaseID,
          false,
          result.error,
        );
        throw IAPError.serverVerifyFailed(result.error ?? 'Unknown error');
      }

      _logger.logPurchaseVerification(
        purchaseDetails.productID,
        purchaseDetails.purchaseID,
        true,
      );
      return result.data ?? {};
    } catch (e) {
      _logger.logPurchaseVerification(
        purchaseDetails.productID,
        purchaseDetails.purchaseID,
        false,
        e.toString(),
      );
      if (e is IAPError) rethrow;
      throw IAPError.serverVerifyFailed('Server verification failed', e);
    }
  }

  /// 创建服务端订单
  Future<String> _createOrder(String productId, String? businessProductId) async {
    try {
      final result = await _service.createOrder(
        productId: productId,
        businessProductId: businessProductId,
      );
      return result.orderId;
    } catch (e) {
      if (e is IAPError) rethrow;
      throw IAPError.network('Failed to create order', e);
    }
  }

  /// 购买商品
  /// 
  /// 发起一个新的购买请求。这个方法会：
  /// 1. 检查是否存在未完成的购买
  /// 2. 创建服务端订单
  /// 3. 调用平台支付接口
  /// 4. 验证购买结果
  /// 
  /// 参数:
  /// * [productId] - 要购买的商品 ID
  /// * [businessProductId] - 可选的业务商品 ID，用于和后端系统对接
  /// * [type] - 商品类型，默认为一次性消耗品
  /// 
  /// 返回:
  /// * [IAPResult] - 购买结果，包含订单ID和验证结果
  /// 
  /// 异常:
  /// * [IAPError] - 当购买过程中出现错误时抛出，可能的错误类型包括：
  ///   - [IAPErrorType.notInitialized] - 管理器未初始化
  ///   - [IAPErrorType.productNotFound] - 商品不存在
  ///   - [IAPErrorType.duplicatePurchase] - 存在重复购买
  ///   - [IAPErrorType.network] - 网络错误
  ///   - [IAPErrorType.paymentInvalid] - 支付无效
  ///   - [IAPErrorType.serverVerifyFailed] - 服务端验证失败
  /// 
  /// 示例:
  /// ```dart
  /// try {
  ///   final result = await manager.purchase(
  ///     'premium_feature',
  ///     businessProductId: 'business_123',
  ///     type: IAPProductType.nonConsumable,
  ///   );
  ///   
  ///   if (result.success) {
  ///     print('Purchase successful: ${result.orderId}');
  ///     // 处理购买成功逻辑
  ///   }
  /// } on IAPError catch (e) {
  ///   print('Purchase failed: ${e.message}');
  ///   // 处理特定错误
  /// }
  /// ```
  Future<IAPResult> purchase(
    String productId, {
    String? businessProductId,
    IAPProductType type = IAPProductType.consumable,
  }) async {
    if (!_isInitialized) {
      throw IAPError.notInitialized();
    }

    _logger.logPurchaseStart(productId, businessProductId);

    try {
      // 检查购买可用性
      await _checkPurchaseAvailability(productId);
      
      // 标记为处理中
      _processingPurchases.add(productId);

      // 获取商品信息（带重试）
      final product = await _withRetry(
        () => _getProductDetails(productId),
        '获取商品信息',
      );

      // 创建服务端订单（带重试）
      final orderId = await _withRetry(
        () => _createOrder(productId, businessProductId),
        '创建订单',
      );
      _logger.logOrderCreated(productId, orderId);

      // 创建并保存购买状态
      final purchaseInfo = IAPPurchaseInfo(
        productId: productId,
        businessProductId: businessProductId,
        orderId: orderId,
        status: IAPPurchaseStatus.pending,
      );
      await _stateStorage.updateState(purchaseInfo);
      _logger.logStateUpdate(purchaseInfo);

      // 发起购买（带重试）
      final purchaseParam = PurchaseParam(
        productDetails: product,
      );
      
      bool purchaseStarted = await _withRetry(() async {
        if (type == IAPProductType.consumable) {
          return await _iap.buyConsumable(purchaseParam: purchaseParam);
        } else {
          return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
        }
      }, '发起购买');

      if (!purchaseStarted) {
        throw IAPError.unknown('Failed to start purchase');
      }

      // 等待购买完成
      final completer = Completer<IAPResult>();
      late StreamSubscription<IAPPurchaseInfo> subscription;
      
      subscription = purchaseStateStream.listen((info) {
        if (info.productId == productId && info.isTerminalState) {
          subscription.cancel();
          final result = _convertToResult(info);
          _logger.logPurchaseComplete(
            productId, 
            result.success,
            result.error,
          );
          _processingPurchases.remove(productId);
          completer.complete(result);
        }
      });

      return await completer.future;
    } catch (e) {
      // 更新状态为失败
      final failedInfo = IAPPurchaseInfo(
        productId: productId,
        businessProductId: businessProductId,
        status: IAPPurchaseStatus.failed,
        error: e.toString(),
      );
      await _stateStorage.updateState(failedInfo);
      _logger.logStateUpdate(failedInfo);
      
      _logger.logError(productId, e.toString());
      _processingPurchases.remove(productId);
      
      if (e is IAPError) rethrow;
      throw IAPError.unknown('Purchase failed', e);
    }
  }

  /// 将购买信息转换为结果
  IAPResult _convertToResult(IAPPurchaseInfo info) {
    switch (info.status) {
      case IAPPurchaseStatus.completed:
        return IAPResult.success(
          productId: info.productId,
          orderId: info.orderId ?? '',
          serverVerifyResult: info.verifyResult ?? {},
        );
      case IAPPurchaseStatus.failed:
        return IAPResult.failed(
          productId: info.productId,
          error: info.error ?? 'Unknown error',
          orderId: info.orderId,
        );
      case IAPPurchaseStatus.cancelled:
        return IAPResult.cancelled(
          productId: info.productId,
          orderId: info.orderId,
        );
      default:
        return IAPResult.failed(
          productId: info.productId,
          error: 'Unexpected state: ${info.status}',
          orderId: info.orderId,
        );
    }
  }

  /// 获取商品详情
  /// 
  /// 查询指定商品的详细信息，包括价格、描述等。
  /// 
  /// 参数:
  /// * [productId] - 要查询的商品 ID
  /// 
  /// 返回:
  /// * [ProductDetails]? - 商品详情，如果商品不存在则返回 null
  /// 
  /// 示例:
  /// ```dart
  /// final details = await manager.getProductDetails('premium_feature');
  /// if (details != null) {
  ///   print('Price: ${details.price}');
  /// }
  /// ```
  Future<ProductDetails?> getProductDetails(String productId) async {
    try {
      return await _getProductDetails(productId);
    } catch (e) {
      return null;
    }
  }

  /// 获取所有商品详情
  Future<List<ProductDetails>> getAllProducts() async {
    try {
      // 从服务端获取商品列表
      final result = await _service.getProducts();
      if (!result.success) {
        _logger.logError('all', '获取商品列表失败: ${result.error}');
        return [];
      }

      // 查询商品详情
      final response = await _iap.queryProductDetails(result.productIds.toSet());
      return response.productDetails;
    } catch (e) {
      _logger.logError('all', '获取商品详情失败: $e');
      return [];
    }
  }

  /// 获取购买状态
  /// 
  /// 查询指定商品的最新购买状态。
  /// 
  /// 参数:
  /// * [productId] - 要查询的商品 ID
  /// 
  /// 返回:
  /// * [IAPPurchaseInfo]? - 购买状态信息，如果没有购买记录则返回 null
  /// 
  /// 示例:
  /// ```dart
  /// final state = await manager.getPurchaseState('premium_feature');
  /// if (state?.status == IAPPurchaseStatus.completed) {
  ///   // 处理已完成的购买
  /// }
  /// ```
  Future<IAPPurchaseInfo?> getPurchaseState(String productId) async {
    return _stateStorage.getState(productId);
  }

  /// 获取所有购买状态
  Future<List<IAPPurchaseInfo>> getAllPurchaseStates() async {
    return _stateStorage.getAllStates();
  }

  /// 获取未完成的购买
  Future<List<IAPPurchaseInfo>> getPendingPurchases() async {
    return _stateStorage.getPendingStates();
  }

  /// 获取已完成的购买
  Future<List<IAPPurchaseInfo>> getCompletedPurchases() async {
    return _stateStorage.getCompletedStates();
  }

  /// 清理已完成的购买记录
  Future<void> cleanupCompletedPurchases() async {
    await _stateStorage.cleanupCompletedStates();
  }

  /// 清理所有购买记录
  Future<void> clearAllPurchaseStates() async {
    await _stateStorage.clearAllStates();
  }

  /// 销毁管理器
  void dispose() {
    _subscription?.cancel();
    _subscription = null;

    _stateStorage.dispose();
    IAPLogger.instance.dispose();
    
    _processingPurchases.clear();
    _instance = null;
    _isInitialized = false;
  }
}