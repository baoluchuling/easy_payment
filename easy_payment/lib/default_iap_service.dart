import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'iap_service.dart';

/// 默认的IAP服务实现
class DefaultIAPService implements IAPService {
  /// API基础URL
  final String baseUrl;
  
  /// 超时时间
  final Duration timeout;
  
  /// HTTP请求头
  final Map<String, String> headers;

  DefaultIAPService({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    Map<String, String>? headers,
  }) : headers = {
    'Content-Type': 'application/json',
    ...?headers,
  };

  @override
  Future<IAPCreateOrderResult> createOrder({
    required String productId,
    String? businessProductId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create_order'),
        headers: headers,
        body: json.encode({
          'productId': productId,
          'businessProductId': businessProductId,
          'platform': defaultTargetPlatform.name,
        }),
      ).timeout(timeout);

      if (response.statusCode != 200) {
        throw Exception('Failed to create order: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);
      final orderId = responseData['orderId'] as String?;
      if (orderId == null) {
        throw Exception('Invalid response: missing orderId');
      }

      return IAPCreateOrderResult(
        orderId: orderId,
        extraData: responseData['extraData'] as Map<String, dynamic>?,
      );
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  @override
  Future<IAPVerifyResult> verifyPurchase({
    required String productId,
    required String? orderId,
    required String? transactionId,
    required String? originalTransactionId,
    required String? receiptData,
    String? businessProductId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify_purchase'),
        headers: headers,
        body: json.encode({
          'productId': productId,
          'orderId': orderId,
          'transactionId': transactionId,
          'originalTransactionId': originalTransactionId,
          'receiptData': receiptData,
          'businessProductId': businessProductId,
          'platform': defaultTargetPlatform.name,
        }),
      ).timeout(timeout);

      if (response.statusCode != 200) {
        return IAPVerifyResult.failure(
          'Server verification failed: ${response.statusCode}',
        );
      }

      final responseData = json.decode(response.body);
      final success = responseData['success'] as bool? ?? false;
      
      if (!success) {
        return IAPVerifyResult.failure(
          responseData['error'] as String? ?? 'Unknown error',
        );
      }

      return IAPVerifyResult.success(
        responseData['data'] as Map<String, dynamic>?,
      );
    } catch (e) {
      return IAPVerifyResult.failure('Server verification failed: $e');
    }
  }
} 