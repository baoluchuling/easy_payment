import 'package:in_app_purchase/in_app_purchase.dart';

/// 支付结果状态
enum IAPStatus {
  /// 支付成功
  success,
  /// 支付失败
  failed,
  /// 支付取消
  cancelled,
  /// 支付处理中
  pending,
}

/// 支付结果模型
class IAPResult {
  /// 支付状态
  final IAPStatus status;
  
  /// 错误信息
  final String? error;
  
  /// 商品ID
  final String productId;
  
  /// 订单ID
  final String? orderId;
  
  /// 原始购买详情
  final PurchaseDetails? purchaseDetails;
  
  /// 服务端验证结果
  final Map<String, dynamic>? serverVerifyResult;

  const IAPResult({
    required this.status,
    this.error,
    required this.productId,
    this.orderId,
    this.purchaseDetails,
    this.serverVerifyResult,
  });

  /// 判断是否支付成功
  bool get isSuccess => status == IAPStatus.success;

  /// 创建成功结果
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

  /// 创建失败结果
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

  /// 创建取消结果
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

  /// 创建处理中结果
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