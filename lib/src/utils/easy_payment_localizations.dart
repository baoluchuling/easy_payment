import '../core/easy_payment_error.dart';
import '../models/easy_payment_purchase_info.dart';

/// 错误消息国际化接口
abstract class EasyPaymentErrorLocalizations {
  /// 获取错误消息
  String getErrorMessage(EasyPaymentErrorType type, [String? details]);
}

/// 状态文本国际化接口
abstract class EasyPaymentStatusLocalizations {
  /// 获取状态文本
  String getStatusText(EasyPaymentPurchaseStatus status);
}

/// 日志信息国际化接口
abstract class EasyPaymentLogLocalizations {
  /// 获取日志消息
  String getLogMessage(String type, Map<String, dynamic> data);
}

/// 默认的错误消息国际化实现
class DefaultEasyPaymentErrorLocalizations implements EasyPaymentErrorLocalizations {
  final String locale;
  
  const DefaultEasyPaymentErrorLocalizations([this.locale = 'en']);

  @override
  String getErrorMessage(EasyPaymentErrorType type, [String? details]) {
    if (locale == 'zh') {
      switch (type) {
        case EasyPaymentErrorType.notInitialized:
          return '支付系统未初始化';
        case EasyPaymentErrorType.productNotFound:
          return '未找到商品';
        case EasyPaymentErrorType.duplicatePurchase:
          return '已有一个购买进程在进行中';
        case EasyPaymentErrorType.paymentInvalid:
          return '无效的支付';
        case EasyPaymentErrorType.serverVerifyFailed:
          return '服务器验证失败${details != null ? ': $details' : ''}';
        case EasyPaymentErrorType.network:
          return '网络错误${details != null ? ': $details' : ''}';
        case EasyPaymentErrorType.unknown:
          return '未知错误${details != null ? ': $details' : ''}';
      }
    }

    // English (default)
    switch (type) {
      case EasyPaymentErrorType.notInitialized:
        return 'Payment system is not initialized';
      case EasyPaymentErrorType.productNotFound:
        return 'Product not found';
      case EasyPaymentErrorType.duplicatePurchase:
        return 'A purchase is already in progress';
      case EasyPaymentErrorType.paymentInvalid:
        return 'Invalid payment';
      case EasyPaymentErrorType.serverVerifyFailed:
        return 'Server verification failed${details != null ? ': $details' : ''}';
      case EasyPaymentErrorType.network:
        return 'Network error${details != null ? ': $details' : ''}';
      case EasyPaymentErrorType.unknown:
        return 'Unknown error${details != null ? ': $details' : ''}';
    }
  }
}

/// 默认的状态文本国际化实现
class DefaultEasyPaymentStatusLocalizations implements EasyPaymentStatusLocalizations {
  final String locale;
  
  const DefaultEasyPaymentStatusLocalizations([this.locale = 'en']);

  @override
  String getStatusText(EasyPaymentPurchaseStatus status) {
    if (locale == 'zh') {
      switch (status) {
        case EasyPaymentPurchaseStatus.pending:
          return '等待中';
        case EasyPaymentPurchaseStatus.processing:
          return '处理中';
        case EasyPaymentPurchaseStatus.completed:
          return '已完成';
        case EasyPaymentPurchaseStatus.failed:
          return '失败';
        case EasyPaymentPurchaseStatus.cancelled:
          return '已取消';
      }
    }

    // English (default)
    switch (status) {
      case EasyPaymentPurchaseStatus.pending:
        return 'Pending';
      case EasyPaymentPurchaseStatus.processing:
        return 'Processing';
      case EasyPaymentPurchaseStatus.completed:
        return 'Completed';
      case EasyPaymentPurchaseStatus.failed:
        return 'Failed';
      case EasyPaymentPurchaseStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// 默认的日志信息国际化实现
class DefaultEasyPaymentLogLocalizations implements EasyPaymentLogLocalizations {
  final String locale;
  
  const DefaultEasyPaymentLogLocalizations([this.locale = 'en']);

  @override
  String getLogMessage(String type, Map<String, dynamic> data) {
    if (locale == 'zh') {
      switch (type) {
        case 'purchase_start':
          return '开始购买: ${data['product_id']}';
        case 'order_created':
          return '订单已创建: ${data['order_id']}';
        case 'purchase_verification':
          return '购买验证${data['success'] ? '成功' : '失败'}';
        case 'purchase_complete':
          return '购买${data['success'] ? '完成' : '失败'}';
        case 'error':
          return '错误: ${data['message']}';
        default:
          return '未知日志类型: $type';
      }
    }

    // English (default)
    switch (type) {
      case 'purchase_start':
        return 'Starting purchase: ${data['product_id']}';
      case 'order_created':
        return 'Order created: ${data['order_id']}';
      case 'purchase_verification':
        return 'Purchase verification ${data['success'] ? 'successful' : 'failed'}';
      case 'purchase_complete':
        return 'Purchase ${data['success'] ? 'completed' : 'failed'}';
      case 'error':
        return 'Error: ${data['message']}';
      default:
        return 'Unknown log type: $type';
    }
  }
}