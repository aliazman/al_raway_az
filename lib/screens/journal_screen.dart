import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/journal_entry.dart';
import '../providers/account_provider.dart';
import '../widgets/app_drawer.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('قيد اليومية')),
      body: FutureBuilder<List<JournalEntry>>(
        future: context.read<AccountProvider>().journalEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final entries = snapshot.data ?? [];
          if (entries.isEmpty) {
            return const Center(child: Text('لا توجد قيود مسجلة حتى الآن'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final formatter = DateFormat('dd/MM/yyyy');
              return ListTile(
                title: Text(entry.accountName),
                subtitle: Text('${entry.accountType.label} • ${formatter.format(entry.date)}'),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('إجمالي: ${entry.total.toStringAsFixed(2)}'),
                    Text('عمولة: ${entry.commission.toStringAsFixed(2)}'),
                    Text('صافي: ${entry.net.toStringAsFixed(2)}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
