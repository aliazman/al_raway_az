import 'package:flutter/material.dart';

import '../models/account.dart';
import '../models/journal_entry.dart';
import '../models/sale_transaction.dart';
import '../services/database_service.dart';

class AccountProvider extends ChangeNotifier {
  AccountProvider(this._databaseService);

  final DatabaseService _databaseService;
  List<Account> _accounts = [];
  final Map<int, List<SaleTransaction>> _salesByAccount = {};
  bool _isLoading = true;
  String _filterQuery = '';
  int _salesCount = 0;

  bool get isLoading => _isLoading;
  List<Account> get accounts => _accounts;
  int get salesCount => _salesCount;
  String get filterQuery => _filterQuery;

  List<Account> get filteredAccounts {
    if (_filterQuery.isEmpty) return _accounts;
    return _accounts
        .where((account) => account.name.contains(_filterQuery) || account.phone.contains(_filterQuery))
        .toList();
  }

  Future<void> loadAccounts() async {
    _isLoading = true;
    notifyListeners();
    final records = await _databaseService.queryAccounts();
    _accounts = records.map(Account.fromMap).toList();
    _salesCount = await _databaseService.salesCount();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addAccount(Account account) async {
    await _databaseService.insertAccount(account.toMap());
    await loadAccounts();
  }

  Future<List<SaleTransaction>> salesByAccount(int accountId) async {
    if (_salesByAccount.containsKey(accountId)) {
      return _salesByAccount[accountId]!;
    }
    final rows = await _databaseService.querySalesByAccount(accountId);
    final list = rows.map(SaleTransaction.fromMap).toList();
    _salesByAccount[accountId] = list;
    return list;
  }

  Future<void> addSale(SaleTransaction sale) async {
    await _databaseService.insertSale(sale.toMap());
    _salesByAccount.remove(sale.accountId);
    _salesCount = await _databaseService.salesCount();
    notifyListeners();
  }

  Future<List<JournalEntry>> journalEntries() async {
    final rows = await _databaseService.queryJournalEntries();
    return rows.map(JournalEntry.fromMap).toList();
  }

  void setFilterQuery(String value) {
    _filterQuery = value.trim();
    notifyListeners();
  }
}
