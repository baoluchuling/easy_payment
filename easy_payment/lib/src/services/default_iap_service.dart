import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/iap_service.dart';
import '../models/iap_result.dart';

/// 默认的IAP服务实现
/// 
/// 这是一个基础实现，用于测试或作为自定义实现的参考。
/// 在实际项目中，你应该实现自己的 [IAPService]。
class DefaultIAPService implements IAPService {
  DefaultIAPService();

  @override
  Future<IAPCreateOrderResult> createOrder({
    required String productId,
    String? businessProductId,
  }) async {
    try {
      // 生成测试订单号
      final orderId = '${DateTime.now().millisecondsSinceEpoch}_$productId';
      
      return IAPCreateOrderResult(
        orderId: orderId,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<IAPVerifyResult> verifyPurchase({
    required String productId,
    String? orderId,
    String? transactionId,
    String? originalTransactionId,
    String? receiptData,
    String? businessProductId,
  }) async {
    try {
      // 模拟验证逻辑
      if (receiptData == null || receiptData.isEmpty) {
        return IAPVerifyResult.failure('Receipt data is empty');
      }

      return IAPVerifyResult.success({
        'productId': productId,
        'orderId': orderId,
        'transactionId': transactionId,
        'verificationTime': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      return IAPVerifyResult.failure(e.toString());
    }
  }

  @override
  Future<IAPProductListResult> getProducts() async {
    try {
      // 返回测试商品列表
      return IAPProductListResult(
        success: true,
        productIds: [
          'test_consumable_001',
          'test_non_consumable_001',
          'test_subscription_001',
        ],
      );
    } catch (e) {
      return IAPProductListResult(
        success: false,
        productIds: [],
        error: e.toString(),
      );
    }
  }
}