# Easy Payment Internationalization

## Overview

Easy Payment provides comprehensive internationalization support for:
- Error messages
- Status messages
- Log messages
- UI elements

## Quick Start

The fastest way to enable internationalization is to use the default implementations with your preferred locale:

```dart
await IAPManager.instance.initialize(
  config: IAPConfig(
    errorLocalizations: DefaultIAPErrorLocalizations('en'),
    statusLocalizations: DefaultIAPStatusLocalizations('en'),
    logLocalizations: DefaultIAPLogLocalizations('en'),
  ),
);
```

## Custom Implementation

### Error Messages

Create a custom implementation of `IAPErrorLocalizations`:

```dart
class EnglishErrorLocalizations implements IAPErrorLocalizations {
  @override
  String getErrorMessage(IAPError error) {
    switch (error.type) {
      case IAPErrorType.network:
        return 'Network error occurred. Please try again.';
      case IAPErrorType.productNotFound:
        return 'Product not found.';
      case IAPErrorType.userCancelled:
        return 'Purchase cancelled.';
      case IAPErrorType.paymentInvalid:
        return 'Invalid payment details.';
      default:
        return 'An error occurred: ${error.message}';
    }
  }
}
```

### Status Messages

Implement `IAPStatusLocalizations` for purchase status messages:

```dart
class EnglishStatusLocalizations implements IAPStatusLocalizations {
  @override
  String getStatusText(IAPPurchaseStatus status) {
    switch (status) {
      case IAPPurchaseStatus.pending:
        return 'Processing purchase...';
      case IAPPurchaseStatus.processing:
        return 'Verifying payment...';
      case IAPPurchaseStatus.completed:
        return 'Purchase completed successfully';
      case IAPPurchaseStatus.failed:
        return 'Purchase failed';
      case IAPPurchaseStatus.cancelled:
        return 'Purchase cancelled by user';
    }
  }
}
```

### Log Messages

Create a custom `IAPLogLocalizations` implementation:

```dart
class EnglishLogLocalizations implements IAPLogLocalizations {
  @override
  String getLogMessage(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'purchase_start':
        return 'Starting purchase for product: ${data['product_id']}';
      case 'order_created':
        return 'Order created successfully (ID: ${data['order_id']})';
      case 'purchase_verification':
        return 'Purchase verification ${data['success'] ? 'successful' : 'failed'}';
      case 'purchase_complete':
        return 'Purchase ${data['success'] ? 'completed successfully' : 'failed'}';
      default:
        return 'Unknown event: $type';
    }
  }
}
```

## Best Practices

### Consistent Terminology

Maintain consistent terminology across your application:
- Use "purchase" instead of mixing "buy" and "purchase"
- Maintain consistent capitalization and punctuation
- Use clear and concise error messages

### Fallback Support

Always provide fallback translations:

```dart
String getMessage(String key) {
  return translations[key] ?? defaultTranslations[key] ?? key;
}
```

### Testing

Test your translations:
- Verify all message strings are translated
- Check string formatting with different data
- Test edge cases (long text, special characters)
- Validate message rendering in UI

### String Formatting

Handle string formatting carefully:
- Use named parameters for clarity
- Consider text length variations
- Handle null values gracefully
- Support plural forms when needed

## Integration Example

Here's a complete example of integrating custom localizations:

```dart
// Initialize with custom English localizations
final manager = IAPManager.instance;
await manager.initialize(
  service: DefaultIAPService(),
  config: IAPConfig(
    errorLocalizations: EnglishErrorLocalizations(),
    statusLocalizations: EnglishStatusLocalizations(),
    logLocalizations: EnglishLogLocalizations(),
  ),
);

// Start a purchase with localized messages
try {
  final result = await manager.purchase(
    productId: 'premium_subscription'
  );
  if (result.success) {
    print('Purchase completed successfully');
  }
} catch (error) {
  // Error messages will be automatically localized
  print(error.localizedMessage);
}
```