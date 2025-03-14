# Easy Payment 集成指南

## 安装
在 `pubspec.yaml` 中添加依赖：
```yaml
dependencies:
  easy_payment: ^latest_version
```

## 基础配置
### 1. 初始化插件
```dart
void main() async {
  // 在 runApp 之前初始化
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

### 2. 配置商品
创建商品 ID：
```dart
class ProductIds {
  static const consumable = 'com.example.coins';
  static const nonConsumable = 'com.example.premium';
}
```

### 3. 实现基础购买流程
```dart
Future<void> purchaseProduct(String productId) async {
  try {
    final result = await IAPManager.instance.purchase(productId);
    if (result.success) {
      // 处理成功购买
    }
  } on IAPError catch (e) {
    // 处理错误
  }
}
```

## 高级功能
### 1. 购买状态管理
```dart
// 监听购买更新
IAPManager.instance.addPurchaseListener((info) {
  if (info.state == IAPPurchaseState.purchased) {
    // 处理购买完成
  }
});
```

### 2. 自定义服务实现
```dart
class CustomIAPService implements IAPService {
  @override
  Future<IAPResult> createOrder({
    required String productId,
    String? businessProductId,
  }) async {
    // 实现自定义订单创建
  }
  
  // 实现其他必需方法
}
// 使用自定义服务
await IAPManager.instance.initialize(
  service: CustomIAPService(),
);
```

### 3. 错误处理
```dart
try {
  await IAPManager.instance.purchase(productId);
} on IAPError catch (e) {
  switch (e.type) {
    case IAPErrorType.productNotFound:
      // 处理商品未找到
      break;
    case IAPErrorType.network:
      // 处理网络错误
      break;
  }
}
```

### 4. 日志记录
```dart
class CustomLogger implements IAPLoggerListener {
  @override
  void onLog(String message, {LogLevel level = LogLevel.info}) {
    print('[$level] $message');
  }
}
// 注册日志记录器
IAPManager.instance.initialize(
  loggerListener: CustomLogger(),
);
```

## 平台特定配置
### iOS 配置
1. 在 Xcode 中添加应用内购买功能
2. 在 App Store Connect 中配置商品
3. 更新 Info.plist：
```xml
<key>SKPaymentTransactionObserverEnable</key>
<true/>
```

### Android 配置
1. 在 Google Play Console 中配置商品
2. 更新 AndroidManifest.xml：
```xml
<uses-permission android:name="com.android.vending.BILLING" />
```

## 最佳实践
1. 总是在服务端验证购买
2. 实现适当的错误处理
3. 缓存商品信息
4. 使用测试账号进行测试
5. 处理中断的购买