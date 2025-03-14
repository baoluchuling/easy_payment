import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_payment/easy_payment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Payment Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 支持本地化
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // 英文
        Locale('zh'), // 中文
      ],
      home: const PaymentDemo(),
    );
  }
}

/// 中文错误消息
class ChineseErrorLocalizations implements IAPErrorLocalizations {
  const ChineseErrorLocalizations();

  @override
  String getErrorMessage(IAPErrorType type, [String? details]) {
    switch (type) {
      case IAPErrorType.notInitialized:
        return '支付系统未初始化';
      case IAPErrorType.productNotFound:
        return '商品不存在';
      case IAPErrorType.duplicatePurchase:
        return '已有未完成的购买';
      case IAPErrorType.paymentInvalid:
        return '支付无效';
      case IAPErrorType.serverVerifyFailed:
        return '服务端验证失败：${details ?? ''}';
      case IAPErrorType.network:
        return '网络错误：${details ?? ''}';
      case IAPErrorType.unknown:
        return '未知错误：${details ?? ''}';
    }
  }
}

/// 中文状态文本
class ChineseStatusLocalizations implements IAPStatusLocalizations {
  const ChineseStatusLocalizations();

  @override
  String getStatusText(IAPPurchaseStatus status) {
    switch (status) {
      case IAPPurchaseStatus.pending:
        return '等待中';
      case IAPPurchaseStatus.processing:
        return '处理中';
      case IAPPurchaseStatus.completed:
        return '已完成';
      case IAPPurchaseStatus.failed:
        return '失败';
      case IAPPurchaseStatus.cancelled:
        return '已取消';
    }
  }
}

/// 中文日志消息
class ChineseLogLocalizations implements IAPLogLocalizations {
  const ChineseLogLocalizations();

  @override
  String getLogMessage(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'purchase_start':
        return '开始购买商品: ${data['product_id']}';
      case 'order_created':
        return '订单已创建: ${data['order_id']}';
      case 'purchase_verification':
        return '购买验证${data['success'] ? '成功' : '失败'}';
      case 'purchase_complete':
        return '购买${data['success'] ? '完成' : '失败'}';
      case 'error':
        return '发生错误: ${data['message']}';
      case 'debug':
        return '[调试] ${data['message']}';
      case 'verbose':
        return '[详细] ${data['message']}';
      default:
        return '未知日志类型: $type';
    }
  }
}

/// 自定义日志监听器
class CustomLoggerListener implements IAPLoggerListener {
  @override
  void onLog(String type, Map<String, dynamic> data) {
    debugPrint('收到日志：[$type] ${data.toString()}');
  }
}

class PaymentDemo extends StatefulWidget {
  const PaymentDemo({super.key});

  @override
  State<PaymentDemo> createState() => _PaymentDemoState();
}

class _PaymentDemoState extends State<PaymentDemo> {
  late final IAPManager iapManager;
  String _purchaseStatus = '未开始购买';
  bool _loading = false;
  
  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    iapManager = IAPManager.instance;
    await iapManager.initialize(
      service: DefaultIAPService(),
      config: IAPConfig(
        // 使用中文本地化
        errorLocalizations: const ChineseErrorLocalizations(),
        statusLocalizations: const ChineseStatusLocalizations(),
        logLocalizations: const ChineseLogLocalizations(),
        // 启用调试模式和详细日志
        debugMode: true,
        logLevel: LogLevel.verbose,
      ),
      // 添加自定义日志监听器
      loggerListener: CustomLoggerListener(),
    );
  }

  Future<void> _startPurchase() async {
    setState(() {
      _loading = true;
      _purchaseStatus = '处理中...';
    });

    try {
      final result = await iapManager.purchase(
        'test_product',
        businessProductId: 'biz_123',
      );

      setState(() {
        _purchaseStatus = result.success ? '购买成功！' : '购买失败：${result.error}';
      });
    } on IAPError catch (e) {
      setState(() {
        _purchaseStatus = '发生错误：${e.message}';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支付演示'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_purchaseStatus),
            const SizedBox(height: 20),
            if (_loading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _startPurchase,
                child: const Text('测试购买'),
              ),
          ],
        ),
      ),
    );
  }
}
