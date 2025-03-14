# Easy Payment

[![Pub Version](https://img.shields.io/pub/v/easy_payment)](https://pub.dev/packages/easy_payment)
[![Build Status](https://github.com/yourusername/easy_payment/workflows/CI/badge.svg)](https://github.com/yourusername/easy_payment/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[English](#english) | [中文](#chinese)

<h2 id="english">English</h2>

A Flutter plugin that provides a simple and flexible in-app purchase implementation for both iOS and Android platforms.

### 🚀 Features

- 📱 Simple and unified API for handling in-app purchases
- 🔄 Support for both consumable and non-consumable products
- ✅ Built-in purchase verification
- 🛠 Customizable purchase flow
- 📝 Detailed purchase logging system
- ❌ Error handling with typed errors
- 🌍 Built-in internationalization support
- 📚 Extensive documentation

### 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  easy_payment: ^0.0.1
```

Run:
```bash
flutter pub get
```

### 🔨 Usage

#### Basic Setup

```dart
import 'package:easy_payment/easy_payment.dart';

// Initialize the payment manager
final manager = IAPManager.instance;
await manager.initialize(
  service: DefaultIAPService(),
  config: IAPConfig(
    // Your configuration here
  ),
);

// Start a purchase
try {
  final result = await manager.purchase(
    productId: 'your_product_id',
  );
  if (result.success) {
    // Handle successful purchase
  }
} catch (e) {
  // Handle errors
}
```

#### Purchase Verification

```dart
final verifyResult = await manager.verifyPurchase(
  productId: 'your_product_id',
  transactionId: 'transaction_id',
  receiptData: 'receipt_data',
);
```

#### Logging

```dart
IAPLogger().addListener(YourLoggerListener());
```

### 📖 Documentation

- [Integration Guide](docs/en/integration_guide.md)
- [Architecture](docs/en/architecture.md)
- [Testing Guide](docs/en/testing_guide.md)
- [Internationalization](docs/en/internationalization.md)
- [Troubleshooting](docs/en/troubleshooting.md)
- [FAQ](docs/en/faq.md)

### 📱 Platform Support

Currently supported platforms:
- iOS
- Android

### 🤝 Contributing

Contributions are welcome! Please see our [contributing guide](CONTRIBUTING.md) for more details.

### 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<h2 id="chinese">中文</h2>

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

### 🔨 使用

#### 基础设置

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

### 🤝 贡献

欢迎贡献！请查看我们的[贡献指南](CONTRIBUTING.md)了解更多详情。

### 📄 许可证

本项目基于 MIT 许可证开源 - 查看 [LICENSE](LICENSE) 文件了解更多详情。
