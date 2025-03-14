# Easy Payment 常见问题解答

## 基础信息

### Q: Easy Payment 支持哪些支付平台？
A: 目前支持：
- iOS App Store 应用内购买
- Google Play Store 应用内购买

### Q: 如何初始化支付插件？
A: 在应用启动时初始化：

```dart
void initializePayment() async {
  final manager = IAPManager.instance;
  
  try {
    await manager.initialize(
      service: MyIAPService(),
      loggerListener: MyLoggerListener(),
      config: IAPConfig(
        retryOptions: RetryOptions(
          maxAttempts: 3,
          delayFactor: Duration(seconds: 1),
          maxDelay: Duration(seconds: 10),
        ),
        autoFinishTransaction: true,
        errorLocalizations: MyErrorLocalizations(),
        statusLocalizations: MyStatusLocalizations(),
        logLocalizations: MyLogLocalizations(),
      ),
    );
  } on IAPError catch (e) {
    print('支付初始化失败：${e.message}');
  }
}
```

### Q: 支持哪些类型的商品？
A: 支持以下类型：
```dart
// 1. 消耗型商品（例如：游戏币）
final result = await manager.purchase(
  'com.example.coins',
  type: IAPProductType.consumable,
);

// 2. 非消耗型商品（例如：高级功能）
final result = await manager.purchase(
  'com.example.premium',
  type: IAPProductType.nonConsumable,
);
```

## 集成相关

### Q: 如何实现自定义支付服务？
A: 实现 IAPService 接口：

```dart
class MyIAPService implements IAPService {
  @override
  Future<IAPResult> createOrder({
    required String productId,
    String? businessProductId,
  }) async {
    // 实现订单创建逻辑
  }

  @override
  Future<IAPResult> verifyPurchase({
    required String productId,
    String? orderId,
    String? transactionId,
    String? receiptData,
    String? businessProductId,
  }) async {
    // 实现购买验证逻辑
  }

  @override
  Future<IAPResult> getProducts() async {
    // 实现商品获取逻辑
  }
}
```

## 错误处理

### Q: 如何处理错误？
A: 插件提供全面的错误处理：

1. 配置重试选项：
```dart
final config = IAPConfig(
  retryOptions: RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(seconds: 1),
    maxDelay: Duration(seconds: 10),
  ),
);
```

2. 处理特定错误类型：
```dart
try {
  final result = await manager.purchase('product_id');
} on IAPError catch (e) {
  switch (e.type) {
    case IAPErrorType.productNotFound:
      print('商品未找到：${e.message}');
      break;
    case IAPErrorType.network:
      print('网络错误：${e.message}');
      break;
    case IAPErrorType.serverVerifyFailed:
      print('验证失败：${e.message}');
      break;
  }
}
```

## 测试相关

### Q: 如何在开发环境测试？
A: 推荐以下步骤：
1. iOS:
   - 使用 Sandbox 测试账号
   - 在开发设备上测试
   - 使用测试商品 ID

2. Android:
   - 使用测试账号
   - 配置测试商品
   - 启用测试模式

## 性能优化

### Q: 如何优化性能？
A: 最佳实践：
1. 预加载商品信息
2. 实现状态缓存
3. 配置合适的重试策略
4. 优化网络请求

## 安全相关

### Q: 如何保证支付安全？
A: 多层面保护：
1. 使用 HTTPS 通信
2. 实现服务端验证
3. 加密敏感数据
4. 使用签名验证