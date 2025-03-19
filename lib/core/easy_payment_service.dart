import 'package:flutter/foundation.dart';

/// IAP支付服务接口
abstract class EasyPaymentService {
  /// 创建订单
  Future<EasyPaymentCreateOrderResult> createOrder({
    required String productId,
    String? businessProductId,
  });

  /// 验证购买
  Future<EasyPaymentVerifyResult> verifyPurchase({
    required String productId,
    String? orderId,
    String? transactionId,
    String? originalTransactionId,
    String? receiptData,
    String? businessProductId,
  });

  /// 获取商品列表
  Future<EasyPaymentProductListResult> getProducts();
}

/// 创建订单结果
class EasyPaymentCreateOrderResult {
  /// 订单ID
  final String orderId;
  
  /// 业务数据
  final Map<String, dynamic>? extraData;

  const EasyPaymentCreateOrderResult({
    required this.orderId,
    this.extraData,
  });
}

/// 验证结果
class EasyPaymentVerifyResult {
  /// 是否验证成功
  final bool success;
  
  /// 错误信息
  final String? error;
  
  /// 业务数据
  final Map<String, dynamic>? data;

  const EasyPaymentVerifyResult({
    required this.success,
    this.error,
    this.data,
  });

  /// 创建成功结果
  factory EasyPaymentVerifyResult.success([Map<String, dynamic>? data]) {
    return EasyPaymentVerifyResult(
      success: true,
      data: data,
    );
  }

  /// 创建失败结果
  factory EasyPaymentVerifyResult.failure(String error) {
    return EasyPaymentVerifyResult(
      success: false,
      error: error,
    );
  }
}

/// 商品列表结果
class EasyPaymentProductListResult {
  final bool success;
  final List<String> productIds;
  final String? error;

  const EasyPaymentProductListResult({
    required this.success,
    required this.productIds,
    this.error,
  });
}