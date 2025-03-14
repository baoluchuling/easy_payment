import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'iap_service.dart';
import 'iap_result.dart';

/// 默认的IAP服务实现
/// 
/// 这是一个基础实现，用于测试或作为自定义实现的参考。
/// 在实际项目中，你应该实现自己的 [IAPService]。
class DefaultIAPService implements IAPService {
  DefaultIAPService();

  @override
  Future<IAPResult> createOrder({
    required String productId,
    String? businessProductId,
  }) async {
    try {
      // 生成测试订单号
      final orderId = '${DateTime.now().millisecondsSinceEpoch}_$productId';
      
      return IAPResult.success(
        data: {'orderId': orderId},
      );
    } catch (e) {
      return IAPResult.failed(error: e.toString());
    }
  }

  @override
  Future<IAPResult> verifyPurchase({
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
        return IAPResult.failed(error: 'Receipt data is empty');
      }

      return IAPResult.success(
        data: {
          'productId': productId,
          'orderId': orderId,
          'transactionId': transactionId,
          'verificationTime': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      return IAPResult.failed(error: e.toString());
    }
  }

  @override
  Future<IAPResult> getProducts() async {
    try {
      // 返回测试商品列表
      return IAPResult.success(
        data: {
          'productIds': [
            'test_consumable_001',
            'test_non_consumable_001',
            'test_subscription_001',
          ],
        },
      );
    } catch (e) {
      return IAPResult.failed(error: e.toString());
    }
  }
}