import 'package:flutter/foundation.dart';
import 'iap_logger_listener.dart';
import 'iap_purchase_info.dart';
import 'iap_config.dart';

/// IAP日志监听器接口
abstract class IAPLoggerListener {
  /// 日志回调
  /// [event] 事件名称
  /// [data] 日志数据
  void onLog(String event, Map<String, dynamic> data);
} 

/// IAP日志管理器
class EasyPaymentLogger {
  /// 单例实例
  static EasyPaymentLogger? _instance;
  
  /// 获取单例实例
  static EasyPaymentLogger get instance {
    _instance ??= EasyPaymentLogger._();
    return _instance!;
  }

  /// 日志监听器集合
  final Set<IAPLoggerListener> _listeners = {};

  /// 配置
  IAPConfig _config = IAPConfig.defaultConfig;

  EasyPaymentLogger._();

  /// 设置配置
  void setConfig(IAPConfig config) {
    _config = config;
  }

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

  /// 是否应该记录该级别的日志
  bool _shouldLog(LogLevel level) {
    // 如果不是调试模式，只记录 warning 和 error
    if (!_config.debugMode && level.index < LogLevel.warning.index) {
      return false;
    }
    return level.index >= _config.logLevel.index;
  }

  /// 广播日志
  void _broadcastLog(String type, Map<String, dynamic> data, [LogLevel level = LogLevel.info]) {
    if (!_shouldLog(level)) return;

    final message = _config.logLocalizations.getLogMessage(type, data);
    debugPrint('IAP[$type][${level.name}]: $message');
    
    for (final listener in _listeners) {
      try {
        listener.onLog(type, data);
      } catch (e) {
        debugPrint('日志监听器异常: $e');
      }
    }
  }

  /// 记录状态更新
  void logStateUpdate(IAPPurchaseInfo info) {
    final data = {
      'product_id': info.productId,
      'status': info.status.toString(),
      'status_text': _config.statusLocalizations.getStatusText(info.status),
      if (info.orderId != null) 'order_id': info.orderId!,
      if (info.transactionId != null) 'transaction_id': info.transactionId!,
      if (info.error != null) 'error': info.error!,
      if (info.verifyResult != null) 'verify_result': info.verifyResult!,
    };
    _broadcastLog('state_update', data, LogLevel.debug);
  }

  /// 记录购买开始
  void logPurchaseStart(String productId, String? businessProductId) {
    _broadcastLog('purchase_start', {
      'product_id': productId,
      if (businessProductId != null) 'business_product_id': businessProductId,
    }, LogLevel.info);
  }

  /// 记录订单创建
  void logOrderCreated(String productId, String orderId) {
    _broadcastLog('order_created', {
      'product_id': productId,
      'order_id': orderId,
    }, LogLevel.debug);
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
    }, success ? LogLevel.info : LogLevel.error);
  }

  /// 记录购买完成
  void logPurchaseComplete(String productId, bool success, [String? error]) {
    _broadcastLog('purchase_complete', {
      'product_id': productId,
      'success': success,
      if (error != null) 'error': error,
    }, success ? LogLevel.info : LogLevel.error);
  }

  /// 记录错误
  void logError(String tag, String message, [Map<String, dynamic>? extra]) {
    final data = {
      'tag': tag,
      'message': message,
      if (extra != null) ...extra,
    };
    _broadcastLog('error', data, LogLevel.error);
  }

  /// 记录调试信息
  void logDebug(String tag, String message, [Map<String, dynamic>? extra]) {
    final data = {
      'tag': tag,
      'message': message,
      if (extra != null) ...extra,
    };
    _broadcastLog('debug', data, LogLevel.debug);
  }

  /// 记录详细信息
  void logVerbose(String tag, String message, [Map<String, dynamic>? extra]) {
    final data = {
      'tag': tag,
      'message': message,
      if (extra != null) ...extra,
    };
    _broadcastLog('verbose', data, LogLevel.verbose);
  }

  /// 释放资源
  void dispose() {
    clearListeners();
    _instance = null;
  }
}