import 'package:flutter/material.dart';

enum PaymentMethod { card, paypal, cash }

extension PaymentMethodX on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.cash:
        return 'Cash';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.paypal:
        return Icons.account_balance_wallet;
      case PaymentMethod.cash:
        return Icons.payments;
    }
  }

  String get value => name; // for backend
}
