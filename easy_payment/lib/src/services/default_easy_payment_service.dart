import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/easy_payment_service.dart';
import '../models/easy_payment_result.dart';

/// Default EasyPaymentService implementation
/// 
/// This is a basic implementation for testing or as a reference for custom implementations.
/// In a real project, you should implement your own [EasyPaymentService].
class DefaultEasyPaymentService implements EasyPaymentService {
  DefaultEasyPaymentService();

  @override
  Future<EasyPaymentCreateOrderResult> createOrder({
    required String productId,
    String? businessProductId,
  }) async {
    try {
      // Generate test order ID
      final orderId = '${DateTime.now().millisecondsSinceEpoch}_$productId';
      
      return EasyPaymentCreateOrderResult(
        orderId: orderId,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<EasyPaymentVerifyResult> verifyPurchase({
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
        return EasyPaymentVerifyResult.failure('Receipt data is empty');
      }
      return EasyPaymentVerifyResult.success({
        'productId': productId,
        'orderId': orderId,
        'transactionId': transactionId,
        'verificationTime': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      return EasyPaymentVerifyResult.failure(e.toString());
    }
  }

  @override
  Future<EasyPaymentProductListResult> getProducts() async {
    try {
      // Return test product list
      return EasyPaymentProductListResult(
        success: true,
        productIds: [
          'test_consumable_001',
          'test_non_consumable_001',
          'test_subscription_001',
        ],
      );
    } catch (e) {
      return EasyPaymentProductListResult(
        success: false,
        productIds: [],
        error: e.toString(),
      );
    }
  }
}