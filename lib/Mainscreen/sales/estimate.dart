import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rasitu_login/main.dart';
import 'package:rasitu_login/module/sharedpreference.dart';

class Estimate extends StatefulWidget {
  const Estimate({Key? key}) : super(key: key);

  @override
  State<Estimate> createState() => _EstimateState();
}

class _EstimateState extends State<Estimate> {
  int months = 1;
  String timepicker = "Past Month";
  List estimateList = [];
  final PrefService _prefService = PrefService();

  getEstimateData() async {
    try {
      String id = await _prefService.readId().then((value) => value);
      if (id.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('estimate')
            .where('uid', isEqualTo: id)
            .get()
            .then((value) {
          print(value.docs.length);
          if (value.docs.isNotEmpty) {
            value.docs.forEach((element) {
              setState(() {
                estimateList.add(element.data());
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
    getEstimateData();
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
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text(
                      "Estimate",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            children: const [Icon(Icons.print), Text("Print")],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: maincolor),
                              onPressed: () {
                                context.go('/estimate/new');
                              },
                              child: Text(
                                "New Estimate".toUpperCase(),
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
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Table(
                              columnWidths: const {
                                2: FlexColumnWidth(02),
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
                                      "Estimate No".toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Date".toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Customer Name".toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Amount".toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
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
                            ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                height: 0,
                              ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: estimateList.length,
                              itemBuilder: (context, index) {
                                return tablecontainer(
                                    index, estimateList[index]);
                              },
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
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
          context.go('/estimate/${docs['estimateId']}/edit');
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
                  docs["estimateId"],
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
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Text(
              //     docs["paymentType"],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  docs["total"],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Text(
              //     docs["balance"],
              //   ),
              // ),
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
