import 'package:in_app_purchase/in_app_purchase.dart';

/// Payment result status
enum IAPStatus {
  /// Payment successful
  success,

  /// Payment failed
  failed,

  /// Payment cancelled
  cancelled,

  /// Payment pending
  pending,
}

/// Payment result model
class IAPResult {
  /// Payment status
  final IAPStatus status;

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

  const IAPResult({
    required this.status,
    this.error,
    required this.productId,
    this.orderId,
    this.purchaseDetails,
    this.serverVerifyResult,
  });

  /// Check if payment was successful
  bool get isSuccess => status == IAPStatus.success;

  /// Create a successful result
  factory IAPResult.success({
    required String productId,
    required String orderId,
    required PurchaseDetails purchaseDetails,
    required Map<String, dynamic> serverVerifyResult,
  }) {
    return IAPResult(
      status: IAPStatus.success,
      productId: productId,
      orderId: orderId,
      purchaseDetails: purchaseDetails,
      serverVerifyResult: serverVerifyResult,
    );
  }

  /// Create a failed result
  factory IAPResult.failed({
    required String productId,
    required String error,
    String? orderId,
    PurchaseDetails? purchaseDetails,
  }) {
    return IAPResult(
      status: IAPStatus.failed,
      error: error,
      productId: productId,
      orderId: orderId,
      purchaseDetails: purchaseDetails,
    );
  }

  /// Create a cancelled result
  factory IAPResult.cancelled({
    required String productId,
    String? orderId,
    PurchaseDetails? purchaseDetails,
  }) {
    return IAPResult(
      status: IAPStatus.cancelled,
      productId: productId,
      orderId: orderId,
      purchaseDetails: purchaseDetails,
    );
  }

  /// Create a pending result
  factory IAPResult.pending({
    required String productId,
    required String orderId,
    required PurchaseDetails purchaseDetails,
  }) {
    return IAPResult(
      status: IAPStatus.pending,
      productId: productId,
      orderId: orderId,
      purchaseDetails: purchaseDetails,
    );
  }
}