import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import '/constants.dart';
import '/screens/add_item_screen.dart';
import '/services/database.dart';
import '../models/item.dart';

class ItemDetailsScreen extends StatelessWidget {
  final StockItem item;
  const ItemDetailsScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  Future<void> _deleteItem(BuildContext context) async {
    await SQFLiteProvider().deleteItem(item);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ICSColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: ICSColors.backgroundColor,
        title: Text(
          'Item Details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _deleteItem(context);
            },
            icon: Icon(
              Icons.delete_outline,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => AddItemScreen(
                        editMode: true,
                        item: item,
                      )));
            },
            icon: Icon(
              Icons.edit_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ICSPadding.small),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ItemDetailsTitleContainer(item: item),
              SizedBox(height: 10),
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: ICSPadding.medium),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItemDetailText(
                      label: 'Category',
                      value: item.category,
                    ),
                    ItemDetailText(
                      label: 'Reorder Point',
                      value: item.reorderPoint.toString(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: ICSPadding.medium),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItemDetailText(
                      label: 'Selling Price(INR)',
                      value: item.sp.toString(),
                    ),
                    ItemDetailText(
                      label: 'Cost Price(INR)',
                      value: item.cp.toString(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        backgroundColor: Colors.blue[800],
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return StockUpdateDialog(
                item: item,
              );
            },
          );
        },
        icon: RotatedBox(
          quarterTurns: 1,
          child: Icon(Icons.sync_alt_outlined),
        ),
        label: Text(
          'UPDATE STOCK',
          style: TextStyle(
              color: Colors.white,
              fontSize: ICSFontSize.medium,
              letterSpacing: 0.5),
        ),
      ),
    );
  }
}

class StockUpdateDialog extends StatefulWidget {
  const StockUpdateDialog({
    Key? key,
    required this.item,
  }) : super(key: key);

  final StockItem item;

  @override
  State<StockUpdateDialog> createState() => _StockUpdateDialogState();
}

class _StockUpdateDialogState extends State<StockUpdateDialog> {
  late final TextEditingController _stockController;
  int qty = 0;
  @override
  void initState() {
    _stockController = TextEditingController(text: qty.toString());
    super.initState();
  }

  @override
  void dispose() {
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _updateStock() async {
    await SQFLiteProvider().editItem(
        widget.item,
        StockItem(
          name: widget.item.name,
          category: widget.item.category,
          cp: widget.item.cp,
          sp: widget.item.sp,
          reorderPoint: widget.item.reorderPoint,
          imageURL: widget.item.imageURL,
          qty: widget.item.qty + qty,
        ));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        insetPadding: const EdgeInsets.all(ICSPadding.large),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: ICSPadding.medium),
          height: MediaQuery.of(context).size.height / 2.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Quantity',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: ICSFontSize.small,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.blue[900],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: widget.item.imageURL != null &&
                              widget.item.imageURL != ''
                          ? Image.file(
                              File(widget.item.imageURL!),
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/img-not-found.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: ICSPadding.small),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.name,
                          style: TextStyle(
                            color: Colors.blue[900],
                          ),
                        ),
                        SizedBox(height: 10),
                        ItemDetailText(
                          label: 'Available Stock',
                          value: widget.item.qty.toString(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Stock Out',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: ICSFontSize.small,
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() {
                        qty = max(0 - widget.item.qty, qty - 1);
                        _stockController.text = qty.toString();
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: ICSPadding.medium),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: TextField(
                        controller: _stockController,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() {
                        qty++;
                        _stockController.text = qty.toString();
                      });
                    },
                  ),
                  Text(
                    'Stock In',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: ICSFontSize.small,
                    ),
                  ),
                ],
              ),
              Center(
                child: Text(
                  'Quantity',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: ICSFontSize.small,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size.fromHeight(40)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[900]),
                      shape: MaterialStateProperty.all(StadiumBorder()),
                    ),
                    onPressed: () {
                      _updateStock();
                    },
                    child: Text(
                      '  OK  ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemDetailText extends StatelessWidget {
  final String label;
  final String value;
  const ItemDetailText({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$label: ',
        style: TextStyle(
          color: Colors.grey,
          fontSize: ICSFontSize.small,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              color: Colors.black,
              fontSize: ICSFontSize.small,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemDetailsTitleContainer extends StatelessWidget {
  const ItemDetailsTitleContainer({
    Key? key,
    required this.item,
  }) : super(key: key);

  final StockItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: [
          SizedBox(width: 8),
          SizedBox(
            height: 60,
            width: 60,
            child: item.imageURL != null && item.imageURL != ''
                ? Image.file(
                    File(item.imageURL!),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/img-not-found.png',
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: ICSPadding.small),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: ICSFontSize.medium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Available Stock: ',
                      style: TextStyle(
                        fontSize: ICSFontSize.small,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${item.qty}',
                      style: TextStyle(
                        fontSize: ICSFontSize.medium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
