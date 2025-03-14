# Easy Payment

[![Pub Version](https://img.shields.io/pub/v/easy_payment)](https://pub.dev/packages/easy_payment)
[![Build Status](https://github.com/yourusername/easy_payment/workflows/CI/badge.svg)](https://github.com/yourusername/easy_payment/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Select Language / 选择语言: **[English](README.md)** | **[简体中文](README.zh-CN.md)** | **[繁體中文](README.zh-TW.md)**

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
