# Easy Payment Integration Guide

## Installation
Add the following to your `pubspec.yaml`:
```yaml
dependencies:
  easy_payment: ^latest_version
```

## Basic Setup
### 1. Initialize the Plugin
```dart
void main() async {
  // Initialize before runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  await IAPManager.instance.initialize(
    config: IAPConfig(
      autoFinishTransaction: true,
      retryOptions: RetryOptions(maxAttempts: 3),
    ),
  );
  
  runApp(MyApp());
}
```

### 2. Configure Products
Create product IDs:
```dart
class ProductIds {
  static const consumable = 'com.example.coins';
  static const nonConsumable = 'com.example.premium';
}
```

### 3. Implement Basic Purchase Flow
```dart
Future<void> purchaseProduct(String productId) async {
  try {
    final result = await IAPManager.instance.purchase(productId);
    if (result.success) {
      // Handle successful purchase
    }
  } on IAPError catch (e) {
    // Handle error
  }
}
```

## Advanced Features
### 1. Purchase State Management
```dart
// Listen to purchase updates
IAPManager.instance.addPurchaseListener((info) {
  if (info.state == IAPPurchaseState.purchased) {
    // Handle purchase completion
  }
});
```

### 2. Custom Service Implementation
```dart
class CustomIAPService implements IAPService {
  @override
  Future<IAPResult> createOrder({
    required String productId,
    String? businessProductId,
  }) async {
    // Implement custom order creation
  }
  
  // Implement other required methods
}
// Use custom service
await IAPManager.instance.initialize(
  service: CustomIAPService(),
);
```

### 3. Error Handling
```dart
try {
  await IAPManager.instance.purchase(productId);
} on IAPError catch (e) {
  switch (e.type) {
    case IAPErrorType.productNotFound:
      // Handle product not found
      break;
    case IAPErrorType.network:
      // Handle network error
      break;
  }
}
```

### 4. Logging
```dart
class CustomLogger implements IAPLoggerListener {
  @override
  void onLog(String message, {LogLevel level = LogLevel.info}) {
    print('[$level] $message');
  }
}
// Register logger
IAPManager.instance.initialize(
  loggerListener: CustomLogger(),
);
```

## Platform-Specific Setup
### iOS Setup
1. Add In-App Purchase capability in Xcode
2. Configure products in App Store Connect
3. Update Info.plist:
```xml
<key>SKPaymentTransactionObserverEnable</key>
<true/>
```

### Android Setup
1. Configure products in Google Play Console
2. Update AndroidManifest.xml:
```xml
<uses-permission android:name="com.android.vending.BILLING" />
```

## Best Practices
1. Always verify purchases server-side
2. Implement proper error handling
3. Cache product information
4. Test with test accounts
5. Handle interrupted purchases