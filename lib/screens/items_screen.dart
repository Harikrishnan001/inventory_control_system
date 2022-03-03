import 'dart:io';
import 'package:flutter/material.dart';
import '/constants.dart';
import '/models/item.dart';
import '/screens/add_item_screen.dart';
import '/screens/item_details_screen.dart';
import '/services/database.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({Key? key}) : super(key: key);

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  late final TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ICSColors.backgroundColor,
      appBar: CustomAppBar(
        width: MediaQuery.of(context).size.width,
        controller: _searchController,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ICSPadding.small),
        child: StreamBuilder<StockItem>(
            stream: null,
            builder: (context, snapshot) {
              return StreamBuilder<List<StockItem>>(
                  stream: SQFLiteProvider().getStockItems(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return RefreshIndicator(
                        onRefresh: () {
                          setState(() {});
                          return Future.value(null);
                        },
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data!.elementAt(index);

                            if (_searchController.text.isNotEmpty) {
                              if (item.name
                                  .startsWith(_searchController.text)) {
                                return ItemDetailTile(item: item);
                              } else {
                                return SizedBox();
                              }
                            } else {
                              return ItemDetailTile(item: item);
                            }
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const CircularProgressIndicator(color: Colors.red);
                    }
                    return const CircularProgressIndicator();
                  });
            }),
      ),
    );
  }
}

class ItemDetailTile extends StatelessWidget {
  final StockItem item;

  const ItemDetailTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ItemDetailsScreen(item: item)));
      },
      child: Column(
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            tileColor: Colors.white,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: SizedBox(
                height: 60,
                width: 60,
                child: (item.imageURL == null || item.imageURL == '')
                    ? Image.asset(
                        "assets/img-not-found.png",
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(item.imageURL!),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: ICSPadding.medium),
              child: Text(item.name),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: 18,
                ),
                SizedBox(width: 10),
                Text(item.category),
              ],
            ),
            trailing: Text(
              '${item.qty}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: ICSFontSize.medium,
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double width;
  final TextEditingController controller;
  const CustomAppBar({
    Key? key,
    required this.width,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.only(left: ICSPadding.small),
                child: SizedBox(
                  height: 40.0,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Items',
                      style: TextStyle(
                        fontSize: ICSFontSize.medium,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: ICSPadding.small),
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      contentPadding:
                          const EdgeInsets.only(bottom: 20.0, left: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Search Item Name',
                      hintStyle: TextStyle(
                        fontSize: ICSFontSize.small,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 50.0,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddItemScreen()));
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.filter_list,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(width, 120);
}
