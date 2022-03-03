import 'dart:math';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ICSColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ICSPadding.small),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: ICSPadding.large,
                  ),
                  child: Text(
                    'Hello Harikrishnan !',
                    style: TextStyle(
                      fontSize: ICSFontSize.medium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                height: 180.0,
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: ICSPadding.small),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: ICSColors.primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ICSPadding.medium,
                        vertical: ICSPadding.large,
                      ),
                      child: Text(
                        'Today\'s Summary',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ICSFontSize.large,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: DetailsColumn(
                              title1: 'Sold Quantity',
                              qty1: 0,
                              title2: 'Earning(INR)',
                              qty2: 0,
                            ),
                          ),
                          Expanded(
                            child: DetailsColumn(
                              title1: 'Purchased Quantity',
                              qty1: 500,
                              title2: 'Spendings(INR)',
                              qty2: 9000000,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: ICSPadding.medium),
                child: SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RowContainer(
                        width: MediaQuery.of(context).size.width / 2 - 22,
                        backgroundColor:
                            Color.lerp(Colors.lightBlue, Colors.white, 0.7)!,
                        iconColor: Color.lerp(
                            ICSColors.primaryColor, Colors.white, 0.3)!,
                        count: 1,
                        iconData: Icons.shopping_basket_outlined,
                        title: 'All Items',
                      ),
                      const SizedBox(width: 5.0),
                      RowContainer(
                        width: MediaQuery.of(context).size.width / 2 - 22,
                        backgroundColor: Color.fromARGB(255, 228, 227, 223),
                        iconColor: Color.fromARGB(255, 240, 162, 18),
                        count: 0,
                        iconData: Icons.person_outline_outlined,
                        title: 'All Contacts',
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Analytics',
                    style: TextStyle(
                      color:
                          Color.lerp(ICSColors.primaryColor, Colors.black, 0.5),
                      fontWeight: FontWeight.w600,
                      fontSize: ICSFontSize.medium,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.filter_alt_outlined,
                    size: 24.0,
                  ),
                  SizedBox(width: 4.0),
                  FilterDropDownButton(),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: ICSPadding.large),
                width: MediaQuery.of(context).size.width,
                height: 380,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            'Transaction Trend',
                            style: TextStyle(
                              fontSize: ICSFontSize.small,
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: const EdgeInsets.only(right: 5.0),
                            color: Colors.orange,
                            height: 12.0,
                            width: 12.0,
                          ),
                          Text('Sales'),
                          Container(
                            margin:
                                const EdgeInsets.only(right: 5.0, left: 10.0),
                            color: Colors.blueGrey,
                            height: 12.0,
                            width: 12.0,
                          ),
                          Text('Purchase'),
                          SizedBox(width: 10.0),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 25.0,
                          height: 320,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (int i = 5; i >= 0; i--)
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      '${i * 10}',
                                      style: TextStyle(
                                        fontSize: ICSFontSize.tiny,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GraphPlotter(),
                        ),
                        SizedBox(width: 25.0),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GraphPlotter extends StatelessWidget {
  const GraphPlotter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: 350.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < 7; i++)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 320.0,
                    width: constraints.maxWidth / 7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: ICSPadding.tiny),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            height: Random().nextDouble() * 320.0,
                            width:
                                constraints.maxWidth / 14 - ICSPadding.tiny * 2,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            height: Random().nextDouble() * 320.0,
                            width:
                                constraints.maxWidth / 14 - ICSPadding.tiny * 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (i == 0)
                    SizedBox(
                      height: 30.0,
                      child: Text(
                        '${formatDate(DateTime.now().subtract(Duration(hours: 24)), [
                              M,
                              ' ',
                              d
                            ])}',
                        style: TextStyle(
                          fontSize: ICSFontSize.tiny,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 30.0,
                      child: Text(
                        '${formatDate(DateTime.now().add(Duration(hours: 24 * (i - 1))), [
                              M,
                              ' ',
                              d
                            ])}',
                        style: TextStyle(
                          fontSize: ICSFontSize.tiny,
                        ),
                      ),
                    )
                ],
              ),
          ],
        ),
      );
    });
  }
}

class FilterDropDownButton extends StatefulWidget {
  const FilterDropDownButton({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterDropDownButton> createState() => _FilterDropDownButtonState();
}

class _FilterDropDownButtonState extends State<FilterDropDownButton> {
  String currentSelection = 'This Week';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: currentSelection,
        style: TextStyle(
          fontSize: ICSFontSize.small,
          color: Colors.black,
        ),
        underline: SizedBox(),
        items: [
          DropdownMenuItem<String>(
            child: Text('This Week'),
            value: 'This Week',
          ),
          DropdownMenuItem<String>(
            child: Text('Last Week'),
            value: 'Last Week',
          ),
          DropdownMenuItem<String>(
            child: Text('This Month'),
            value: 'This Month',
          ),
          DropdownMenuItem<String>(
            child: Text('Last 3 Months'),
            value: 'Last 3 Months',
          ),
          DropdownMenuItem<String>(
            child: Text('Last 6 Months'),
            value: 'Last 6 Months',
          ),
          DropdownMenuItem<String>(
            child: Text('This Year'),
            value: 'This Year',
          ),
        ],
        onChanged: (value) {
          currentSelection = value ?? currentSelection;
          setState(() {});
        });
  }
}

class RowContainer extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final IconData iconData;
  final String title;
  final int count;
  final double width;
  const RowContainer({
    Key? key,
    required this.backgroundColor,
    required this.iconColor,
    required this.iconData,
    required this.title,
    required this.count,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.all(ICSPadding.small),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: backgroundColor),
            child: Icon(
              iconData,
              color: iconColor,
              size: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: ICSPadding.small,
              horizontal: ICSPadding.small,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: ICSFontSize.small,
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: ICSFontSize.medium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 50.0),
                    Icon(
                      Icons.arrow_forward,
                      color: ICSColors.primaryColor,
                      size: 14.0,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DetailsColumn extends StatelessWidget {
  final String title1;
  final String title2;
  final int qty1;
  final int qty2;
  const DetailsColumn({
    Key? key,
    required this.title1,
    required this.title2,
    required this.qty1,
    required this.qty2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ICSPadding.medium,
        vertical: ICSPadding.tiny,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title1,
            style: TextStyle(
              fontSize: ICSFontSize.small,
              color: Color.lerp(ICSColors.primaryColor, Colors.white, 0.8),
            ),
          ),
          Text(
            '$qty1',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: ICSFontSize.medium,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            title2,
            style: TextStyle(
              fontSize: ICSFontSize.small,
              color: Color.lerp(ICSColors.primaryColor, Colors.white, 0.8),
            ),
          ),
          Text(
            '$qty2',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: ICSFontSize.medium,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
