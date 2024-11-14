class OrderBook {
  final int? eventTime;
  final String? eventType;
  final String? symbol;
  final int? firstUpdateId;
  final int? finalUpdateId;
  final List<List<dynamic>?>? bids;
  final List<List<dynamic>?>? asks;
  const OrderBook({
    required this.eventTime,
    required this.firstUpdateId,
    required this.asks,
    required this.bids,
    required this.eventType,
    required this.symbol,
    required this.finalUpdateId,
  });
}
