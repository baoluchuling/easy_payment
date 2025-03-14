# Easy Payment 测试指南

## 测试环境配置
### iOS 测试环境
1. 创建沙盒账号：
- 进入 App Store Connect > 用户与访问 > 沙盒
- 创建新的沙盒测试账号
- 在测试设备上登出正式 Apple ID
- 登录沙盒账号

2. 配置测试商品：
- 在 App Store Connect 设置商品
- 在开发中使用测试商品 ID
- 设置测试价格和描述

### Android 测试环境
1. 测试账号设置：
- 在 Google Play Console 创建测试账号
- 将测试用户添加到封闭测试轨道
- 配置许可测试

2. 测试商品配置：
- 在 Google Play Console 设置商品
- 启用测试购买
- 配置测试 SKU

## 测试方法
### 1. 单元测试
```dart
void main() {
  group('IAPManager 测试', () {
    late IAPManager manager;
    late MockIAPService mockService;
    setUp(() {
      mockService = MockIAPService();
      manager = IAPManager.instance;
      manager.initialize(service: mockService);
    });

    test('购买成功测试', () async {
      when(mockService.purchase(any))
          .thenAnswer((_) async => IAPResult.success());
      
      final result = await manager.purchase('test_product');
      expect(result.success, true);
    });

    test('购买错误测试', () async {
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

### 2. 集成测试
```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('完整购买流程测试',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    // 测试购买按钮点击
    await tester.tap(find.byType(PurchaseButton));
    await tester.pumpAndSettle();
    // 验证购买流程
    expect(find.byType(PurchaseDialog), findsOneWidget);
    
    // 完成购买
    await tester.tap(find.text('确认'));
    await tester.pumpAndSettle();
    // 验证成功状态
    expect(find.text('购买成功'), findsOneWidget);
  });
}
```

### 3. Mock 实现
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

## 测试用例
### 基础测试用例
1. 商品查询
2. 购买流程
3. 错误处理
4. 状态管理
5. 收据验证

### 边缘用例
1. 网络问题
2. 中断的购买
3. 无效商品
4. 并发购买
5. 状态恢复

## 调试技巧
1. 启用调试日志：
```dart
IAPManager.instance.initialize(
  config: IAPConfig(
    debugMode: true,
    logLevel: LogLevel.verbose,
  ),
);
```

2. 监控购买状态
3. 验证服务器通信
4. 检查平台日志