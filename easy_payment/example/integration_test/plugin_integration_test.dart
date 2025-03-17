// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:easy_payment/easy_payment.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('plugin integration test', (WidgetTester tester) async {
    // Initialize the plugin and perform integration tests.
    final manager = EasyPaymentManager.instance;
    await manager.initialize(
      service: DefaultIAPService(),
      config: IAPConfig(
        debugMode: true,
        logLevel: LogLevel.verbose,
      ),
    );

    // Perform integration tests here.
  });
}
