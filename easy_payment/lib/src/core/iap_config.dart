import 'package:retry/retry.dart';
import '../utils/iap_localizations.dart';
import 'iap_logger_listener.dart';

/// IAP配置
class IAPConfig {
  /// 默认最大重试次数
  static const int defaultMaxRetries = 3;

  /// 默认重试间隔(毫秒)
  static const int defaultRetryIntervalMs = 1000;

  /// 日志监听器
  final Set<IAPLoggerListener> loggerListeners;

  /// 错误消息本地化
  final IAPErrorLocalizations errorLocalizations;

  /// 状态文本本地化
  final IAPStatusLocalizations statusLocalizations;

  /// 日志消息本地化
  final IAPLogLocalizations logLocalizations;

  /// 最大重试次数
  final int maxRetries;

  /// 重试间隔
  final Duration retryInterval;

  /// 是否自动完成交易
  final bool autoFinishTransaction;

  /// 是否调试模式
  final bool debugMode;

  /// 日志级别
  final LogLevel logLevel;

  /// 创建配置实例
  const IAPConfig({
    this.loggerListeners = const {},
    IAPErrorLocalizations? errorLocalizations,
    IAPStatusLocalizations? statusLocalizations,
    IAPLogLocalizations? logLocalizations,
    this.maxRetries = defaultMaxRetries,
    Duration? retryInterval,
    this.autoFinishTransaction = true,
    this.debugMode = false,
    this.logLevel = LogLevel.info,
  })  : errorLocalizations = errorLocalizations ?? const DefaultIAPErrorLocalizations(),
        statusLocalizations = statusLocalizations ?? const DefaultIAPStatusLocalizations(),
        logLocalizations = logLocalizations ?? const DefaultIAPLogLocalizations(),
        retryInterval = retryInterval ?? const Duration(milliseconds: defaultRetryIntervalMs);

  /// 默认配置
  static final IAPConfig defaultConfig = IAPConfig();

  /// 重试配置
  RetryOptions get retryOptions => RetryOptions(
        maxAttempts: maxRetries,
        delayFactor: retryInterval,
      );

  /// 创建新配置实例
  IAPConfig copyWith({
    Set<IAPLoggerListener>? loggerListeners,
    IAPErrorLocalizations? errorLocalizations,
    IAPStatusLocalizations? statusLocalizations,
    IAPLogLocalizations? logLocalizations,
    int? maxRetries,
    Duration? retryInterval,
    bool? autoFinishTransaction,
    bool? debugMode,
    LogLevel? logLevel,
  }) {
    return IAPConfig(
      loggerListeners: loggerListeners ?? this.loggerListeners,
      errorLocalizations: errorLocalizations ?? this.errorLocalizations,
      statusLocalizations: statusLocalizations ?? this.statusLocalizations,
      logLocalizations: logLocalizations ?? this.logLocalizations,
      maxRetries: maxRetries ?? this.maxRetries,
      retryInterval: retryInterval ?? this.retryInterval,
      autoFinishTransaction: autoFinishTransaction ?? this.autoFinishTransaction,
      debugMode: debugMode ?? this.debugMode,
      logLevel: logLevel ?? this.logLevel,
    );
  }
}