import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/account.dart';
import '../models/sale_transaction.dart';
import '../providers/account_provider.dart';

Future<void> showAddAccountSheet(BuildContext context) async {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  AccountType selectedType = AccountType.raawi;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('إضافة حساب جديد', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'اسم الحساب'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'رقم الهاتف'),
              keyboardType: TextInputType.phone,
            ),
            DropdownButton<AccountType>(
              value: selectedType,
              isExpanded: true,
              onChanged: (value) {
                if (value == null) return;
                setState(() => selectedType = value);
              },
              items: AccountType.values
                  .map((type) => DropdownMenuItem(value: type, child: Text(type.label)))
                  .toList(),
            ),
            TextField(
              controller: userController,
              decoration: const InputDecoration(labelText: 'اسم المستخدم'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'كلمة المرور'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton(
                onPressed: () async {
                  if (nameController.text.isEmpty || phoneController.text.isEmpty) return;
                  final account = Account(
                    name: nameController.text,
                    phone: phoneController.text,
                    type: selectedType,
                    username: userController.text,
                    password: passwordController.text,
                  );
                  await ctx.read<AccountProvider>().addAccount(account);
                  Navigator.of(ctx).pop();
                },
                child: const Text('حفظ'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
          );
        },
      );
    },
  );
}

Future<void> showAddSaleSheet(BuildContext context, Account account) async {
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final noteController = TextEditingController();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('بيع يومي لـ ${account.name}', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'الكمية'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'السعر للوحدة'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'ملاحظة (اختياري)'),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton(
                onPressed: () async {
                  final quantity = double.tryParse(quantityController.text) ?? 0;
                  final price = double.tryParse(priceController.text) ?? 0;
                  if (quantity <= 0 || price <= 0) return;
                  final sale = SaleTransaction(
                    accountId: account.id!,
                    quantity: quantity,
                    pricePerUnit: price,
                    createdAt: DateTime.now(),
                    note: noteController.text,
                  );
                  await ctx.read<AccountProvider>().addSale(sale);
                  Navigator.of(ctx).pop();
                },
                child: const Text('حفظ البيع'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}
