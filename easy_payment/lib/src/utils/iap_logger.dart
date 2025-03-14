import 'package:flutter/foundation.dart';
import '../core/iap_config.dart';
import '../core/iap_logger_listener.dart';
import '../models/iap_purchase_info.dart';

/// IAP日志管理器
class IAPLogger {
  /// 单例实例
  static IAPLogger? _instance;
  
  /// 获取单例实例
  static IAPLogger get instance {
    _instance ??= IAPLogger._();
    return _instance!;
  }

  // ...existing code...