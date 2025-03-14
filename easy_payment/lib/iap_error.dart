/// IAP支付错误类型
enum IAPErrorType {
  /// 网络错误
  network,
  /// 商品不存在
  productNotFound,
  /// 支付未初始化
  notInitialized,
  /// 服务端验证失败
  serverVerifyFailed,
  /// 重复购买
  duplicatePurchase,
  /// 支付取消
  userCancelled,
  /// 其他错误
  unknown,
}

/// IAP支付错误
class IAPError implements Exception {
  /// 错误类型
  final IAPErrorType type;
  
  /// 错误消息
  final String message;
  
  /// 原始错误
  final dynamic originalError;

  const IAPError({
    required this.type,
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'IAPError: $message (${type.name})';

  /// 创建网络错误
  factory IAPError.network(String message, [dynamic originalError]) {
    return IAPError(
      type: IAPErrorType.network,
      message: message,
      originalError: originalError,
    );
  }

  /// 创建商品不存在错误
  factory IAPError.productNotFound(String productId) {
    return IAPError(
      type: IAPErrorType.productNotFound,
      message: 'Product not found: $productId',
    );
  }

  /// 创建未初始化错误
  factory IAPError.notInitialized() {
    return const IAPError(
      type: IAPErrorType.notInitialized,
      message: 'IAP not initialized',
    );
  }

  /// 创建服务端验证失败错误
  factory IAPError.serverVerifyFailed(String message, [dynamic originalError]) {
    return IAPError(
      type: IAPErrorType.serverVerifyFailed,
      message: message,
      originalError: originalError,
    );
  }

  /// 创建重复购买错误
  factory IAPError.duplicatePurchase(String productId) {
    return IAPError(
      type: IAPErrorType.duplicatePurchase,
      message: 'Duplicate purchase for product: $productId',
    );
  }

  /// 创建用户取消错误
  factory IAPError.userCancelled() {
    return const IAPError(
      type: IAPErrorType.userCancelled,
      message: 'Purchase cancelled by user',
    );
  }

  /// 创建未知错误
  factory IAPError.unknown(String message, [dynamic originalError]) {
    return IAPError(
      type: IAPErrorType.unknown,
      message: message,
      originalError: originalError,
    );
  }
} 