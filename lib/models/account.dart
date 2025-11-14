import 'package:flutter/material.dart';

enum AccountType { raawi, maqout, wakil }

extension AccountTypeText on AccountType {
  String get label {
    switch (this) {
      case AccountType.raawi:
        return 'رعوي';
      case AccountType.maqout:
        return 'مقوت';
      case AccountType.wakil:
        return 'وكيل';
    }
  }

  Color get badgeColor {
    switch (this) {
      case AccountType.raawi:
        return Colors.teal.shade400;
      case AccountType.maqout:
        return Colors.orange.shade500;
      case AccountType.wakil:
        return Colors.indigo.shade400;
    }
  }
}

class AccountTypeParser {
  static AccountType fromValue(String value) {
    return AccountType.values.firstWhere(
      (element) => element.name == value,
      orElse: () => AccountType.raawi,
    );
  }
}

class Account {
  final int? id;
  final String name;
  final String phone;
  final AccountType type;
  final String username;
  final String password;

  const Account({
    this.id,
    required this.name,
    required this.phone,
    required this.type,
    required this.username,
    required this.password,
  });

  Account copyWith({
    int? id,
    String? name,
    String? phone,
    AccountType? type,
    String? username,
    String? password,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      type: type ?? this.type,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'type': type.name,
      'username': username,
      'password': password,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String,
      type: AccountTypeParser.fromValue(map['type'] as String),
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }
}
