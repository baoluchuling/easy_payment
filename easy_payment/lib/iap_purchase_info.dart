/// 购买状态
enum IAPPurchaseStatus {
  /// 等待中
  pending,
  /// 处理中
  processing,
  /// 已完成
  completed,
  /// 已失败
  failed,
  /// 已取消
  cancelled,
}

/// 商品类型
enum IAPProductType {
  /// 消耗型商品
  consumable,
  /// 非消耗型商品
  nonConsumable,
}

/// 持久化的购买信息模型
class IAPPurchaseInfo {
  /// 商品ID
  final String productId;
  
  /// 交易ID
  final String? transactionId;
  
  /// 原始交易ID
  final String? originalTransactionId;
  
  /// 票据数据
  final String? receiptData;
  
  /// 订单ID
  final String? orderId;
  
  /// 业务商品ID
  final String? businessProductId;
  
  /// 创建时间
  final int createTime;

  /// 购买状态
  final IAPPurchaseStatus status;

  /// 错误信息
  final String? error;

  /// 验证结果
  final Map<String, dynamic>? verifyResult;

  const IAPPurchaseInfo({
    required this.productId,
    this.transactionId,
    this.originalTransactionId,
    this.receiptData,
    this.orderId,
    this.businessProductId,
    this.status = IAPPurchaseStatus.pending,
    this.error,
    this.verifyResult,
    int? createTime,
  }) : createTime = createTime ?? DateTime.now().millisecondsSinceEpoch;

  /// 从JSON创建实例
  factory IAPPurchaseInfo.fromJson(Map<String, dynamic> json) {
    return IAPPurchaseInfo(
      productId: json['productId'] as String,
      transactionId: json['transactionId'] as String?,
      originalTransactionId: json['originalTransactionId'] as String?,
      receiptData: json['receiptData'] as String?,
      orderId: json['orderId'] as String?,
      businessProductId: json['businessProductId'] as String?,
      status: IAPPurchaseStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String?),
        orElse: () => IAPPurchaseStatus.pending,
      ),
      error: json['error'] as String?,
      verifyResult: json['verifyResult'] as Map<String, dynamic>?,
      createTime: json['createTime'] as int?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'transactionId': transactionId,
      'originalTransactionId': originalTransactionId,
      'receiptData': receiptData,
      'orderId': orderId,
      'businessProductId': businessProductId,
      'status': status.name,
      'error': error,
      'verifyResult': verifyResult,
      'createTime': createTime,
    };
  }

  /// 创建更新后的实例
  IAPPurchaseInfo copyWith({
    String? transactionId,
    String? originalTransactionId,
    String? receiptData,
    String? orderId,
    String? businessProductId,
    IAPPurchaseStatus? status,
    String? error,
    Map<String, dynamic>? verifyResult,
  }) {
    return IAPPurchaseInfo(
      productId: productId,
      transactionId: transactionId ?? this.transactionId,
      originalTransactionId: originalTransactionId ?? this.originalTransactionId,
      receiptData: receiptData ?? this.receiptData,
      orderId: orderId ?? this.orderId,
      businessProductId: businessProductId ?? this.businessProductId,
      status: status ?? this.status,
      error: error ?? this.error,
      verifyResult: verifyResult ?? this.verifyResult,
      createTime: createTime,
    );
  }

  /// 判断是否是终态
  bool get isTerminalState => status == IAPPurchaseStatus.completed ||
      status == IAPPurchaseStatus.failed ||
      status == IAPPurchaseStatus.cancelled;
} 