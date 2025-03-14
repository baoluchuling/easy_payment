import 'package:flutter/foundation.dart';
import 'iap_logger_listener.dart';
import 'iap_purchase_info.dart';

/// IAP日志管理器
class IAPLogger {
  /// 单例实例
  static IAPLogger? _instance;
  
  /// 获取单例实例
  static IAPLogger get instance {
    _instance ??= IAPLogger._();
    return _instance!;
  }

  /// 日志监听器集合
  final Set<IAPLoggerListener> _listeners = {};

  IAPLogger._();

  /// 添加日志监听器
  void addListener(IAPLoggerListener listener) {
    _listeners.add(listener);
  }

  /// 移除日志监听器
  void removeListener(IAPLoggerListener listener) {
    _listeners.remove(listener);
  }

  /// 移除所有监听器
  void clearListeners() {
    _listeners.clear();
  }

  /// 广播日志
  void _broadcastLog(String event, Map<String, dynamic> data) {
    debugPrint('IAP[$event]: $data');
    
    for (final listener in _listeners) {
      try {
        listener.onLog(event, data);
      } catch (e) {
        debugPrint('日志监听器异常: $e');
      }
    }
  }

  /// 记录状态更新
  void logStateUpdate(IAPPurchaseInfo info) {
    _broadcastLog('state_update', {
      'product_id': info.productId,
      'status': info.status.toString(),
      if (info.orderId != null) 'order_id': info.orderId!,
      if (info.transactionId != null) 'transaction_id': info.transactionId!,
      if (info.error != null) 'error': info.error!,
      if (info.verifyResult != null) 'verify_result': info.verifyResult!,
    });
  }

  /// 记录购买开始
  void logPurchaseStart(String productId, String? businessProductId) {
    _broadcastLog('purchase_start', {
      'product_id': productId,
      if (businessProductId != null) 'business_product_id': businessProductId,
    });
  }

  /// 记录订单创建
  void logOrderCreated(String productId, String orderId) {
    _broadcastLog('order_created', {
      'product_id': productId,
      'order_id': orderId,
    });
  }

  /// 记录购买验证
  void logPurchaseVerification(
    String productId,
    String transactionId,
    bool success, [
    String? error,
  ]) {
    _broadcastLog('purchase_verification', {
      'product_id': productId,
      'transaction_id': transactionId,
      'success': success,
      if (error != null) 'error': error,
    });
  }

  /// 记录购买完成
  void logPurchaseComplete(String productId, bool success, [String? error]) {
    _broadcastLog('purchase_complete', {
      'product_id': productId,
      'success': success,
      if (error != null) 'error': error,
    });
  }

  /// 记录错误
  void logError(String productId, String error, [Map<String, dynamic>? extra]) {
    _broadcastLog('error', {
      'product_id': productId,
      'error': error,
      if (extra != null) ...extra,
    });
  }

  /// 销毁日志管理器
  void dispose() {
    clearListeners();
    _instance = null;
  }
} 