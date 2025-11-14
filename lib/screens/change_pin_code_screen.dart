import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/security_provider.dart';

class ChangePinCodeScreen extends StatefulWidget {
  const ChangePinCodeScreen({super.key});

  @override
  State<ChangePinCodeScreen> createState() => _ChangePinCodeScreenState();
}

class _ChangePinCodeScreenState extends State<ChangePinCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    final security = context.read<SecurityProvider>();
    final hasPin = security.hasPin;
    final ok = await security.changePin(
      currentPin: hasPin ? _currentController.text : null,
      newPin: _newController.text,
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث رمز PIN بنجاح')),
      );
      Navigator.of(context).pop();
    } else {
      setState(() {
        _error = 'رمز PIN الحالي غير صحيح';
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPin = context.watch<SecurityProvider>().hasPin;
    return Scaffold(
      appBar: AppBar(title: const Text('تغيير رمز PIN')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasPin)
                TextFormField(
                  controller: _currentController,
                  decoration: const InputDecoration(labelText: 'رمز PIN الحالي'),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  validator: (value) => (value == null || value.isEmpty) ? 'مطلوب' : null,
                )
              else
                const Text('لا يوجد رمز PIN حاليًا، يمكنك إنشاء رمز جديد مباشرةً.'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _newController,
                decoration: const InputDecoration(labelText: 'رمز PIN الجديد'),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'مطلوب';
                  if (value.length < 4) return 'يجب أن يتكون من 4 أرقام على الأقل';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                decoration: const InputDecoration(labelText: 'تأكيد رمز PIN'),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'مطلوب';
                  if (value != _newController.text) return 'الرمزان غير متطابقين';
                  return null;
                },
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
                      : const Text('حفظ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
