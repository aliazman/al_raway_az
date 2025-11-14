import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/activation_provider.dart';
import '../widgets/app_drawer.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<ActivationProvider>();
    if (provider.state == null) {
      provider.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('تفعيل النظام')),
      body: Consumer<ActivationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.state == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final deviceCode = provider.state?.deviceCode ?? '---';
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('تم إدخال 20 عملية. يرجى تفعيل الجهاز لإكمال الاستخدام.',
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 24),
                Text('رمز الجهاز', style: Theme.of(context).textTheme.titleMedium),
                SelectableText(deviceCode, style: Theme.of(context).textTheme.headlineSmall),
                TextButton.icon(
                  onPressed: provider.refreshDeviceCode,
                  icon: const Icon(Icons.refresh),
                  label: const Text('تجديد الرمز'),
                ),
                const SizedBox(height: 12),
                Text(
                  'قم بإرسال رمز الجهاز إلى المدير للحصول على رمز التفعيل المقابل. يتم إنشاء رمز التفعيل عن طريق قلب الحروف مع البادئة AR.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: 'رمز التفعيل من المدير'),
                ),
                const SizedBox(height: 12),
                if (provider.error != null)
                  Text(provider.error!, style: const TextStyle(color: Colors.red)),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            await provider.activate(controller.text);
                            if (provider.error == null && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تم التفعيل حتى ${provider.humanReadableExpiry()}')),
                              );
                            }
                          },
                    child: provider.isLoading ? const CircularProgressIndicator() : const Text('تفعيل لمدة 360 يومًا'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
