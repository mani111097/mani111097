import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rasitu_login/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rasitu_login/module/sharedpreference.dart';

class Invoice extends StatefulWidget {
  const Invoice({Key? key}) : super(key: key);

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  String timepicker = "Past Month";
  DateTime datetime = DateTime.now();
  int months = 1;
  double totalInvoice = 0;
  double balance = 0;
  String? menu;
  List invoiceList = [];
  final PrefService _prefService = PrefService();

  getInvoiceData() async {
    try {
      String id = await _prefService.readId().then((value) => value);
      if (id.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('invoice')
            .where('uid', isEqualTo: id)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            value.docs.forEach((element) {
              setState(() {
                totalInvoice =
                    totalInvoice + double.parse(element.data()["total"]);
                balance = balance + double.parse(element.data()["balance"]);
                invoiceList.add(element.data());
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
    getInvoiceData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              //height: MediaQuery.of(context).size.height * 0.92,
              //color: Colors.white,
              padding: const EdgeInsets.only(left: 30, top: 0, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                    child: ListTile(
                      title: const Text(
                        "Invoice",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: SizedBox(
                        height: 20,
                        child: Row(
                          children: [
                            timepickerDropdown(),
                            Text(Jiffy()
                                .subtract(months: months)
                                .format('yyyy-MM-dd')),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text("To"),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(Jiffy().format('yyyy-MM-dd'))
                          ],
                        ),
                      ),
                      trailing: SizedBox(
                        width: MediaQuery.of(context).size.width > 850
                            ? MediaQuery.of(context).size.width * 0.1
                            : MediaQuery.of(context).size.width * 0.2,
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
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width > 850
                          ? MediaQuery.of(context).size.width * 0.3
                          : MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 3,
                              //spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7))
                        ],
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Total Invoice",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                RichText(
                                    text: TextSpan(text: "₹", children: [
                                  TextSpan(
                                      text: totalInvoice.toString(),
                                      style: GoogleFonts.ptSerif(
                                          color: maincolor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35))
                                ])),
                              ],
                            ),
                            const VerticalDivider(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.blue,
                                      size: 8,
                                    ),
                                    Text("Paid",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ))
                                  ],
                                ),
                                RichText(
                                    text: TextSpan(text: "₹", children: [
                                  TextSpan(
                                      text: "${totalInvoice - balance}",
                                      style: GoogleFonts.ptSerif(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18))
                                ])),
                                const Divider(),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.red,
                                      size: 8,
                                    ),
                                    Text("Unpaid",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                                RichText(
                                    text: TextSpan(text: "₹", children: [
                                  TextSpan(
                                      text: "$balance",
                                      style: GoogleFonts.ptSerif(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18))
                                ])),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  //Table container

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Transaction",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "List of all Recent transaction",
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: maincolor),
                                  onPressed: () async {
                                    context.go('/invoice/new');

                                    // if (res == 'Added') {
                                    //   getInvoiceData();
                                    // }
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.add),
                                      Text(
                                        "New Invoice".toUpperCase(),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Table(
                          columnWidths: const {
                            2: FlexColumnWidth(2),
                          },
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
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Invoicce No".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Date".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Customer Name".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Payment Type".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Amount".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Balance".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Status".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ])
                          ],
                        ),
                        const Divider(
                          height: 1,
                        ),
                        ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                            height: 0,
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: invoiceList.length,
                          itemBuilder: (context, index) {
                            return tablecontainer(index, invoiceList[index]);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  tablecontainer(int index, Map<String, dynamic> docs) {
    if (DateTime.parse(docs['date']).isAfter(DateTime.parse(
            Jiffy().subtract(months: months).format('yyyy-MM-dd'))) &&
        DateTime.parse(docs['date']).isBefore(DateTime.now())) {
      return InkWell(
        onTap: () {
          context.go('/invoice/${docs['invoiceId']}/edit');
        },
        child: Table(
          columnWidths: const {
            2: FlexColumnWidth(02),
          },

          border: TableBorder.symmetric(
            outside: BorderSide.none,
            inside: const BorderSide(
                width: 0.5, color: Colors.grey, style: BorderStyle.solid),
          ),
          // columnWidths: const {
          //   0: FlexColumnWidth(0.2),
          // },
          children: [
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  docs["invoiceId"],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  docs["date"],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  docs["customerName"],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  docs["paymentType"],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  docs["total"],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  docs["balance"],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  docs["status"],
                ),
              ),
              // PopupMenuButton(
              //   itemBuilder: (context) {
              //     return [
              //       const PopupMenuItem<int>(
              //         value: 0,
              //         child: Text("Send Reminder"),
              //       ),
              //       const PopupMenuItem<int>(
              //         value: 1,
              //         child: Text("Share"),
              //       ),
              //     ];
              //   },
              // )
              // Padding(
              //     padding: const EdgeInsets.all(10.0),
              //     child: DropdownButton(
              //       value: menu,
              //       hint: const Icon(Icons.keyboard_control),
              //       onChanged: (String? value) => menu = value,
              //       items: ["Print", "Share"].map((items) {
              //         return DropdownMenuItem(
              //           value: items,
              //           child: Text(items),
              //         );
              //       }).toList(),
              //     ))
            ])
          ],
        ),
      );
    } else {
      return SizedBox();
    }
    //print(docs);
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
