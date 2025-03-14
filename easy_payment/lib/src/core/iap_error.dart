/// IAP错误类型
enum IAPErrorType {
  /// 未初始化
  notInitialized,
  /// 商品未找到
  productNotFound,
  /// 重复购买
  duplicatePurchase,
  /// 支付无效
  paymentInvalid,
  /// 服务器验证失败
  serverVerifyFailed,
  /// 网络错误
  network,
  /// 未知错误
  unknown,
}

/// IAP错误
class IAPError implements Exception {
  /// 错误类型
  final IAPErrorType type;
  
  /// 错误消息
  final String message;
  
  /// 原始错误
  final dynamic cause;

  const IAPError(this.type, this.message, [this.cause]);

  @override
  String toString() => message;

  /// 创建未初始化错误
  factory IAPError.notInitialized() {
    return IAPError(IAPErrorType.notInitialized, '支付系统未初始化');
  }

  /// 创建商品未找到错误
  factory IAPError.productNotFound(String productId) {
    return IAPError(IAPErrorType.productNotFound, '未找到商品: $productId');
  }

  /// 创建重复购买错误
  factory IAPError.duplicatePurchase(String productId) {
    return IAPError(IAPErrorType.duplicatePurchase, '商品[$productId]已在购买中');
  }

  /// 创建支付无效错误
  factory IAPError.paymentInvalid(String message) {
    return IAPError(IAPErrorType.paymentInvalid, '支付无效: $message');
  }

  /// 创建服务器验证失败错误
  factory IAPError.serverVerifyFailed(String message, [dynamic cause]) {
    return IAPError(IAPErrorType.serverVerifyFailed, '服务器验证失败: $message', cause);
  }

  /// 创建网络错误
  factory IAPError.network(String message, [dynamic cause]) {
    return IAPError(IAPErrorType.network, '网络错误: $message', cause);
  }

  /// 创建未知错误
  factory IAPError.unknown(String message, [dynamic cause]) {
    return IAPError(IAPErrorType.unknown, '未知错误: $message', cause);
  }
}