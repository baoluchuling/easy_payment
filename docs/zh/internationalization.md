# Easy Payment 国际化开发指南

## 功能概述

Easy Payment 提供完整的国际化支持，包括以下内容：
- 错误提示信息
- 交易状态提示
- 日志记录
- 界面元素

## 快速上手

使用默认实现并指定语言是最快的接入方式：

```dart
await IAPManager.instance.initialize(
  config: IAPConfig(
    errorLocalizations: DefaultIAPErrorLocalizations('zh'),
    statusLocalizations: DefaultIAPStatusLocalizations('zh'),
    logLocalizations: DefaultIAPLogLocalizations('zh'),
  ),
);
```

## 自定义实现

### 错误提示信息

创建自定义的 `IAPErrorLocalizations` 实现类：

```dart
class ChineseErrorLocalizations implements IAPErrorLocalizations {
  @override
  String getErrorMessage(IAPError error) {
    switch (error.type) {
      case IAPErrorType.network:
        return '网络连接失败，请检查网络后重试';
      case IAPErrorType.productNotFound:
        return '未找到该商品';
      case IAPErrorType.userCancelled:
        return '您已取消购买';
      case IAPErrorType.paymentInvalid:
        return '支付信息无效';
      default:
        return '发生错误：${error.message}';
    }
  }
}
```

### 交易状态提示

实现 `IAPStatusLocalizations` 来自定义交易状态提示：

```dart
class ChineseStatusLocalizations implements IAPStatusLocalizations {
  @override
  String getStatusText(IAPPurchaseStatus status) {
    switch (status) {
      case IAPPurchaseStatus.pending:
        return '正在处理您的购买请求...';
      case IAPPurchaseStatus.processing:
        return '正在验证支付信息...';
      case IAPPurchaseStatus.completed:
        return '购买成功';
      case IAPPurchaseStatus.failed:
        return '购买失败';
      case IAPPurchaseStatus.cancelled:
        return '购买已取消';
    }
  }
}
```

### 日志记录

自定义 `IAPLogLocalizations` 实现：

```dart
class ChineseLogLocalizations implements IAPLogLocalizations {
  @override
  String getLogMessage(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'purchase_start':
        return '开始购买商品：${data['product_id']}';
      case 'order_created':
        return '订单创建成功（订单号：${data['order_id']}）';
      case 'purchase_verification':
        return '购买验证${data['success'] ? '成功' : '失败'}';
      case 'purchase_complete':
        return '购买${data['success'] ? '成功' : '失败'}';
      default:
        return '未知事件：$type';
    }
  }
}
```

## 开发建议

### 用语规范

保持用语的一致性：
- 使用"购买"而不是混用"购买"和"买"
- 保持标点符号使用的一致性
- 错误提示要简明易懂
- 状态提示要友好自然

### 备用翻译

务必提供备用翻译文案：

```dart
String getMessage(String key) {
  return translations[key] ?? defaultTranslations[key] ?? key;
}
```

### 测试要点

翻译文案测试建议：
- 确保所有文案都已翻译
- 测试不同数据的格式化效果
- 测试特殊情况（较长文本、特殊字符）
- 验证界面上的文案显示效果

### 文本格式化

注意文本格式化的处理：
- 使用具名参数提高代码可读性
- 考虑不同语言的文本长度差异
- 妥善处理空值情况
- 注意中文标点符号的使用

## 接入示例

这是一个完整的中文本地化接入示例：

```dart
// 使用中文本地化初始化
final manager = IAPManager.instance;
await manager.initialize(
  service: DefaultIAPService(),
  config: IAPConfig(
    errorLocalizations: ChineseErrorLocalizations(),
    statusLocalizations: ChineseStatusLocalizations(),
    logLocalizations: ChineseLogLocalizations(),
  ),
);

// 开始购买流程（所有提示都会自动使用中文）
try {
  final result = await manager.purchase(
    productId: 'premium_subscription'
  );
  if (result.success) {
    print('购买成功');
  }
} catch (error) {
  // 错误信息会自动使用中文显示
  print(error.localizedMessage);
}
```

## 常见问题

### 如何动态切换语言？

您可以通过重新初始化配置来切换语言：

```dart
// 切换到中文
await manager.updateConfig(
  IAPConfig(
    errorLocalizations: ChineseErrorLocalizations(),
    statusLocalizations: ChineseStatusLocalizations(),
    logLocalizations: ChineseLogLocalizations(),
  ),
);
```

### 如何处理繁体中文？

您可以通过地区代码来区分简繁体：

```dart
class ChineseErrorLocalizations implements IAPErrorLocalizations {
  final String region;
  
  ChineseErrorLocalizations([this.region = 'CN']);
  
  @override
  String getErrorMessage(IAPError error) {
    if (region == 'TW' || region == 'HK') {
      // 返回繁体中文错误信息
    } else {
      // 返回简体中文错误信息
    }
  }
}