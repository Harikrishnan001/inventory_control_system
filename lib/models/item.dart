import 'dart:convert';

StockItem stockItemFromJson(String str) => StockItem.fromJson(json.decode(str));

String stockItemToJson(StockItem data) => json.encode(data.toJson());

class StockItem {
  StockItem({
    required this.name,
    required this.category,
    required this.qty,
    required this.sp,
    required this.cp,
    required this.reorderPoint,
    this.imageURL,
  });

  String name;
  String category;
  int qty;
  double sp;
  double cp;
  int reorderPoint;
  String? imageURL;

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
        name: json["name"],
        category: json["category"],
        qty: json["qty"],
        sp: json["sp"].toDouble(),
        cp: json["cp"].toDouble(),
        reorderPoint: json["reorderPoint"],
        imageURL: json["imageURL"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "category": category,
        "qty": qty,
        "sp": sp,
        "cp": cp,
        "reorderPoint": reorderPoint,
        "imageURL": imageURL,
      };
}
