# Easy Payment Troubleshooting

## Common Issues
### 1. Purchase Flow Issues
#### Symptoms
- Purchase dialog doesn't appear
- Purchase stuck in processing
- Purchase completed but product not delivered

#### Solutions
1. Check initialization:
```dart
// Verify proper initialization
await IAPManager.instance.initialize(
  config: IAPConfig(debugMode: true),
);
```
2. Verify product IDs match platform configuration
3. Check purchase listener implementation
4. Validate receipt on server-side

### 2. Network Issues
#### Symptoms
- Timeout errors
- Connection failures
- Server verification errors

#### Solutions
1. Implement retry logic:
```dart
final config = IAPConfig(
  retryOptions: RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(seconds: 2),
  ),
);
```
2. Add network state monitoring
3. Handle offline scenarios

### 3. Platform-Specific Issues
#### iOS Issues
1. Sandbox environment not working:
   - Verify sandbox account setup
   - Check device login state
   - Clear App Store cache

2. StoreKit errors:
   - Validate product configuration
   - Check authorization status
   - Verify receipt format

#### Android Issues
1. Billing permission errors:
   - Check manifest configuration
   - Verify package name
   - Test with license testing account

2. Purchase token issues:
   - Validate order status
   - Check Google Play billing library version
   - Clear Play Store cache

### 4. State Management Issues
#### Symptoms
- Inconsistent purchase states
- Missing purchase records
- Duplicate transactions

#### Solutions
1. Implement state persistence:
```dart
class CustomStateStorage implements IAPPurchaseStateStorage {
  @override
  Future<void> savePurchaseState(String productId, IAPPurchaseState state) async {
    // Implement persistent storage
  }

  @override
  Future<IAPPurchaseState?> getPurchaseState(String productId) async {
    // Retrieve stored state
  }
}
```
2. Add state recovery mechanism
3. Handle interrupted purchases

## Debugging Tools
### 1. Debug Mode
Enable verbose logging:
```dart
IAPManager.instance.initialize(
  config: IAPConfig(
    debugMode: true,
    logLevel: LogLevel.verbose,
  ),
);
```

### 2. Error Analysis
Common error types and solutions:
- `IAPErrorType.productNotFound`: Verify product ID configuration
- `IAPErrorType.network`: Check network connectivity
- `IAPErrorType.userCancelled`: Normal user cancellation
- `IAPErrorType.serverVerifyFailed`: Check server verification logic

### 3. Platform Tools
- iOS: Use App Store Connect sandbox testing
- Android: Use Google Play Console testing tools