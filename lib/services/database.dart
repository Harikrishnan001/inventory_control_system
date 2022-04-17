import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/summary.dart';
import '/models/item.dart';
import '/models/stock_log.dart';

abstract class DatabaseProvider {
  Future<void> createItem(StockItem item);
  Future<void> editItem(StockItem oldItem, StockItem newItem);
  Stream<List<StockItem>> getStockItems();
  Future<Stream<List<Future<StockLog>>>> getStockLogs();
}

class SQFLiteProvider implements DatabaseProvider {
  SQFLiteProvider._();

  static int version = 1;
  static Database? _db;
  static final SQFLiteProvider _singleton = SQFLiteProvider._();

  factory SQFLiteProvider() {
    return _singleton;
  }

  static Future<void> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, "ics.db");
    _db = await openDatabase(
      path,
      version: version,
      onCreate: (db, version) {
        db.execute('CREATE TABLE Category(name PRIMARY KEY)');
        db.execute(
            'CREATE TABLE Item(name TEXT PRIMARY KEY,category TEXT REFERENCES Category(name),qty INT,sp REAL,cp REAL,reorderPoint INT,imageURL TEXT)');
        db.execute(
            'CREATE TABLE Log(itemName TEXT REFERENCES Item(name),date DATE,change INT)');
        db.execute(
            'CREATE TABLE User(name TEXT PRIMARY KEY,mail TEXT,country TEXT,company TEXT,phoneNumber TEXT,role TEXT,password TEXT)');
        db.rawInsert(
            'INSERT INTO User VALUES("Test User","test@gmail.com","India","Test Company Inc","123456793","manager","password")');
      },
      singleInstance: true,
    );
  }

  @override
  Future<void> createItem(StockItem item) async {
    await _db!.insert(
      'Item',
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _db!.rawInsert(
        'INSERT INTO Log VALUES("${item.name}","${formatDate(DateTime.now(), [
          yyyy,
          '-',
          mm,
          '-',
          dd
        ])}",${item.qty})');
  }

  @override
  Future<void> editItem(StockItem oldItem, StockItem newItem) async {
    await _db!.update('Item', newItem.toJson(),
        where: 'name= ?', whereArgs: [oldItem.name]);
    await _db!.rawInsert(
        'INSERT INTO Log VALUES("${newItem.name}","${formatDate(DateTime.now(), [
          yyyy,
          '-',
          mm,
          '-',
          dd
        ])}",${newItem.qty - oldItem.qty})');
  }

  Future<void> deleteItem(StockItem item) async {
    await _db!.delete('Item', where: 'name= ?', whereArgs: [item.name]);
  }

  @override
  Stream<List<StockItem>> getStockItems() {
    Future<List<Map<String, Object?>>> items = _db!.query('Item');
    return items
        .asStream()
        .map((list) => list.map((json) => StockItem.fromJson(json)).toList());
  }

  @override
  Future<Stream<List<Future<StockLog>>>> getStockLogs() async {
    final logs = _db!.query('Log');
    final logsStream = logs.asStream();
    final result = logsStream.map((logs) {
      return logs.map((log) async {
        final itemName = log["itemName"];
        final items =
            await _db!.query('Item', where: "name=?", whereArgs: [itemName]);
        final item = items.first;

        return StockLog(
            item: StockItem.fromJson(item),
            dateTime: DateTime.parse(log["date"].toString()),
            change: int.parse(
              log["change"].toString(),
            ));
      }).toList();
    });
    return Future.value(result);
  }

  Future<StockItem> _getStockItem(String name) async {
    final items = await _db!.query('Item', where: "name=?", whereArgs: [name]);
    return items.map((item) => StockItem.fromJson(item)).toList().first;
  }

  Future<StockSummary> getSummary(DateTime dateTime) async {
    final logs = await _db!.query('Log');
    final stockLogs = <StockLog>[];

    for (final log in logs) {
      final itemName = log["itemName"].toString();
      final item = await _getStockItem(itemName);
      final changeDate = DateTime.parse(log["date"].toString());
      final now = dateTime;
      bool isSameDay = changeDate.year == now.year &&
          changeDate.month == now.month &&
          changeDate.day == now.day;

      if (isSameDay) {
        stockLogs.add(
          StockLog(
              item: item,
              dateTime: changeDate,
              change: int.parse(log["change"].toString())),
        );
      }
    }

    int soldQty = 0, purchasedQty = 0;
    double earning = 0, spending = 0;
    stockLogs.forEach((log) {
      if (log.change < 0) {
        soldQty += (0 - log.change);
        earning += (log.item.sp * (0 - log.change));
      } else {
        purchasedQty += log.change;
        spending += (log.item.cp * log.change);
      }
    });
    return StockSummary(
        soldQty: soldQty,
        purchasedQty: purchasedQty,
        earning: earning,
        spending: spending);
  }
}
