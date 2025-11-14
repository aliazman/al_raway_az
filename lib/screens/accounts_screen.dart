import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/account.dart';
import '../providers/account_provider.dart';
import '../providers/activation_provider.dart';
import '../ui/forms.dart';
import '../widgets/account_card.dart';
import 'daily_sales_screen.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AccountProvider, ActivationProvider>(
      builder: (context, accounts, activation, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('حسابات الرعوي'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  onChanged: accounts.setFilterQuery,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'بحث بالاسم أو الهاتف',
                  ),
                ),
              ),
            ),
          ),
          body: accounts.isLoading
              ? const Center(child: CircularProgressIndicator())
              : accounts.filteredAccounts.isEmpty
                  ? const Center(child: Text('لا توجد حسابات بعد'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: accounts.filteredAccounts.length,
                      itemBuilder: (context, index) {
                        final account = accounts.filteredAccounts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AccountCard(
                            account: account,
                            onDailySales: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DailySalesScreen(account: account),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('عمليات البيع المدخلة: ${accounts.salesCount}/${activation.limit} قبل التفعيل'),
                Text('حالة التفعيل: ${activation.humanReadableExpiry()}'),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => showAddAccountSheet(context),
            icon: const Icon(Icons.person_add),
            label: const Text('إضافة حساب'),
          ),
        );
      },
    );
  }
}
