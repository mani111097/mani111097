import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:rasitu_login/module/addItems.dart';

import 'package:rasitu_login/module/sharedpreference.dart';
import 'package:shimmer/shimmer.dart';
import '../../main.dart';
import 'package:intl/intl.dart';

class Items extends StatefulWidget {
  final String id;
  String page;
  Items({this.id = "", this.page = "", Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  int? index = 0;
  late int hover = 0;
  bool additem = false;
  bool additemtype = false;
  bool noitems = false;
  bool itemSelection = false;
  List jsonList = [];
  List<String> itemids = [];

  int jsonIndex = 0;
  int type = 0, taxpref = 0;
  String gstdropdownvalue = "5";
  String igstdropdownvalue = "5";
  String unitdropdownvalue = "Select type Unit";
  bool salesinfo = true, purchaseinfo = true;
  //List item = ["App Development", "Photography", "Web Development"];
  TextEditingController name = TextEditingController();
  TextEditingController hsncode = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController sellingprice = TextEditingController();
  TextEditingController purchaseprice = TextEditingController();
  final PrefService _prefService = PrefService();

  getData() async {
    try {
      String id = await _prefService.readId().then((value) => value);
      await FirebaseFirestore.instance
          .collection('items')
          .where("uid", isEqualTo: id)
          .get()
          .then((value) => value.docs.forEach((element) {
                setState(() {
                  itemids.add(element.id);
                  jsonList.add(element.data());
                });
              }));
    } on Exception catch (e) {
      print("Exception returns ${e.toString().isNotEmpty}");
    } catch (e) {
      print("Exception returns ${e.toString().isNotEmpty}");
      if (e.toString().isNotEmpty) {
        context.go('/failed');
      }
    }
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    jsonIndex = widget.page == "items"
        ? widget.id.isNotEmpty
            ? itemids.indexOf(widget.id)
            : 0
        : 0;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: noitems
                ? noData()
                : additem
                    ? addItems(
                        update: additemtype,
                        jsonList: jsonList[jsonIndex],
                        onUpdate: (value) {
                          print(value);
                          if (value == "add") {
                            setState(() {
                              noitems = false;
                              additem = false;
                            });
                            jsonList.clear();
                            getData();
                          } else {
                            if (jsonList.isNotEmpty) {
                              setState(() {
                                additem = false;
                              });
                            } else {
                              setState(() {
                                noitems = true;
                                additem = false;
                              });
                            }
                          }
                        },
                      )
                    : Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width < 850
                                ? MediaQuery.of(context).size.width > 650
                                    ? MediaQuery.of(context).size.width * 0.3
                                    : itemSelection
                                        ? 0
                                        : MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.92,
                            decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      color:
                                          Color.fromARGB(255, 218, 218, 218))),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                    title: Text(
                                      "Items",
                                      style: TextStyle(color: maincolor),
                                    ),
                                    trailing: SizedBox(
                                      width: 90,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: maincolor),
                                        onPressed: () {
                                          setState(() {
                                            additem = true;
                                            additemtype = false;
                                          });
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.add,
                                            ),
                                            Text("New")
                                          ],
                                        ),
                                      ),
                                    )),
                                const Divider(),
                                const ListTile(
                                  dense: true,
                                  visualDensity: VisualDensity(vertical: -2),
                                  title: Text(
                                    "Items",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  trailing: Text(
                                    "Type",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Expanded(
                                    child: jsonList.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: jsonList.length,
                                            itemBuilder: ((context, i) {
                                              return InkWell(
                                                onTap: () {
                                                  if (MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      850) {
                                                    setState(() {
                                                      jsonIndex = i;
                                                      itemSelection = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      jsonIndex = i;
                                                    });
                                                    context.go(
                                                        '/home/items/${jsonList[i]["itemId"]}');
                                                  }
                                                },
                                                child: ListTile(
                                                  dense: true,
                                                  visualDensity:
                                                      const VisualDensity(
                                                          vertical: -3),
                                                  title: Text(jsonList[i]
                                                          ["itemName"]
                                                      .toString()),
                                                  trailing: Text(jsonList[i]
                                                          ["itemType"]
                                                      .toString()),
                                                ),
                                              );
                                            }))
                                        : ListView.builder(
                                            itemCount: 10,
                                            itemBuilder: ((context, i) {
                                              return Shimmer.fromColors(
                                                  baseColor:
                                                      Colors.grey.shade300,
                                                  highlightColor:
                                                      Colors.grey.shade200,
                                                  child: ListTile(
                                                    dense: true,
                                                    visualDensity:
                                                        const VisualDensity(
                                                            vertical: -3),
                                                    title: Container(
                                                      height: 10,
                                                      width: 150,
                                                      color: Colors.grey,
                                                    ),
                                                    trailing: Container(
                                                      height: 10,
                                                      width: 150,
                                                      color: Colors.grey,
                                                    ),
                                                  ));
                                            })))
                              ],
                            ),
                          ),

                          //Detail Container
                          MediaQuery.of(context).size.width > 650
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width <
                                          1200
                                      ? MediaQuery.of(context).size.width * 0.7
                                      : MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.height * 0.92,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          //Top Container
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              jsonList.isNotEmpty
                                                  ? ListTile(
                                                      title: Text(
                                                        jsonList[jsonIndex][
                                                                    "itemName"] !=
                                                                null
                                                            ? jsonList[jsonIndex]
                                                                    ["itemName"]
                                                                .toUpperCase()
                                                            : "",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                      subtitle: Text(
                                                        jsonList[jsonIndex][
                                                                    "hsn_code"] !=
                                                                null
                                                            ? jsonList[jsonIndex]
                                                                    ["hsn_code"]
                                                                .toString()
                                                                .toUpperCase()
                                                            : "",
                                                      ),
                                                      trailing: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      maincolor),
                                                          onPressed: () {
                                                            setState(() {
                                                              additem = true;
                                                              additemtype =
                                                                  true;
                                                            });
                                                          },
                                                          child: const Text(
                                                              "Adjustment")),
                                                    )
                                                  : Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey.shade300,
                                                      highlightColor:
                                                          Colors.grey.shade200,
                                                      child: ListTile(
                                                        dense: true,
                                                        visualDensity:
                                                            const VisualDensity(
                                                                vertical: -3),
                                                        title: Container(
                                                          height: 10,
                                                          width: 150,
                                                          color: Colors.grey,
                                                        ),
                                                        trailing: Container(
                                                          height: 10,
                                                          width: 150,
                                                          color: Colors.grey,
                                                        ),
                                                      )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18.0, right: 18.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        jsonList.isNotEmpty
                                                            ? Text(
                                                                jsonList[jsonIndex]
                                                                            [
                                                                            "salesprice"] !=
                                                                        ""
                                                                    ? "Sales Price: ₹${jsonList[jsonIndex]["salesprice"]}"
                                                                    : "Sales Price: ₹",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              )
                                                            : Shimmer
                                                                .fromColors(
                                                                baseColor: Colors
                                                                    .grey
                                                                    .shade300,
                                                                highlightColor:
                                                                    Colors.grey
                                                                        .shade200,
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  width: 150,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        jsonList.isNotEmpty
                                                            ? Text(
                                                                jsonList[jsonIndex]
                                                                            [
                                                                            "purchaseprice"] !=
                                                                        ""
                                                                    ? "Purchase Price: ₹${jsonList[jsonIndex]["purchaseprice"]}"
                                                                    : "Purchase Price: ₹",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                              )
                                                            : Shimmer
                                                                .fromColors(
                                                                baseColor: Colors
                                                                    .grey
                                                                    .shade300,
                                                                highlightColor:
                                                                    Colors.grey
                                                                        .shade200,
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  width: 150,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        jsonList.isNotEmpty
                                                            ? Text(
                                                                jsonList[jsonIndex]
                                                                            [
                                                                            "taxpref"] !=
                                                                        ""
                                                                    ? jsonList[jsonIndex]["taxpref"] !=
                                                                            "Y"
                                                                        ? "Tax Preference: Taxable"
                                                                        : "Tax Preference: Non Taxable"
                                                                    : "Tax Preference: Not defined",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                              )
                                                            : Shimmer
                                                                .fromColors(
                                                                baseColor: Colors
                                                                    .grey
                                                                    .shade300,
                                                                highlightColor:
                                                                    Colors.grey
                                                                        .shade200,
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  width: 150,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        jsonList.isNotEmpty
                                                            ? Text(
                                                                jsonList[jsonIndex]
                                                                            [
                                                                            "stock"] !=
                                                                        ""
                                                                    ? "Quantity: ${jsonList[jsonIndex]["stock"]}"
                                                                    : "Quantity:Not defined",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                              )
                                                            : Shimmer
                                                                .fromColors(
                                                                baseColor: Colors
                                                                    .grey
                                                                    .shade300,
                                                                highlightColor:
                                                                    Colors.grey
                                                                        .shade200,
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  width: 150,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        jsonList.isNotEmpty
                                                            ? Text(
                                                                jsonList[jsonIndex]
                                                                            [
                                                                            "stock"] !=
                                                                        ""
                                                                    ? "Value: ₹${int.parse(jsonList[jsonIndex]["salesprice"]) * int.parse(jsonList[jsonIndex]["stock"])}"
                                                                    : "Value: Not defined",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                              )
                                                            : Shimmer
                                                                .fromColors(
                                                                baseColor: Colors
                                                                    .grey
                                                                    .shade300,
                                                                highlightColor:
                                                                    Colors.grey
                                                                        .shade200,
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  width: 150,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        jsonList.isNotEmpty
                                                            ? Text(
                                                                jsonList[jsonIndex]
                                                                            [
                                                                            "unit"] !=
                                                                        ""
                                                                    ? "Unit: ${jsonList[jsonIndex]["unit"]}"
                                                                    : "Unit:Not defined",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                              )
                                                            : Shimmer
                                                                .fromColors(
                                                                baseColor: Colors
                                                                    .grey
                                                                    .shade300,
                                                                highlightColor:
                                                                    Colors.grey
                                                                        .shade200,
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  width: 150,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),

                                          const SizedBox(
                                            height: 10,
                                          ),

                                          const Divider(),

                                          //Table Container
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      "Transaction",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                      "List of all Recent transaction",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                ),
                                                Table(
                                                  border: TableBorder.symmetric(
                                                    outside: BorderSide.none,
                                                    inside: const BorderSide(
                                                        width: 0.5,
                                                        color: Colors.grey,
                                                        style:
                                                            BorderStyle.solid),
                                                  ),
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(0.2),
                                                  },
                                                  children: [
                                                    TableRow(children: [
                                                      const Padding(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child: Text(""),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                          "Type".toUpperCase(),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                          "Name".toUpperCase(),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                          "Date".toUpperCase(),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                          "Quantity"
                                                              .toUpperCase(),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                          "Price".toUpperCase(),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                          "Status"
                                                              .toUpperCase(),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ])
                                                  ],
                                                ),
                                                const Divider(
                                                  height: 0,
                                                ),
                                                ListView.separated(
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            const Divider(
                                                              height: 0,
                                                            ),
                                                    shrinkWrap: true,
                                                    itemCount: jsonList.length,
                                                    itemBuilder:
                                                        ((context, index) {
                                                      return tablecontent(
                                                          index);
                                                    })),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : itemSelection
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width <
                                              1200
                                          ? MediaQuery.of(context).size.width <
                                                  650
                                              ? MediaQuery.of(context)
                                                  .size
                                                  .width
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7
                                          : MediaQuery.of(context).size.width *
                                              0.6,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.92,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      itemSelection = false;
                                                    });
                                                  },
                                                  child: const Text("Back")),
                                            ),
                                            //Top Container
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  color: Colors.white,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.grey,
                                                        blurRadius: 3,
                                                        offset:
                                                            Offset(0.7, 0.7))
                                                  ],
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ListTile(
                                                        title: Text(
                                                          jsonList.length != 0
                                                              ? jsonList[jsonIndex]
                                                                      [
                                                                      "itemName"]
                                                                  .toUpperCase()
                                                              : "",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                        ),
                                                        trailing:
                                                            ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            maincolor),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    additem =
                                                                        true;
                                                                    additemtype =
                                                                        true;
                                                                  });
                                                                },
                                                                child: const Text(
                                                                    "Adjustment")),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 18.0,
                                                                right: 18.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  jsonList.length !=
                                                                          0
                                                                      ? "Sales Price: ₹${jsonList[jsonIndex]["salesprice"]}"
                                                                      : "Sales Price: ₹",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  jsonList.length !=
                                                                          0
                                                                      ? "Purchase Price: ₹${jsonList[jsonIndex]["purchaseprice"]}"
                                                                      : "Purchase Price: ₹",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  jsonList.length !=
                                                                          0
                                                                      ? jsonList[jsonIndex]["stock"] !=
                                                                              ""
                                                                          ? "Quantity: ${jsonList[jsonIndex]["stock"]}"
                                                                          : "Quantity:Not defined"
                                                                      : "Quantity:",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  jsonList.length !=
                                                                          0
                                                                      ? jsonList[jsonIndex]["stock"] !=
                                                                              ""
                                                                          ? "Value: ₹${int.parse(jsonList[jsonIndex]["salesprice"]) * int.parse(jsonList[jsonIndex]["stock"])}"
                                                                          : "Value: Not defined"
                                                                      : "Value: ₹",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            //Table Container
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.65,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.white,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.grey,
                                                        blurRadius: 3,
                                                        //spreadRadius: 0.5,
                                                        offset: const Offset(
                                                            0.7, 0.7))
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: const [
                                                        Text(
                                                          "Transaction",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          "List of all Recent transaction",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                    ),
                                                    Table(
                                                      border:
                                                          TableBorder.symmetric(
                                                        outside:
                                                            BorderSide.none,
                                                        inside:
                                                            const BorderSide(
                                                                width: 0.5,
                                                                color:
                                                                    Colors.grey,
                                                                style:
                                                                    BorderStyle
                                                                        .solid),
                                                      ),
                                                      columnWidths: const {
                                                        0: FlexColumnWidth(0.2),
                                                      },
                                                      children: [
                                                        TableRow(children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Text(""),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                              "Type"
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                              "Name"
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                              "Date"
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                              "Quantity"
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                              "Price"
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                              "Status"
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          )
                                                        ])
                                                      ],
                                                    ),
                                                    const Divider(
                                                      height: 0,
                                                    ),
                                                    ListView.separated(
                                                        separatorBuilder:
                                                            (context, index) =>
                                                                const Divider(
                                                                  height: 0,
                                                                ),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            jsonList.length,
                                                        itemBuilder:
                                                            ((context, index) {
                                                          return tablecontent(
                                                              index);
                                                        })),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox()
                        ],
                      ),
          )
        ],
      ),
    );
  }

  tablecontent(int index) {
    return GestureDetector(
      onTap: () {},
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(0.2),
        },
        border: TableBorder.symmetric(
          outside: BorderSide.none,
          inside: const BorderSide(
              width: 0.5, color: Colors.grey, style: BorderStyle.solid),
        ),
        children: [
          TableRow(children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.circle,
                size: 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jsonList[index]["itemType"]),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jsonList[index]["itemName"]),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(DateFormat('MM/dd/yyyy')
                  .format(jsonList[index]["create_date"].toDate())),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("${jsonList[index]["stock"]}"),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jsonList[index]["salesprice"]),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:
                  Text((int.parse(jsonList[index]["salesprice"])).toString()),
            )
          ]),
        ],
      ),
    );
  }

  noData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              "Currently you dont have any data available. Add Items to grow your business."),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  additem = true;
                  noitems = false;
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Add new item"),
              ))
        ],
      ),
    );
  }
}
