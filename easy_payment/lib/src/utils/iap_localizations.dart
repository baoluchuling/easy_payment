import '../core/iap_error.dart';
import '../models/iap_purchase_info.dart';

/// 错误消息国际化接口
abstract class IAPErrorLocalizations {
  /// 获取错误消息
  String getErrorMessage(IAPErrorType type, [String? details]);
}

/// 状态文本国际化接口
abstract class IAPStatusLocalizations {
  /// 获取状态文本
  String getStatusText(IAPPurchaseStatus status);
}

/// 日志信息国际化接口
abstract class IAPLogLocalizations {
  /// 获取日志消息
  String getLogMessage(String type, Map<String, dynamic> data);
}

/// 默认的错误消息国际化实现
class DefaultIAPErrorLocalizations implements IAPErrorLocalizations {
  final String locale;
  
  const DefaultIAPErrorLocalizations([this.locale = 'en']);

  @override
  String getErrorMessage(IAPErrorType type, [String? details]) {
    if (locale == 'zh') {
      switch (type) {
        case IAPErrorType.notInitialized:
          return '支付系统未初始化';
        case IAPErrorType.productNotFound:
          return '未找到商品';
        case IAPErrorType.duplicatePurchase:
          return '已有一个购买进程在进行中';
        case IAPErrorType.paymentInvalid:
          return '无效的支付';
        case IAPErrorType.serverVerifyFailed:
          return '服务器验证失败${details != null ? ': $details' : ''}';
        case IAPErrorType.network:
          return '网络错误${details != null ? ': $details' : ''}';
        case IAPErrorType.unknown:
          return '未知错误${details != null ? ': $details' : ''}';
      }
    }

    // English (default)
    switch (type) {
      case IAPErrorType.notInitialized:
        return 'Payment system is not initialized';
      case IAPErrorType.productNotFound:
        return 'Product not found';
      case IAPErrorType.duplicatePurchase:
        return 'A purchase is already in progress';
      case IAPErrorType.paymentInvalid:
        return 'Invalid payment';
      case IAPErrorType.serverVerifyFailed:
        return 'Server verification failed${details != null ? ': $details' : ''}';
      case IAPErrorType.network:
        return 'Network error${details != null ? ': $details' : ''}';
      case IAPErrorType.unknown:
        return 'Unknown error${details != null ? ': $details' : ''}';
    }
  }
}

/// 默认的状态文本国际化实现
class DefaultIAPStatusLocalizations implements IAPStatusLocalizations {
  final String locale;
  
  const DefaultIAPStatusLocalizations([this.locale = 'en']);

  @override
  String getStatusText(IAPPurchaseStatus status) {
    if (locale == 'zh') {
      switch (status) {
        case IAPPurchaseStatus.pending:
          return '等待中';
        case IAPPurchaseStatus.processing:
          return '处理中';
        case IAPPurchaseStatus.completed:
          return '已完成';
        case IAPPurchaseStatus.failed:
          return '失败';
        case IAPPurchaseStatus.cancelled:
          return '已取消';
      }
    }

    // English (default)
    switch (status) {
      case IAPPurchaseStatus.pending:
        return 'Pending';
      case IAPPurchaseStatus.processing:
        return 'Processing';
      case IAPPurchaseStatus.completed:
        return 'Completed';
      case IAPPurchaseStatus.failed:
        return 'Failed';
      case IAPPurchaseStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// 默认的日志信息国际化实现
class DefaultIAPLogLocalizations implements IAPLogLocalizations {
  final String locale;
  
  const DefaultIAPLogLocalizations([this.locale = 'en']);

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