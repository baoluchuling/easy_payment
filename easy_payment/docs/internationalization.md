# Easy Payment Internationalization / Easy Payment 国际化

Choose your language / 选择语言：

- [English](en/internationalization.md)
- [中文](zh/internationalization.md)

## Overview / 概述

Easy Payment supports internationalization for: / Easy Payment 支持以下内容的国际化：
- Error messages / 错误消息
- Status messages / 状态消息
- Log messages / 日志消息
- UI elements / UI 元素

## Implementation / 实现

### 1. Custom Error Messages / 自定义错误消息

Implement `IAPErrorLocalizations` / 实现 `IAPErrorLocalizations`：

```dart
class MyErrorLocalizations implements IAPErrorLocalizations {
  final String locale;
  
  MyErrorLocalizations([this.locale = 'en']);

  @override
  String getErrorMessage(IAPError error) {
    if (locale == 'zh') {
      switch (error.type) {
        case IAPErrorType.network:
          return '网络错误，请重试。';
        case IAPErrorType.productNotFound:
          return '未找到商品。';
        case IAPErrorType.userCancelled:
          return '购买已取消。';
        default:
          return '发生错误：${error.message}';
      }
    }
    
    // English (default)
    switch (error.type) {
      case IAPErrorType.network:
        return 'Network error occurred. Please try again.';
      case IAPErrorType.productNotFound:
        return 'Product not found.';
      case IAPErrorType.userCancelled:
        return 'Purchase cancelled.';
      default:
        return 'An error occurred: ${error.message}';
    }
  }
}
```

### 2. Status Messages / 状态消息

Implement `IAPStatusLocalizations` / 实现 `IAPStatusLocalizations`：

```dart
class MyStatusLocalizations implements IAPStatusLocalizations {
  final String locale;
  
  MyStatusLocalizations([this.locale = 'en']);

  @override
  String getPurchaseStateMessage(IAPPurchaseState state) {
    if (locale == 'zh') {
      switch (state) {
        case IAPPurchaseState.pending:
          return '正在处理购买...';
        case IAPPurchaseState.purchased:
          return '购买完成';
        case IAPPurchaseState.failed:
          return '购买失败';
        default:
          return '未知状态';
      }
    }

    // English (default)
    switch (state) {
      case IAPPurchaseState.pending:
        return 'Processing purchase...';
      case IAPPurchaseState.purchased:
        return 'Purchase completed';
      case IAPPurchaseState.failed:
        return 'Purchase failed';
      default:
        return 'Unknown state';
    }
  }
}
```

### 3. Log Messages / 日志消息

Implement `IAPLogLocalizations` / 实现 `IAPLogLocalizations`：

```dart
class MyLogLocalizations implements IAPLogLocalizations {
  final String locale;
  
  MyLogLocalizations([this.locale = 'en']);

  @override
  String getLogMessage(String key, Map<String, dynamic> params) {
    if (locale == 'zh') {
      switch (key) {
        case 'purchase_start':
          return '开始购买商品：${params['productId']}';
        case 'purchase_complete':
          return '购买完成：${params['orderId']}';
        default:
          return key;
      }
    }

    // English (default)
    switch (key) {
      case 'purchase_start':
        return 'Starting purchase for ${params['productId']}';
      case 'purchase_complete':
        return 'Purchase completed: ${params['orderId']}';
      default:
        return key;
    }
  }
}
```

### 4. Configuration / 配置

Register localizations during initialization / 在初始化时注册本地化：

```dart
// Create localizations with specific language
// 创建特定语言的本地化实例
final errorLocalizations = MyErrorLocalizations('zh');
final statusLocalizations = MyStatusLocalizations('zh');
final logLocalizations = MyLogLocalizations('zh');

await IAPManager.instance.initialize(
  config: IAPConfig(
    errorLocalizations: errorLocalizations,
    statusLocalizations: statusLocalizations,
    logLocalizations: logLocalizations,
  ),
);
```

## Best Practices / 最佳实践

1. Use consistent terminology / 使用一致的术语
2. Support fallback translations / 支持备用翻译
3. Test with different languages / 测试不同语言
4. Handle string formatting carefully / 谨慎处理字符串格式化

For detailed implementation examples, refer to:
更多详细的实现示例，请参考：

- [English Documentation](en/internationalization.md)
- [中文文档](zh/internationalization.md)
