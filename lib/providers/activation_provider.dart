import 'package:flutter/material.dart';

import '../models/activation_state.dart';
import '../services/activation_service.dart';

class ActivationProvider extends ChangeNotifier {
  ActivationProvider(this._service);

  final ActivationService _service;
  ActivationState? _state;
  bool _isLoading = false;
  String? _error;

  ActivationState? get state => _state;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isActive => _state?.isActive ?? false;

  int get limit => ActivationService.transactionLimitBeforeActivation;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _state = await _service.loadState();
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> activate(String code) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _state = await _service.activateWithCode(code);
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshDeviceCode() async {
    _state = await _service.refreshDeviceCode();
    notifyListeners();
  }

  bool requiresActivation(int transactionCount) {
    return !isActive && transactionCount >= limit;
  }

  String humanReadableExpiry() {
    return _service.humanReadableExpiry(_state?.activatedUntil);
  }
}
