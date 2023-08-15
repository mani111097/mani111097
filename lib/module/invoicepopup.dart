import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasitu_login/module/customTabview.dart';
import 'package:rasitu_login/module/pagebuilder.dart';
import 'package:rasitu_login/module/purchaseData.dart';

class InvoiceDialog extends StatefulWidget {
  Map inoiceDate = {};
  InvoiceDialog(this.inoiceDate);

  @override
  State<InvoiceDialog> createState() => _InvoiceDialogState();
}

class _InvoiceDialogState extends State<InvoiceDialog> {
  List<Widget> data = [
    //PageBuilder(widget.inoiceDate),
  ];

  double width = 50;
  int initPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        CustomTabView(
          initPosition: initPosition,
          itemCount: data.length,
          tabBuilder: (context, index) => const Tab(text: "Sales"),
          pageBuilder: (context, index) => Center(child: data[index]),
          onPositionChange: (index) {
            initPosition = index;
          },
          onScroll: (position) => print('scrobal $position'),
        ),
        Positioned(
            top: 5,
            right: 10,
            child: GestureDetector(
                onTap: () {
                  Provider.of<PurchaseData>(context, listen: false)
                      .clearCache();
                  Navigator.pop(context, "cancel");
                },
                child: const Icon(Icons.close)))
      ],
    ));
  }
}
