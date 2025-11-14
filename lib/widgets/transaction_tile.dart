import 'package:flutter/material.dart';

import '../models/sale_transaction.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final SaleTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${transaction.quantity} حبة × ${transaction.pricePerUnit}'),
      subtitle: Text(transaction.note.isEmpty ? transaction.formattedDate : '${transaction.formattedDate} • ${transaction.note}'),
      trailing: Text('${transaction.total.toStringAsFixed(2)} ر.ي'),
    );
  }
}
