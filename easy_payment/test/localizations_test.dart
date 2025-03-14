import 'package:flutter_test/flutter_test.dart';
import 'package:easy_payment/easy_payment.dart';

void main() {
  group('Localizations Tests', () {
    test('Default error messages should be in English', () {
      final localizations = DefaultIAPErrorLocalizations();
      expect(
        localizations.getErrorMessage(IAPErrorType.notInitialized),
        'Payment system is not initialized',
      );
      expect(
        localizations.getErrorMessage(IAPErrorType.productNotFound),
        'Product not found',
      );
    });

    test('Chinese error messages should be in Chinese', () {
      final localizations = ChineseErrorLocalizations();
      expect(
        localizations.getErrorMessage(IAPErrorType.notInitialized),
        '支付系统未初始化',
      );
      expect(
        localizations.getErrorMessage(IAPErrorType.productNotFound),
        '商品不存在',
      );
    });

    test('Default status text should be in English', () {
      final localizations = DefaultIAPStatusLocalizations();
      expect(
        localizations.getStatusText(IAPPurchaseStatus.pending),
        'Pending',
      );
      expect(
        localizations.getStatusText(IAPPurchaseStatus.completed),
        'Completed',
      );
    });

    test('Chinese status text should be in Chinese', () {
      final localizations = ChineseStatusLocalizations();
      expect(
        localizations.getStatusText(IAPPurchaseStatus.pending),
        '等待中',
      );
      expect(
        localizations.getStatusText(IAPPurchaseStatus.completed),
        '已完成',
      );
    });

    test('Default log messages should be in English', () {
      final localizations = DefaultIAPLogLocalizations();
      expect(
        localizations.getLogMessage('purchase_start', {'product_id': 'test_product'}),
        'Starting purchase: test_product',
      );
      expect(
        localizations.getLogMessage('purchase_complete', {'success': true}),
        'Purchase completed',
      );
    });

    test('Chinese log messages should be in Chinese', () {
      final localizations = ChineseLogLocalizations();
      expect(
        localizations.getLogMessage('purchase_start', {'product_id': 'test_product'}),
        '开始购买商品: test_product',
      );
      expect(
        localizations.getLogMessage('purchase_complete', {'success': true}),
        '购买完成',
      );
    });
  });

  group('IAPError with Localizations', () {
    test('Error messages should use configured localizations', () {
      // 使用默认英文
      IAPError.setConfig(IAPConfig());
      final error = IAPError.notInitialized();
      expect(error.message, 'Payment system is not initialized');

      // 切换到中文
      IAPError.setConfig(IAPConfig(
        errorLocalizations: ChineseErrorLocalizations(),
      ));
      expect(error.message, '支付系统未初始化');
    });
  });
}