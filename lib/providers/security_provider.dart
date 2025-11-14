import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityProvider extends ChangeNotifier {
  static const _passwordKey = 'security_password';
  static const _pinKey = 'security_pin';

  SharedPreferences? _prefs;
  String _password = 'admin123';
  String? _pinCode;
  bool _loaded = false;
  bool _pinVerified = false;

  bool get isLoaded => _loaded;
  String get password => _password;
  bool get hasPin => _pinCode != null && _pinCode!.isNotEmpty;
  bool get needsPinEntry => hasPin && !_pinVerified;
  bool get pinVerified => _pinVerified;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    _password = _prefs!.getString(_passwordKey) ?? 'admin123';
    final storedPin = _prefs!.getString(_pinKey);
    _pinCode = storedPin?.isEmpty ?? true ? null : storedPin;
    _pinVerified = false;
    _loaded = true;
    notifyListeners();
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (currentPassword != _password) {
      return false;
    }
    _password = newPassword;
    await _prefs?.setString(_passwordKey, newPassword);
    notifyListeners();
    return true;
  }

  Future<bool> changePin({String? currentPin, required String newPin}) async {
    if (hasPin) {
      if (currentPin == null || currentPin != _pinCode) {
        return false;
      }
    }
    _pinCode = newPin;
    _pinVerified = false;
    if (newPin.isEmpty) {
      await _prefs?.remove(_pinKey);
    } else {
      await _prefs?.setString(_pinKey, newPin);
    }
    notifyListeners();
    return true;
  }

  Future<bool> verifyPin(String input) async {
    if (!hasPin) return true;
    if (input == _pinCode) {
      _pinVerified = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void resetPinVerification() {
    _pinVerified = false;
    notifyListeners();
  }
}
