import 'iap_config.dart';

/// IAP错误类型
enum IAPErrorType {
  /// 未初始化
  notInitialized,
  
  /// 商品不存在
  productNotFound,
  
  /// 重复购买
  duplicatePurchase,
  
  /// 支付无效
  paymentInvalid,
  
  /// 服务端验证失败
  serverVerifyFailed,
  
  /// 网络错误
  network,
  
  /// 未知错误
  unknown,
}

/// IAP错误
class IAPError implements Exception {
  /// 错误类型
  final IAPErrorType type;

  /// 错误详情
  final String? details;

  /// 原始错误
  final dynamic originalError;

  /// 配置
  static IAPConfig _config = IAPConfig.defaultConfig;

  /// 设置配置
  static void setConfig(IAPConfig config) {
    _config = config;
  }

  const IAPError._(this.type, [this.details, this.originalError]);

  /// 获取错误消息
  String get message => _config.errorLocalizations.getErrorMessage(type, details);

  @override
  String toString() => message;

  /// 创建未初始化错误
  factory IAPError.notInitialized() => const IAPError._(IAPErrorType.notInitialized);

  /// 创建商品不存在错误
  factory IAPError.productNotFound(String productId) => 
      IAPError._(IAPErrorType.productNotFound, 'Product not found: $productId');

  /// 创建重复购买错误
  factory IAPError.duplicatePurchase(String productId) =>
      IAPError._(IAPErrorType.duplicatePurchase, 'Duplicate purchase: $productId');

  /// 创建支付无效错误
  factory IAPError.paymentInvalid(String reason) =>
      IAPError._(IAPErrorType.paymentInvalid, reason);

  /// 创建服务端验证失败错误
  factory IAPError.serverVerifyFailed(String reason, [dynamic originalError]) =>
      IAPError._(IAPErrorType.serverVerifyFailed, reason, originalError);

  /// 创建网络错误
  factory IAPError.network(String reason, [dynamic originalError]) =>
      IAPError._(IAPErrorType.network, reason, originalError);

  /// 创建未知错误
  factory IAPError.unknown(String reason, [dynamic originalError]) =>
      IAPError._(IAPErrorType.unknown, reason, originalError);
}