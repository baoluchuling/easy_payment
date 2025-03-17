/// 日志级别
enum EasyPaymentLogLevel {
  /// 详细信息
  verbose,
  /// 调试信息
  debug,
  /// 一般信息
  info,
  /// 警告信息
  warning,
  /// 错误信息
  error,
}

/// 日志监听器接口
abstract class EasyPaymentLoggerListener {
  /// 日志回调
  /// [event] 事件名称
  /// [data] 日志数据
  void onLog(String event, Map<String, dynamic> data);
}