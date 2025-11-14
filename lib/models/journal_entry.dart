import '../models/account.dart';

class JournalEntry {
  final String accountName;
  final AccountType accountType;
  final DateTime date;
  final double total;
  final double commission;
  final double net;
  final String note;

  JournalEntry({
    required this.accountName,
    required this.accountType,
    required this.date,
    required this.total,
    required this.commission,
    required this.net,
    required this.note,
  });

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    final quantity = (map['quantity'] as num).toDouble();
    final price = (map['price_per_unit'] as num).toDouble();
    final total = quantity * price;
    final commission = total * 0.05;
    return JournalEntry(
      accountName: map['account_name'] as String,
      accountType: AccountTypeParser.fromValue(map['account_type'] as String),
      date: DateTime.parse(map['created_at'] as String),
      total: total,
      commission: commission,
      net: total - commission,
      note: map['note'] as String? ?? '',
    );
  }
}
