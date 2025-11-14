import 'package:intl/intl.dart';

import '../models/activation_state.dart';
import 'database_service.dart';

class ActivationService {
  static const transactionLimitBeforeActivation = 20;
  static const activationDuration = Duration(days: 360);

  final DatabaseService databaseService;

  ActivationService(this.databaseService);

  Future<ActivationState> loadState() async {
    final map = await databaseService.readActivation();
    if (map == null) {
      throw StateError('Activation row is missing');
    }
    final untilRaw = map['activated_until'] as String?;
    return ActivationState(
      deviceCode: map['device_code'] as String,
      activatedUntil: untilRaw == null ? null : DateTime.parse(untilRaw),
      isLocked: _isExpired(untilRaw),
    );
  }

  bool _isExpired(String? untilRaw) {
    if (untilRaw == null) {
      return true;
    }
    final until = DateTime.parse(untilRaw);
    return until.isBefore(DateTime.now());
  }

  Future<ActivationState> refreshDeviceCode() async {
    final newCode = DatabaseService.generateDeviceCodeSeed();
    await databaseService.updateActivation({
      'device_code': newCode,
      'activated_until': null,
    });
    return loadState();
  }

  String buildUnlockCode(String deviceCode) {
    final sanitized = deviceCode.replaceAll('-', '').toUpperCase();
    final reversed = sanitized.split('').reversed.join();
    return 'AR${reversed.substring(0, reversed.length.clamp(0, 10))}';
  }

  Future<ActivationState> activateWithCode(String code) async {
    final state = await loadState();
    final expected = buildUnlockCode(state.deviceCode);
    if (code.toUpperCase().trim() != expected) {
      throw ArgumentError('رمز التفعيل غير صحيح');
    }
    final until = DateTime.now().add(activationDuration);
    await databaseService.updateActivation({
      'activated_until': until.toIso8601String(),
    });
    return ActivationState(deviceCode: state.deviceCode, activatedUntil: until, isLocked: false);
  }

  String humanReadableExpiry(DateTime? date) {
    if (date == null) return 'غير مفعل';
    final format = DateFormat('dd/MM/yyyy');
    return format.format(date);
  }
}
