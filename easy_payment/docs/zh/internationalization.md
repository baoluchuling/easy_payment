# Easy Payment 国际化

## 概述
Easy Payment 支持以下内容的国际化：
- 错误消息
- 状态消息
- 日志消息
- UI 元素

## 实现
### 1. 自定义错误消息
实现 `IAPErrorLocalizations`：
```dart
class MyErrorLocalizations implements IAPErrorLocalizations {
  @override
  String getErrorMessage(IAPError error) {
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
}
```

### 2. 状态消息
实现 `IAPStatusLocalizations`：
```dart
class MyStatusLocalizations implements IAPStatusLocalizations {
  @override
  String getPurchaseStateMessage(IAPPurchaseState state) {
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
}
```

### 3. 日志消息
实现 `IAPLogLocalizations`：
```dart
class MyLogLocalizations implements IAPLogLocalizations {
  @override
  String getLogMessage(String key, Map<String, dynamic> params) {
    switch (key) {
      case 'purchase_start':
        return '开始购买商品：${params['productId']}';
      case 'purchase_complete':
        return '购买完成：${params['orderId']}';
      default:
        return key;
    }
  }
}
```

### 4. 配置
在初始化时注册本地化：
```dart
await IAPManager.instance.initialize(
  config: IAPConfig(
    errorLocalizations: MyErrorLocalizations(),
    statusLocalizations: MyStatusLocalizations(),
    logLocalizations: MyLogLocalizations(),
  ),
);
```

## 最佳实践
1. 使用一致的术语
2. 支持备用翻译
3. 测试不同语言
4. 谨慎处理字符串格式化

## 语言选择
运行时覆盖语言：
```dart
class DynamicLocalizations implements IAPErrorLocalizations {
  final String locale;
  
  DynamicLocalizations(this.locale);
  
  @override
  String getErrorMessage(IAPError error) {
    if (locale == 'zh') {
      // 返回中文消息
    } else {
      // 返回英文消息
    }
  }
}
```