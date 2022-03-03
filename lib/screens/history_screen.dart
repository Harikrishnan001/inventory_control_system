import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:dotted_line/dotted_line.dart';
import '/constants.dart';
import '/models/stock_log.dart';
import '../widgets/future_resolver_log.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ICSColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ICSColors.backgroundColor,
        title: Text(
          'Stock History',
          style: TextStyle(
            color: Colors.black,
            fontSize: ICSFontSize.medium,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.filter_alt_outlined,
              color: Colors.black,
              size: 22.0,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ICSPadding.small),
        child: FutureResolver(
          widgetBuilder: (log) => HistoryContainer(log: log),
        ),
      ),
    );
  }
}

class HistoryContainer extends StatelessWidget {
  final StockLog log;
  const HistoryContainer({
    Key? key,
    required this.log,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: ICSPadding.tiny),
      padding: const EdgeInsets.symmetric(
        horizontal: ICSPadding.medium,
        vertical: ICSPadding.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(ICSPadding.small),
            child: Text(
              '${log.item.name}',
              style: TextStyle(
                fontSize: ICSFontSize.medium,
              ),
            ),
          ),
          DottedLine(),
          Padding(
            padding: const EdgeInsets.all(ICSPadding.small),
            child: Row(
              children: [
                Icon(Icons.date_range, color: Colors.grey),
                Text(
                  '${formatDate(log.dateTime, [dd, '/', mm, '/', yyyy])}',
                  style: TextStyle(
                    fontSize: ICSFontSize.small,
                  ),
                ),
                Spacer(),
                log.change < 0
                    ? Icon(
                        Icons.arrow_downward,
                        color: Colors.red,
                        size: 22.0,
                      )
                    : Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                        size: 22.0,
                      ),
                Text(
                  '${log.change}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: ICSFontSize.medium,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
