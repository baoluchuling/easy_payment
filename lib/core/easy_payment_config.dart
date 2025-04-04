import 'package:retry/retry.dart';
import '../models/easy_payment_error.dart';
import '../utils/easy_payment_localizations.dart';
import '../utils/easy_payment_logger.dart';

/// EasyPayment配置
class EasyPaymentConfig {
  /// 默认最大重试次数
  static const int DEFAULT_MAX_RETRIES = 3;

  /// 默认重试间隔(毫秒)
  static const int DEFAULT_RETRY_INTERVAL_MS = 1000;

  /// 日志监听器
  final Set<EasyPaymentLoggerListener> loggerListeners;

  /// 错误消息本地化
  final EasyPaymentErrorLocalizations errorLocalizations;

  /// 状态文本本地化
  final EasyPaymentStatusLocalizations statusLocalizations;

  /// 日志消息本地化
  final EasyPaymentLogLocalizations logLocalizations;

  /// 最大重试次数
  final int maxRetries;

  /// 重试间隔
  final Duration retryInterval;

  /// 是否自动完成交易
  final bool autoFinishTransaction;

  /// 是否调试模式
  final bool debugMode;

  /// 日志级别
  final EasyPaymentLogLevel logLevel;

  /// 创建配置实例
  const EasyPaymentConfig({
    this.loggerListeners = const {},
    EasyPaymentErrorLocalizations? errorLocalizations,
    EasyPaymentStatusLocalizations? statusLocalizations,
    EasyPaymentLogLocalizations? logLocalizations,
    this.maxRetries = DEFAULT_MAX_RETRIES,
    Duration? retryInterval,
    this.autoFinishTransaction = true,
    this.debugMode = false,
    this.logLevel = EasyPaymentLogLevel.info,
  })  : errorLocalizations = errorLocalizations ?? const DefaultEasyPaymentErrorLocalizations(),
        statusLocalizations = statusLocalizations ?? const DefaultEasyPaymentStatusLocalizations(),
        logLocalizations = logLocalizations ?? const DefaultEasyPaymentLogLocalizations(),
        retryInterval = retryInterval ?? const Duration(milliseconds: DEFAULT_RETRY_INTERVAL_MS);

  /// 默认配置
  static final EasyPaymentConfig defaultConfig = EasyPaymentConfig();

  /// 重试配置
  RetryOptions get retryOptions => RetryOptions(
        maxAttempts: maxRetries,
        delayFactor: retryInterval,
      );

  /// 创建新配置实例
  EasyPaymentConfig copyWith({
    Set<EasyPaymentLoggerListener>? loggerListeners,
    EasyPaymentErrorLocalizations? errorLocalizations,
    EasyPaymentStatusLocalizations? statusLocalizations,
    EasyPaymentLogLocalizations? logLocalizations,
    int? maxRetries,
    Duration? retryInterval,
    bool? autoFinishTransaction,
    bool? debugMode,
    EasyPaymentLogLevel? logLevel,
  }) {
    return EasyPaymentConfig(
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