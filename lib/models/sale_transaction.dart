import 'package:intl/intl.dart';

class SaleTransaction {
  final int? id;
  final int accountId;
  final double quantity;
  final double pricePerUnit;
  final DateTime createdAt;
  final String note;

  const SaleTransaction({
    this.id,
    required this.accountId,
    required this.quantity,
    required this.pricePerUnit,
    required this.createdAt,
    required this.note,
  });

  double get total => quantity * pricePerUnit;

  String get formattedDate => DateFormat('dd/MM/yyyy').format(createdAt);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'account_id': accountId,
      'quantity': quantity,
      'price_per_unit': pricePerUnit,
      'created_at': createdAt.toIso8601String(),
      'note': note,
    };
  }

  factory SaleTransaction.fromMap(Map<String, dynamic> map) {
    return SaleTransaction(
      id: map['id'] as int?,
      accountId: map['account_id'] as int,
      quantity: (map['quantity'] as num).toDouble(),
      pricePerUnit: (map['price_per_unit'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
      note: map['note'] as String? ?? '',
    );
  }
}
