# Easy Payment Testing Guide

## Test Environment Setup
### iOS Test Environment
1. Create Sandbox Account:
- Go to App Store Connect > Users and Access > Sandbox
- Create a new sandbox tester account
- Log out of production Apple ID on test device
- Log in with sandbox account

2. Configure Test Products:
- Set up products in App Store Connect
- Use test product IDs in development
- Set test prices and descriptions

### Android Test Environment
1. Test Account Setup:
- Create test accounts in Google Play Console
- Add test users to closed testing track
- Configure license testing

2. Test Product Configuration:
- Set up products in Google Play Console
- Enable test purchases
- Configure test SKUs

## Testing Methods
### 1. Unit Testing
```dart
void main() {
  group('IAPManager Tests', () {
    late IAPManager manager;
    late MockIAPService mockService;
    setUp(() {
      mockService = MockIAPService();
      manager = IAPManager.instance;
      manager.initialize(service: mockService);
    });

    test('purchase success test', () async {
      when(mockService.purchase(any))
          .thenAnswer((_) async => IAPResult.success());
      
      final result = await manager.purchase('test_product');
      expect(result.success, true);
    });

    test('purchase error test', () async {
      when(mockService.purchase(any))
          .thenThrow(IAPError(type: IAPErrorType.network));
      
      expect(
        () => manager.purchase('test_product'),
        throwsA(isA<IAPError>()),
      );
    });
  });
}
```

### 2. Integration Testing
```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('complete purchase flow test',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    // Test purchase button tap
    await tester.tap(find.byType(PurchaseButton));
    await tester.pumpAndSettle();
    // Verify purchase flow
    expect(find.byType(PurchaseDialog), findsOneWidget);
    
    // Complete purchase
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    // Verify success state
    expect(find.text('Purchase Successful'), findsOneWidget);
  });
}
```

### 3. Mock Implementation
```dart
class MockIAPService implements IAPService {
  @override
  Future<IAPResult> createOrder({
    required String productId,
    String? businessProductId,
  }) async {
    return IAPResult.success(
      orderId: 'mock_order_123',
      productId: productId,
    );
  }

  @override
  Future<IAPResult> verifyPurchase({
    required String productId,
    String? orderId,
    String? receiptData,
  }) async {
    return IAPResult.success();
  }
}
```

## Test Cases
### Basic Test Cases
1. Product Query
2. Purchase Flow
3. Error Handling
4. State Management
5. Receipt Validation

### Edge Cases
1. Network Issues
2. Interrupted Purchases
3. Invalid Products
4. Concurrent Purchases
5. State Recovery

## Debugging Tips
1. Enable Debug Logging:
```dart
IAPManager.instance.initialize(
  config: IAPConfig(
    debugMode: true,
    logLevel: LogLevel.verbose,
  ),
);
```

2. Monitor Purchase States
3. Verify Server Communication
4. Check Platform Logs