import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/account.dart';
import '../models/sale_transaction.dart';
import '../providers/account_provider.dart';
import '../providers/activation_provider.dart';
import '../ui/forms.dart';
import '../widgets/transaction_tile.dart';
import 'activation_screen.dart';

class DailySalesScreen extends StatefulWidget {
  const DailySalesScreen({super.key, required this.account});

  final Account account;

  @override
  State<DailySalesScreen> createState() => _DailySalesScreenState();
}

class _DailySalesScreenState extends State<DailySalesScreen> {
  late Future<List<SaleTransaction>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<AccountProvider>().salesByAccount(widget.account.id!);
  }

  Future<void> _refresh() async {
    setState(() {
      _future = context.read<AccountProvider>().salesByAccount(widget.account.id!);
    });
  }

  void _addSale() {
    final accountProvider = context.read<AccountProvider>();
    final activationProvider = context.read<ActivationProvider>();
    final requiresActivation = activationProvider.requiresActivation(accountProvider.salesCount);
    if (requiresActivation) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ActivationScreen()));
      return;
    }
    showAddSaleSheet(context, widget.account).then((_) => _refresh());
  }

  double _totalWithCommission(List<SaleTransaction> sales) {
    return sales.fold<double>(0, (prev, sale) => prev + sale.total);
  }

  double _netAfterCommission(double total) => total * 0.95;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('البيع اليومي - ${widget.account.name}')),
      body: FutureBuilder<List<SaleTransaction>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final sales = snapshot.data ?? [];
          final total = _totalWithCommission(sales);
          final net = _netAfterCommission(total);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('إجمالي البيع: ${total.toStringAsFixed(2)} ر.ي'),
                        Text('صافي بعد عمولة 5%: ${net.toStringAsFixed(2)} ر.ي'),
                      ],
                    ),
                    FilledButton(
                      onPressed: _addSale,
                      child: const Text('إضافة بيع جديد'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: sales.isEmpty
                    ? const Center(child: Text('لا توجد عمليات مسجلة'))
                    : ListView.builder(
                        itemCount: sales.length,
                        itemBuilder: (context, index) => TransactionTile(transaction: sales[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
