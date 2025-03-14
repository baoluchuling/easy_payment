import 'package:flutter/foundation.dart';
import 'package:retry/retry.dart';

/// IAP配置
class IAPConfig {
  /// 重试配置
  final RetryOptions retryOptions;

  /// 是否自动完成交易（仅iOS）
  final bool autoFinishTransaction;

  const IAPConfig({
    this.retryOptions = const RetryOptions(
      maxAttempts: 3,
      delayFactor: Duration(seconds: 1),
      maxDelay: Duration(seconds: 10),
    ),
    this.autoFinishTransaction = true,
  });

  /// 默认配置
  static const IAPConfig defaultConfig = IAPConfig();
} 