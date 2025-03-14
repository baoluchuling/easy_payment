import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences.dart';
import 'iap_purchase_info.dart';

/// IAP购买状态存储管理器
class IAPPurchaseStateStorage {
  /// SharedPreferences 实例
  late final SharedPreferences _prefs;

  /// 持久化存储键
  static const String _stateKey = 'iap_purchase_states';
  
  /// 购买状态缓存
  final Map<String, IAPPurchaseInfo> _stateCache = {};

  /// 状态变更控制器
  final _stateController = StreamController<IAPPurchaseInfo>.broadcast();

  /// 获取状态变更流
  Stream<IAPPurchaseInfo> get stateStream => _stateController.stream;

  /// 初始化存储
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _restoreStates();
  }

  /// 恢复购买状态
  Future<void> _restoreStates() async {
    try {
      final String? savedStates = _prefs.getString(_stateKey);
      if (savedStates != null) {
        final List<dynamic> states = json.decode(savedStates);
        for (final state in states) {
          final purchaseInfo = IAPPurchaseInfo.fromJson(state);
          _stateCache[purchaseInfo.productId] = purchaseInfo;
        }
      }
    } catch (e) {
      debugPrint('Error restoring purchase states: $e');
    }
  }

  /// 保存购买状态
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

  /// 更新购买状态
  Future<void> updateState(IAPPurchaseInfo info) async {
    _stateCache[info.productId] = info;
    await _saveStates();
    _stateController.add(info);
  }

  /// 移除购买状态
  Future<void> removeState(String productId) async {
    _stateCache.remove(productId);
    await _saveStates();
  }

  /// 获取购买状态
  IAPPurchaseInfo? getState(String productId) {
    return _stateCache[productId];
  }

  /// 获取所有购买状态
  List<IAPPurchaseInfo> getAllStates() {
    return _stateCache.values.toList();
  }

  /// 获取未完成的购买
  List<IAPPurchaseInfo> getPendingStates() {
    return _stateCache.values
        .where((info) => !info.isTerminalState)
        .toList();
  }

  /// 获取已完成的购买
  List<IAPPurchaseInfo> getCompletedStates() {
    return _stateCache.values
        .where((info) => info.status == IAPPurchaseStatus.completed)
        .toList();
  }

  /// 清理已完成的购买记录
  Future<void> cleanupCompletedStates() async {
    _stateCache.removeWhere((_, info) => info.isTerminalState);
    await _saveStates();
  }

  /// 清理所有购买记录
  Future<void> clearAllStates() async {
    _stateCache.clear();
    await _saveStates();
  }

  /// 销毁存储
  void dispose() {
    _stateController.close();
    _stateCache.clear();
  }
} 