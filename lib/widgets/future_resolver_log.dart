import 'package:flutter/material.dart';
import '/models/stock_log.dart';
import '../services/database.dart';

class FutureResolver<T> extends StatelessWidget {
  final Widget Function(StockLog data) widgetBuilder;

  const FutureResolver({
    Key? key,
    required this.widgetBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Stream<List<Future<StockLog>>>>(
      future: SQFLiteProvider().getStockLogs(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.hasData) {
          return StreamBuilder<List<Future<StockLog>>>(
              stream: futureSnapshot.data,
              builder: (context, streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    itemCount: streamSnapshot.data!.length,
                    itemBuilder: (context, index) {
                      final stockFuture = streamSnapshot.data!.elementAt(index);
                      return FutureBuilder<StockLog>(
                        future: stockFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return widgetBuilder(snapshot.data!);
                          } else {
                            return Container(
                              color: Colors.white,
                              height: 80,
                              width: double.infinity,
                              margin: const EdgeInsets.all(8.0),
                            );
                          }
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.red,
                  ));
                }
              });
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
