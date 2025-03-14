import 'package:flutter/foundation.dart';

/// IAP日志监听器接口
abstract class IAPLoggerListener {
  /// 日志回调
  /// [event] 事件名称
  /// [data] 日志数据
  void onLog(String event, Map<String, dynamic> data);
} 