import '/models/item.dart';

class StockLog {
  final StockItem item;
  final DateTime dateTime;
  final int change;

  const StockLog({
    required this.item,
    required this.dateTime,
    required this.change,
  });
}
