import 'package:roqqu_assessment/src/features/home/domain/entities/order_book.dart';

class OrderBookModel extends OrderBook {
  const OrderBookModel({
    required super.eventTime,
    required super.firstUpdateId,
    required super.asks,
    required super.bids,
    required super.eventType,
    required super.symbol,
    required super.finalUpdateId,
  });

  factory OrderBookModel.fromMap(Map<String, dynamic> map) {
    return OrderBookModel(
      eventTime: map['E'],
      firstUpdateId: map['U'],
      asks: map['a'] == null
          ? []
          : (map['a'] as List)
              .map((e) => e == null ? [] : (e as List))
              .toList(),
      bids: map['b'] == null
          ? []
          : (map['b'] as List)
              .map((e) => e == null ? [] : (e as List))
              .toList(),
      eventType: map['e'],
      symbol: map['s'],
      finalUpdateId: map['u'],
    );
  }
}
