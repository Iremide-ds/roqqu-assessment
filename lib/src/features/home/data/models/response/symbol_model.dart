import 'dart:convert';

import 'package:roqqu_assessment/src/features/home/domain/entities/symbol.dart';

class SymbolResponseModel extends SymbolResponse {
  const SymbolResponseModel({
    required super.symbol,
    required super.price,
  });

  factory SymbolResponseModel.fromMap(Map<String, dynamic> map) {
    return SymbolResponseModel(
      symbol: map['symbol'].toString(),
      price: num.tryParse(map['price'].toString()),
    );
  }

  factory SymbolResponseModel.fromJson(String json) {
    return SymbolResponseModel.fromMap(
        jsonDecode(json) as Map<String, dynamic>);
  }

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'price': price,
    };
  }

  String toJson() => jsonEncode(toMap());

  @override
  String toString() => 'SymbolResponseModel(symbol: $symbol, price: $price)';

  @override
  bool operator ==(covariant SymbolResponseModel other) {
    if (identical(this, other)) return true;

    return other.symbol == symbol && other.price == price;
  }

  @override
  int get hashCode => symbol.hashCode ^ price.hashCode;
}
