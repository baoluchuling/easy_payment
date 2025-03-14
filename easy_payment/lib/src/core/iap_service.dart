import 'package:flutter/foundation.dart';

/// IAP支付服务接口
abstract class IAPService {
  /// 创建订单
  Future<IAPCreateOrderResult> createOrder({
    required String productId,
    String? businessProductId,
  });

  /// 验证购买
  Future<IAPVerifyResult> verifyPurchase({
    required String productId,
    String? orderId,
    String? transactionId,
    String? originalTransactionId,
    String? receiptData,
    String? businessProductId,
  });

  /// 获取商品列表
  Future<IAPProductListResult> getProducts();
}

/// 创建订单结果
class IAPCreateOrderResult {
  /// 订单ID
  final String orderId;
  
  /// 业务数据
  final Map<String, dynamic>? extraData;

  const IAPCreateOrderResult({
    required this.orderId,
    this.extraData,
  });
}

/// 验证结果
class IAPVerifyResult {
  /// 是否验证成功
  final bool success;
  
  /// 错误信息
  final String? error;
  
  /// 业务数据
  final Map<String, dynamic>? data;

  const IAPVerifyResult({
    required this.success,
    this.error,
    this.data,
  });

  /// 创建成功结果
  factory IAPVerifyResult.success([Map<String, dynamic>? data]) {
    return IAPVerifyResult(
      success: true,
      data: data,
    );
  }

  /// 创建失败结果
  factory IAPVerifyResult.failure(String error) {
    return IAPVerifyResult(
      success: false,
      error: error,
    );
  }
}

/// 商品列表结果
class IAPProductListResult {
  final bool success;
  final List<String> productIds;
  final String? error;

  const IAPProductListResult({
    required this.success,
    required this.productIds,
    this.error,
  });
}