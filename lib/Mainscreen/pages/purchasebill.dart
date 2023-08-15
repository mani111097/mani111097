import 'package:flutter/material.dart';
import 'package:rasitu_login/Mainscreen/constants/topbottom.dart';
import 'package:rasitu_login/main.dart';
import 'package:google_fonts/google_fonts.dart';

class PurchaseBill extends StatefulWidget {
  const PurchaseBill({Key? key}) : super(key: key);

  @override
  State<PurchaseBill> createState() => _PurchaseBillState();
}

class _PurchaseBillState extends State<PurchaseBill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.92,
            //color: Colors.white,
            padding: const EdgeInsets.only(left: 30, top: 10, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text(
                    "Purchase Bills",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: [
                      Text("24/02/2023"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text("To"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text("24/02/2023")
                    ],
                  ),
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
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
                          children: const [Icon(Icons.print), Text("Print")],
                        )
                      ],
                    ),
                  ),
                ),

                //Table container

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3,
                            //spreadRadius: 0.5,
                            offset: const Offset(0.7, 0.7))
                      ],
                    ),
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
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Icon(Icons.add),
                                      Text(
                                        "New Purchase".toUpperCase(),
                                        //style: GoogleFonts.ptSerif(),
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
                                  "Invoicce No".toUpperCase(),
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
                                  "Payment Type".toUpperCase(),
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
                                  "Balance".toUpperCase(),
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
                              )
                            ])
                          ],
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Table(
                          border: TableBorder.symmetric(
                            outside: BorderSide.none,
                            inside: const BorderSide(
                                width: 0.5,
                                color: Colors.grey,
                                style: BorderStyle.solid),
                          ),
                          // columnWidths: const {
                          //   0: FlexColumnWidth(0.2),
                          // },
                          children: const [
                            TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "125520",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "23/02/2023",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "Mani",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "Cash",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "₹20000",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "₹0",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "Paid",
                                ),
                              )
                            ])
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
