import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rasitu_login/main.dart';
import 'package:rasitu_login/module/sharedpreference.dart';

class SalesOrder extends StatefulWidget {
  const SalesOrder({Key? key}) : super(key: key);

  @override
  State<SalesOrder> createState() => _SalesOrderState();
}

class _SalesOrderState extends State<SalesOrder> {
  String timepicker = "Past Month";
  int months = 1;
  List orderList = [];
  final PrefService _prefService = PrefService();

  getOrderData() async {
    try {
      String id = await _prefService.readId().then((value) => value);
      if (id.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('Sales Order')
            .where('uid', isEqualTo: id)
            .get()
            .then((value) {
          print(value.docs.length);
          if (value.docs.isNotEmpty) {
            value.docs.forEach((element) {
              setState(() {
                orderList.add(element.data());
              });
            });
          }
        });
      }
    } catch (e) {
      //Navigator.pushNamed(context, '/failure');
    }
  }

  @override
  void initState() {
    getOrderData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                //color: Colors.white,
                padding: const EdgeInsets.only(left: 30, top: 10),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(
                        "Sales Order",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: SizedBox(
                        height: 20,
                        child: Row(
                          children: [
                            timepickerDropdown(),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(Jiffy()
                                .subtract(months: months)
                                .format('yyyy-MM-dd')),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text("to"),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(Jiffy().format('yyyy-MM-dd'))
                          ],
                        ),
                      ),
                      trailing: SizedBox(
                        width: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(Icons.document_scanner),
                                Text("Export")
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(Icons.print),
                                Text("Print")
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: maincolor),
                                onPressed: () {
                                  context.go('/salesorder/new');
                                },
                                child: Text(
                                  "New Order".toUpperCase(),
                                  //style: GoogleFonts.ptSerif(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Table(
                              border: TableBorder.symmetric(
                                outside: BorderSide.none,
                                inside: const BorderSide(
                                    width: 0.5,
                                    color: Colors.grey,
                                    style: BorderStyle.solid),
                              ),
                              children: [
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "Order No".toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "Date".toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "Customer Name".toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "Due Date".toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "Amount".toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "Status".toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.all(10.0),
                                  //   child: Text(
                                  //     "Invoice Status".toUpperCase(),
                                  //     style: const TextStyle(
                                  //         color: Colors.grey,
                                  //         fontWeight: FontWeight.bold),
                                  //   ),
                                  // )
                                ])
                              ],
                            ),
                            const Divider(
                              height: 1,
                            ),
                          ],
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }

  timepickerDropdown() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButton2(
        buttonStyleData: const ButtonStyleData(
          height: 25,
          width: 130,
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
          width: 180,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 25,
        ),
        // Initial Value
        value: timepicker,
        // Array list of items
        items: ["Past Month", "Past 3 months", "Past 1 Year"]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        underline: SizedBox(),

        onChanged: (String? newValue) {
          setState(() {
            months = newValue == "Past Month"
                ? 1
                : newValue == "Past 3 months"
                    ? 3
                    : 12;
            timepicker = newValue!;
          });
        },
      ),
    );
  }
}
