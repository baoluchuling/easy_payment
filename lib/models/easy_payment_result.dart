import 'package:in_app_purchase/in_app_purchase.dart';

/// Payment result status
enum EasyPaymentPurchaseStatus {
  /// Payment successful
  success,

  /// Payment failed
  failed,

  /// Payment cancelled
  cancelled,

  processing,

  /// Payment pending
  pending,
}

/// Payment result model
class EasyPaymentResult {
  /// Payment status
  final EasyPaymentPurchaseStatus status;

  /// Error message
  final String? error;

  /// Product ID
  final String productId;

  /// Order ID
  final String? orderId;

  /// Original purchase details
  final PurchaseDetails? purchaseDetails;

  /// Server verification result
  final Map<String, dynamic>? serverVerifyResult;

  const EasyPaymentResult({
    required this.status,
    this.error,
    required this.productId,
    this.orderId,
    this.purchaseDetails,
    this.serverVerifyResult,
  });

  /// Check if payment was successful
  bool get isSuccess => status == EasyPaymentPurchaseStatus.success;

  /// Create a successful result
  factory EasyPaymentResult.success({
    required String productId,
    required String orderId,
    required PurchaseDetails purchaseDetails,
    required Map<String, dynamic> serverVerifyResult,
  }) {
    return EasyPaymentResult(
      status: EasyPaymentPurchaseStatus.success,
      productId: productId,
      orderId: orderId,
      purchaseDetails: purchaseDetails,
      serverVerifyResult: serverVerifyResult,
    );
  }

  /// Create a failed result
  factory EasyPaymentResult.failed({
    required String productId,
    required String error,
    String? orderId,
    PurchaseDetails? purchaseDetails,
  }) {
    return EasyPaymentResult(
      status: EasyPaymentPurchaseStatus.failed,
      error: error,
      productId: productId,
      orderId: orderId,
      purchaseDetails: purchaseDetails,
    );
  }

  /// Create a cancelled result
  factory EasyPaymentResult.cancelled({
    required String productId,
    String? orderId,
    PurchaseDetails? purchaseDetails,
  }) {
    return EasyPaymentResult(
      status: EasyPaymentPurchaseStatus.cancelled,
      productId: productId,
      orderId: orderId,
      purchaseDetails: purchaseDetails,
    );
  }

  /// Create a pending result
  factory EasyPaymentResult.pending({
    required String productId,
    required String orderId,
    required PurchaseDetails purchaseDetails,
  }) {
    return EasyPaymentResult(
      status: EasyPaymentPurchaseStatus.pending,
      productId: productId,
      orderId: orderId,
      purchaseDetails: purchaseDetails,
    );
  }
}