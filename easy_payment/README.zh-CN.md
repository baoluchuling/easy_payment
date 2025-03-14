# Easy Payment

[![Pub Version](https://img.shields.io/pub/v/easy_payment)](https://pub.dev/packages/easy_payment)
[![Build Status](https://github.com/baoluchuling/easy_payment/workflows/CI/badge.svg)](https://github.com/baoluchuling/easy_payment/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

一个为 iOS 和 Android 平台提供简单灵活的应用内购买实现的 Flutter 插件。

### 🚀 特性

- 📱 简单统一的应用内购买 API
- 🔄 支持消耗性和非消耗性商品
- ✅ 内置购买验证
- 🛠 可自定义购买流程
- 📝 详细的购买日志系统
- ❌ 类型化错误处理
- 🌍 内置国际化支持
- 📚 完善的文档

### 📦 安装

在你的项目的 `pubspec.yaml` 文件中添加：

```yaml
dependencies:
  easy_payment: ^0.0.1
```

运行：
```bash
flutter pub get
```

### 🔨 使用方法

#### 基础配置

```dart
import 'package:easy_payment/easy_payment.dart';

// 初始化支付管理器
final manager = IAPManager.instance;
await manager.initialize(
  service: DefaultIAPService(),
  config: IAPConfig(
    // 在此配置
  ),
);

// 开始购买
try {
  final result = await manager.purchase(
    productId: 'your_product_id',
  );
  if (result.success) {
    // 处理成功购买
  }
} catch (e) {
  // 处理错误
}
```

#### 购买验证

```dart
final verifyResult = await manager.verifyPurchase(
  productId: 'your_product_id',
  transactionId: 'transaction_id',
  receiptData: 'receipt_data',
);
```

#### 日志记录

```dart
IAPLogger().addListener(YourLoggerListener());
```

### 📖 文档

- [集成指南](docs/zh/integration_guide.md)
- [架构说明](docs/zh/architecture.md)
- [测试指南](docs/zh/testing_guide.md)
- [国际化](docs/zh/internationalization.md)
- [故障排除](docs/zh/troubleshooting.md)
- [常见问题](docs/zh/faq.md)

### 📱 平台支持

目前支持的平台：
- iOS
- Android

### 🤝 参与贡献

欢迎贡献！请查看我们的[贡献指南](CONTRIBUTING.md)了解更多详情。

### 📄 开源协议

本项目基于 MIT 许可证开源 - 查看 [LICENSE](LICENSE) 文件了解更多详情。

**[English](README.en.md)** | **[简体中文](README.zh-CN.md)** | **[繁體中文](README.zh-TW.md)**