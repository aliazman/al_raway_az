import 'package:flutter/material.dart';

import '../models/account.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.account,
    required this.onDailySales,
  });

  final Account account;
  final VoidCallback onDailySales;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: account.type.badgeColor,
                  child: Text(account.type.label.substring(0, 1)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(account.name, style: Theme.of(context).textTheme.titleMedium),
                      Text(account.phone, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Text(account.type.label, style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('المستخدم: ${account.username}'),
                    Text('كلمة المرور: ${account.password}'),
                  ],
                ),
                FilledButton.icon(
                  onPressed: onDailySales,
                  icon: const Icon(Icons.point_of_sale),
                  label: const Text('البيع اليومي'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
