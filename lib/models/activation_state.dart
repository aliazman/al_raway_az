class ActivationState {
  final String deviceCode;
  final DateTime? activatedUntil;
  final bool isLocked;

  const ActivationState({
    required this.deviceCode,
    required this.activatedUntil,
    required this.isLocked,
  });

  bool get isActive {
    if (activatedUntil == null) {
      return false;
    }
    return activatedUntil!.isAfter(DateTime.now());
  }
}
