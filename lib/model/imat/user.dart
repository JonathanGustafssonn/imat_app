import 'dart:convert';

import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat/credit_card.dart';

class User {
  String userName;
  String password;

  Customer? customer;
  CreditCard? card;

  User(
    this.userName,
    this.password, {
    this.customer,
    this.card,
  });

  User.fromJson(Map<String, dynamic> json)
      : userName = json[_userName],
        password = json[_password],
        customer = json[_customer] != null
            ? Customer.fromJson(jsonDecode(json[_customer]))
            : null,
        card = json[_card] != null
            ? CreditCard.fromJson(jsonDecode(json[_card]))
            : null;

  Map<String, dynamic> toJson() => {
        _userName: userName,
        _password: password,
        if (customer != null) _customer: jsonEncode(customer!.toJson()),
        if (card != null) _card: jsonEncode(card!.toJson()),
      };

  static const _userName = 'userName';
  static const _password = 'password';
  static const _customer = 'customer';
  static const _card = 'card';
}