# Easy Payment Internationalization

## Overview
Easy Payment supports internationalization for:
- Error messages
- Status messages
- Log messages
- UI elements

## Implementation
### 1. Custom Error Messages
Implement `IAPErrorLocalizations`:
```dart
class MyErrorLocalizations implements IAPErrorLocalizations {
  @override
  String getErrorMessage(IAPError error) {
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

### 2. Status Messages
Implement `IAPStatusLocalizations`:
```dart
class MyStatusLocalizations implements IAPStatusLocalizations {
  @override
  String getPurchaseStateMessage(IAPPurchaseState state) {
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

### 3. Log Messages
Implement `IAPLogLocalizations`:
```dart
class MyLogLocalizations implements IAPLogLocalizations {
  @override
  String getLogMessage(String key, Map<String, dynamic> params) {
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

### 4. Configuration
Register localizations during initialization:
```dart
await IAPManager.instance.initialize(
  config: IAPConfig(
    errorLocalizations: MyErrorLocalizations(),
    statusLocalizations: MyStatusLocalizations(),
    logLocalizations: MyLogLocalizations(),
  ),
);
```

## Best Practices
1. Use consistent terminology
2. Support fallback translations
3. Test with different languages
4. Handle string formatting carefully

## Language Selection
Override language at runtime:
```dart
class DynamicLocalizations implements IAPErrorLocalizations {
  final String locale;
  
  DynamicLocalizations(this.locale);
  
  @override
  String getErrorMessage(IAPError error) {
    if (locale == 'zh') {
      // Return Chinese messages
    } else {
      // Return English messages
    }
  }
}
```