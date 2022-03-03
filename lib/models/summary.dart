import 'dart:convert';

StockSummary stockSummaryFromJson(String str) =>
    StockSummary.fromJson(json.decode(str));

String stockSummaryToJson(StockSummary data) => json.encode(data.toJson());

class StockSummary {
  StockSummary({
    required this.soldQty,
    required this.purchasedQty,
    required this.earning,
    required this.spending,
  });

  int soldQty;
  int purchasedQty;
  double earning;
  double spending;

  factory StockSummary.fromJson(Map<String, dynamic> json) => StockSummary(
        soldQty: json["soldQty"],
        purchasedQty: json["purchasedQty"],
        earning: json["earning"].toDouble(),
        spending: json["spending"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "soldQty": soldQty,
        "purchasedQty": purchasedQty,
        "earning": earning,
        "spending": spending,
      };
}
