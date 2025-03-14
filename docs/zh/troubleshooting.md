# Easy Payment 故障排除

## 常见问题
### 1. 购买流程问题
#### 症状
- 购买对话框不显示
- 购买卡在处理中
- 购买完成但商品未到账

#### 解决方案
1. 检查初始化：
```dart
// 验证正确初始化
await IAPManager.instance.initialize(
  config: IAPConfig(debugMode: true),
);
```
2. 验证商品 ID 与平台配置匹配
3. 检查购买监听器实现
4. 在服务端验证收据

### 2. 网络问题
#### 症状
- 超时错误
- 连接失败
- 服务器验证错误

#### 解决方案
1. 实现重试逻辑：
```dart
final config = IAPConfig(
  retryOptions: RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(seconds: 2),
  ),
);
```
2. 添加网络状态监控
3. 处理离线场景

### 3. 平台特定问题
#### iOS 问题
1. 沙盒环境不工作：
   - 验证沙盒账号设置
   - 检查设备登录状态
   - 清理 App Store 缓存

2. StoreKit 错误：
   - 验证商品配置
   - 检查授权状态
   - 验证收据格式

#### Android 问题
1. 计费权限错误：
   - 检查清单配置
   - 验证包名
   - 使用许可测试账号测试

2. 购买令牌问题：
   - 验证订单状态
   - 检查 Google Play 计费库版本
   - 清理 Play Store 缓存

### 4. 状态管理问题
#### 症状
- 购买状态不一致
- 丢失购买记录
- 重复交易

#### 解决方案
1. 实现状态持久化：
```dart
class CustomStateStorage implements IAPPurchaseStateStorage {
  @override
  Future<void> savePurchaseState(String productId, IAPPurchaseState state) async {
    // 实现持久化存储
  }

  @override
  Future<IAPPurchaseState?> getPurchaseState(String productId) async {
    // 获取存储的状态
  }
}
```
2. 添加状态恢复机制
3. 处理中断的购买

## 调试工具
### 1. 调试模式
启用详细日志：
```dart
IAPManager.instance.initialize(
  config: IAPConfig(
    debugMode: true,
    logLevel: LogLevel.verbose,
  ),
);
```

### 2. 错误分析
常见错误类型及解决方案：
- `IAPErrorType.productNotFound`: 验证商品 ID 配置
- `IAPErrorType.network`: 检查网络连接
- `IAPErrorType.userCancelled`: 正常用户取消
- `IAPErrorType.serverVerifyFailed`: 检查服务器验证逻辑

### 3. 平台工具
- iOS：使用 App Store Connect 沙盒测试
- Android：使用 Google Play Console 测试工具