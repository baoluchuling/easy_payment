import 'package:flutter_test/flutter_test.dart';
import 'package:easy_payment/easy_payment.dart';
import 'package:easy_payment/easy_payment_platform_interface.dart';
import 'package:easy_payment/easy_payment_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEasyPaymentPlatform
    with MockPlatformInterfaceMixin
    implements EasyPaymentPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EasyPaymentPlatform initialPlatform = EasyPaymentPlatform.instance;

  test('$MethodChannelEasyPayment is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEasyPayment>());
  });

  test('getPlatformVersion', () async {
    EasyPayment easyPaymentPlugin = EasyPayment();
    MockEasyPaymentPlatform fakePlatform = MockEasyPaymentPlatform();
    EasyPaymentPlatform.instance = fakePlatform;

    expect(await easyPaymentPlugin.getPlatformVersion(), '42');
  });
}
