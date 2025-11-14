import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/security_provider.dart';

class PinCodeEntryScreen extends StatefulWidget {
  const PinCodeEntryScreen({super.key, this.requireUnlock = false});

  final bool requireUnlock;

  @override
  State<PinCodeEntryScreen> createState() => _PinCodeEntryScreenState();
}

class _PinCodeEntryScreenState extends State<PinCodeEntryScreen> {
  final _pinController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    final security = context.read<SecurityProvider>();
    final ok = await security.verifyPin(_pinController.text);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم فتح التطبيق')), 
      );
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isSubmitting = false;
        _error = 'رمز PIN غير صحيح';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final security = context.watch<SecurityProvider>();
    return WillPopScope(
      onWillPop: () async => !widget.requireUnlock,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !widget.requireUnlock,
          title: const Text('إدخال رمز PIN'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: security.hasPin
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('يرجى إدخال رمز PIN للمتابعة'),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'رمز PIN'),
                    ),
                    const SizedBox(height: 16),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(_error!, style: const TextStyle(color: Colors.red)),
                      ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
                            : const Text('تأكيد'),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text('لا يوجد رمز PIN مُسجل. الرجاء إنشاء رمز من شاشة تغيير PIN.'),
                ),
        ),
      ),
    );
  }
}
