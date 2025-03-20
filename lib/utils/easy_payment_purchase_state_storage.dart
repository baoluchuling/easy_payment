import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/easy_payment_purchase_info.dart';
import '../models/easy_payment_result.dart';

/// IAP purchase state storage manager
class EasyPaymentPurchaseStateStorage {
  /// SharedPreferences instance
  late final SharedPreferences _prefs;

  /// Persistent storage key
  static const String _stateKey = 'iap_purchase_states';

  /// Purchase state cache
  final Map<String, EasyPaymentPurchaseInfo> _stateCache = {};

  /// State change controller
  final _stateController = StreamController<EasyPaymentPurchaseInfo>.broadcast();

  /// Get state change stream
  Stream<EasyPaymentPurchaseInfo> get stateStream => _stateController.stream;

  /// Initialize storage
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _restoreStates();
  }

  /// Restore purchase states
  Future<void> _restoreStates() async {
    try {
      final String? savedStates = _prefs.getString(_stateKey);
      if (savedStates != null) {
        final List<dynamic> states = json.decode(savedStates);
        for (final state in states) {
          final purchaseInfo = EasyPaymentPurchaseInfo.fromJson(state);
          _stateCache[purchaseInfo.productId] = purchaseInfo;
        }
      }
    } catch (e) {
      debugPrint('Error restoring purchase states: $e');
    }
  }

  /// Save purchase states
  Future<void> _saveStates() async {
    try {
      final List<Map<String, dynamic>> states = _stateCache.values
          .map((info) => info.toJson())
          .toList();
      await _prefs.setString(_stateKey, json.encode(states));
    } catch (e) {
      debugPrint('Error saving purchase states: $e');
    }
  }

  /// Update purchase state
  Future<void> updateState(EasyPaymentPurchaseInfo info) async {
    _stateCache[info.productId] = info;
    await _saveStates();
    _stateController.add(info);
  }

  /// Remove purchase state
  Future<void> removeState(String productId) async {
    _stateCache.remove(productId);
    await _saveStates();
  }

  /// Get purchase state
  EasyPaymentPurchaseInfo? getState(String productId) {
    return _stateCache[productId];
  }

  /// Get all purchase states
  List<EasyPaymentPurchaseInfo> getAllStates() {
    return _stateCache.values.toList();
  }

  /// Get pending purchases
  List<EasyPaymentPurchaseInfo> getPendingStates() {
    return _stateCache.values
        .where((info) => !info.isTerminalState)
        .toList();
  }

  /// Get completed purchases
  List<EasyPaymentPurchaseInfo> getCompletedStates() {
    return _stateCache.values
        .where((info) => info.status == EasyPaymentPurchaseStatus.success)
        .toList();
  }

  /// Cleanup completed purchases
  Future<void> cleanupCompletedStates() async {
    _stateCache.removeWhere((_, info) => info.isTerminalState);
    await _saveStates();
  }

  /// Clear all purchase records
  Future<void> clearAllStates() async {
    _stateCache.clear();
    await _saveStates();
  }

  /// Dispose storage
  void dispose() {
    _stateController.close();
    _stateCache.clear();
  }
}