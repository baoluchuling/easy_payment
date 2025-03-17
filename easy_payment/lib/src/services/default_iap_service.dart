import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/iap_service.dart';
import '../models/iap_result.dart';

/// Default IAP service implementation
/// 
/// This is a basic implementation for testing or as a reference for custom implementations.
/// In a real project, you should implement your own [EasyPaymentService].
class DefaultIAPService implements EasyPaymentService {
  DefaultIAPService();

  @override
  Future<IAPCreateOrderResult> createOrder({
    required String productId,
    String? businessProductId,
  }) async {
    try {
      // Generate test order ID
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
      // Simulate verification logic
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
      // Return test product list
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