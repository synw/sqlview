import 'package:flutter/foundation.dart';

class Company {
  Company({@required this.name, @required this.symbol});

  final String name;
  final String symbol;

  Company.fromJson(Map<String, dynamic> data)
      : this.name = data["companyName"],
        this.symbol = data["Ticker"];

  String toString() {
    return "$symbol $name";
  }
}

class StockPrice {
  StockPrice(
      {@required this.price, @required this.date, @required this.company});

  final double price;
  final DateTime date;
  final Company company;
}