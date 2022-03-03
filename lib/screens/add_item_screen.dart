import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '/constants.dart';
import '/models/item.dart';
import '/services/database.dart';

class AddItemScreen extends StatefulWidget {
  final bool editMode;
  final StockItem? item;
  const AddItemScreen({
    Key? key,
    this.editMode = false,
    this.item,
  })  : assert((editMode == true && item != null) ||
            (editMode == false && item == null)),
        super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _openingStockController;
  late final TextEditingController _reorderPointController;
  late final TextEditingController _categoryController;
  late final TextEditingController _spController;
  late final TextEditingController _cpController;
  String imageURL = '';

  StockItem? get _item {
    return widget.item;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _item?.name);
    _skuController = TextEditingController();
    _openingStockController =
        TextEditingController(text: _item?.qty.toString());
    _reorderPointController =
        TextEditingController(text: _item?.reorderPoint.toString());
    _categoryController = TextEditingController(text: _item?.category);
    _spController = TextEditingController(text: _item?.sp.toStringAsFixed(2));
    _cpController = TextEditingController(text: _item?.cp.toStringAsFixed(2));
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _skuController.dispose();
    _openingStockController.dispose();
    _reorderPointController.dispose();
    _categoryController.dispose();
    _spController.dispose();
    _cpController.dispose();
  }

  Future<void> _save() async {
    if (widget.editMode) {
      await SQFLiteProvider().editItem(
          widget.item!,
          StockItem(
            name: _nameController.text,
            category: _categoryController.text,
            cp: double.tryParse(_cpController.text) ?? 0.0,
            sp: double.tryParse(_spController.text) ?? 0.0,
            qty: int.tryParse(_openingStockController.text) ?? 0,
            reorderPoint: int.tryParse(_reorderPointController.text) ?? 0,
            imageURL: imageURL,
          ));
    } else {
      await SQFLiteProvider().createItem(StockItem(
        name: _nameController.text,
        category: _categoryController.text,
        cp: double.tryParse(_cpController.text) ?? 0.0,
        sp: double.tryParse(_spController.text) ?? 0.0,
        qty: int.tryParse(_openingStockController.text) ?? 0,
        reorderPoint: int.tryParse(_reorderPointController.text) ?? 0,
        imageURL: imageURL,
      ));
    }

    Navigator.of(context).pop();
  }

  Future<void> _openImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.single.path == null) {
      setState(() {
        imageURL = '';
      });
      return;
    }
    setState(() {
      imageURL = result.files.single.path!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ICSColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ICSColors.backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.editMode ? 'Edit Item' : 'Add Item',
          style: TextStyle(
            color: Colors.black,
            fontSize: ICSFontSize.medium,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _save();
            },
            child: Text('SAVE'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Spacer(),
                (imageURL == null || imageURL == '')
                    ? AddImage(onTap: () {
                        _openImage();
                      })
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          border:
                              Border.all(width: 5.0, color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.file(
                              File(imageURL),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                Spacer(),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: ICSPadding.small,
                vertical: ICSPadding.medium,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Form(
                child: Column(
                  children: [
                    AddItemAttributeField(
                      labelText: 'Item Name',
                      controller: _nameController,
                    ),
                    SizedBox(height: 10),
                    AddItemAttributeField(
                      labelText: 'SKU',
                      controller: _skuController,
                    ),
                    SizedBox(height: 10),
                    LayoutBuilder(builder: (context, constraints) {
                      return Row(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth / 2,
                            child: AddItemAttributeField(
                              labelText: 'Opening Stock',
                              hintText: '0.0',
                              keyboardType: TextInputType.number,
                              controller: _openingStockController,
                            ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth / 2,
                            child: AddItemAttributeField(
                              labelText: 'Reorder Point',
                              hintText: '0.0',
                              keyboardType: TextInputType.number,
                              controller: _reorderPointController,
                            ),
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: 10.0),
                    AddItemAttributeField(
                      labelText: 'Category',
                      hintText: 'Select a category',
                      controller: _categoryController,
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: ICSPadding.small,
                vertical: ICSPadding.medium,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Form(
                child: LayoutBuilder(builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: ICSPadding.medium),
                    child: Row(
                      children: [
                        SizedBox(
                          width: constraints.maxWidth / 2,
                          child: AddItemAttributeField(
                            labelText: 'Selling Price',
                            controller: _spController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth / 2,
                          child: AddItemAttributeField(
                            labelText: 'Cost Price',
                            controller: _cpController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddItemAttributeField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  const AddItemAttributeField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.hintText,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ICSPadding.medium,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle: TextStyle(
            color: Colors.blue[800],
            fontSize: ICSFontSize.small,
          ),
          labelText: labelText,
          hintText: hintText,
          labelStyle: TextStyle(
            color: Colors.blue[800],
            fontSize: ICSFontSize.medium,
          ),
        ),
      ),
    );
  }
}

class AddImage extends StatelessWidget {
  final VoidCallback onTap;
  const AddImage({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(ICSPadding.tiny),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            width: 5.0,
            color: Colors.blueGrey,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.add_a_photo,
              color: Colors.blueGrey,
              size: 70,
            ),
            Text('Add image',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: ICSFontSize.small,
                )),
          ],
        ),
      ),
    );
  }
}
