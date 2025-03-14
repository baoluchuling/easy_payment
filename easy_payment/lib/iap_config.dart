import 'package:flutter/foundation.dart';
import 'package:retry/retry.dart';
import 'iap_localizations.dart';

/// 日志级别
enum LogLevel {
  /// 详细日志
  verbose,
  
  /// 调试日志
  debug,
  
  /// 信息日志
  info,
  
  /// 警告日志
  warning,
  
  /// 错误日志
  error,
}

/// IAP配置
class IAPConfig {
  /// 重试配置
  final RetryOptions retryOptions;

  /// 是否自动完成交易（仅iOS）
  final bool autoFinishTransaction;

  /// 错误消息国际化
  final IAPErrorLocalizations errorLocalizations;

  /// 状态文本国际化
  final IAPStatusLocalizations statusLocalizations;

  /// 日志信息国际化
  final IAPLogLocalizations logLocalizations;

  /// 是否开启调试模式
  final bool debugMode;

  /// 日志级别
  final LogLevel logLevel;

  const IAPConfig({
    this.retryOptions = const RetryOptions(
      maxAttempts: 3,
      delayFactor: Duration(seconds: 1),
      maxDelay: Duration(seconds: 10),
    ),
    this.autoFinishTransaction = true,
    this.errorLocalizations = const DefaultIAPErrorLocalizations(),
    this.statusLocalizations = const DefaultIAPStatusLocalizations(),
    this.logLocalizations = const DefaultIAPLogLocalizations(),
    this.debugMode = false,
    this.logLevel = LogLevel.info,
  });

  /// 默认配置
  static const IAPConfig defaultConfig = IAPConfig();
}