import 'package:flutter/material.dart';

import '../screens/change_password_screen.dart';
import '../screens/change_pin_code_screen.dart';
import '../screens/pin_code_entry_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'إعدادات الأمان',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('تغيير كلمة المرور'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.pin),
              title: const Text('إدخال رمز PIN'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PinCodeEntryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.password),
              title: const Text('تغيير رمز PIN'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ChangePinCodeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
