import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rasitu_login/main.dart';
import 'package:http/http.dart' as http;
import 'package:rasitu_login/module/sharedpreference.dart';

class addItems extends StatefulWidget {
  bool update;
  Map jsonList;
  final Function onUpdate;
  addItems(
      {required this.update, required this.jsonList, required this.onUpdate});

  @override
  State<addItems> createState() => _addItemsState();
}

class _addItemsState extends State<addItems> {
  int type = 0, taxpref = 0;
  int itemid = 0;
  //List jsonList = [];
  int jsonIndex = 0;
  bool salesinfo = true, purchaseinfo = true;
  String gstdropdownvalue = "5";
  String igstdropdownvalue = "5";
  String unitdropdownvalue = "Select type Unit";
  TextEditingController name = TextEditingController();
  TextEditingController hsncode = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController sellingprice = TextEditingController();
  TextEditingController purchaseprice = TextEditingController();
  String id = "";

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final PrefService _prefService = PrefService();

  void initState() {
    if (widget.update) {
      print(widget.jsonList["unit"] == "null");
      itemid = widget.jsonList["itemId"];
      name.text = widget.jsonList["itemName"];
      hsncode.text = widget.jsonList["hns_code"] ?? "";
      stock.text =
          widget.jsonList["stock"] == null ? "" : widget.jsonList["stock"];
      sellingprice.text = widget.jsonList["salesprice"] == "0"
          ? ""
          : widget.jsonList["salesprice"];
      purchaseprice.text = widget.jsonList["purchaseprice"] == "0"
          ? ""
          : widget.jsonList["purchaseprice"];
      type = widget.jsonList["itemType"] == "Goods" ? 0 : 1;
      taxpref = widget.jsonList["taxpref"] == "Y" ? 0 : 1;
      gstdropdownvalue = widget.jsonList["intratax"];
      igstdropdownvalue = widget.jsonList["intertax"];
      unitdropdownvalue = widget.jsonList["unit"] == "null"
          ? "Select type Unit"
          : widget.jsonList["unit"];
      salesinfo = widget.jsonList["salesprice"] == "0" ? false : true;
      purchaseinfo = widget.jsonList["purchaseprice"] == "0" ? false : true;
    } else {
      name.clear();
      hsncode.clear();
      stock.clear();
      sellingprice.clear();
      purchaseprice.clear();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text(
                  "New Item",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title:
                                  const Text("Do you want to leave the page?"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    widget.onUpdate("cancel");

                                    Navigator.pop(context);
                                  },
                                  child: const Text('Leave'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            );
                          });
                    },
                    child: const Icon(Icons.close)),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.height * 0.8,
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(0.4),
                    },
                    children: [
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("Type"),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                    value: 0,
                                    groupValue: type,
                                    onChanged: ((value) {
                                      setState(() {
                                        type = 0;
                                      });
                                    })),
                                const Text("Goods"),
                                const SizedBox(
                                  width: 50,
                                ),
                                Radio(
                                    value: 1,
                                    groupValue: type,
                                    onChanged: ((value) {
                                      setState(() {
                                        type = 1;
                                      });
                                    })),
                                const Text("Service")
                              ],
                            ))
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("Name*"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 35,
                            child: TextFormField(
                              controller: name,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.only(left: 10)),
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return "Name cant be empty";
                                }
                              },
                            ),
                          ),
                        )
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text("HSN Code"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 35,
                            child: TextFormField(
                              controller: hsncode,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.only(left: 10)),
                            ),
                          ),
                        )
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text("Unit"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 35,
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: unitdropdown(),
                          ),
                        )
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text("Stock"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 35,
                            child: TextFormField(
                              controller: stock,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.only(left: 10)),
                            ),
                          ),
                        )
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text("Tax Preference"),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                    value: 0,
                                    groupValue: taxpref,
                                    onChanged: ((value) {
                                      setState(() {
                                        taxpref = 0;
                                      });
                                    })),
                                const Text("Taxable"),
                                const SizedBox(
                                  width: 50,
                                ),
                                Radio(
                                    value: 1,
                                    groupValue: taxpref,
                                    onChanged: ((value) {
                                      setState(() {
                                        taxpref = 1;
                                      });
                                    })),
                                const Text("Non-Taxable")
                              ],
                            ))
                      ]),
                    ],
                  ),
                ),
              ),
              const Divider(),
              MediaQuery.of(context).size.width > 850
                  ? Row(
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              ListTile(
                                  leading: Transform.scale(
                                    scale: 0.7,
                                    child: Checkbox(
                                        value: salesinfo,
                                        onChanged: (value) {
                                          setState(() {
                                            salesinfo = value!;
                                          });
                                        }),
                                  ),
                                  title: const Text(
                                    "Sales Information",
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(0.18),
                                    1: FlexColumnWidth(0.4),
                                    2: FlexColumnWidth(0.1),
                                  },
                                  children: [
                                    TableRow(children: [
                                      const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text("Selling Price"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SizedBox(
                                          height: 35,
                                          child: TextFormField(
                                            controller: sellingprice,
                                            enabled: salesinfo,
                                            decoration: InputDecoration(
                                                filled: !salesinfo,
                                                fillColor: Colors.grey[300],
                                                border:
                                                    const OutlineInputBorder(),
                                                prefixIcon: Container(
                                                  color: Colors.grey,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: const <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: Text(
                                                          'INR',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 15)),
                                            validator: (value) {
                                              if (!salesinfo) {
                                                if (value!.isEmpty) {
                                                  return "Sales price cannot be null";
                                                } else {
                                                  return null;
                                                }
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const Text("")
                                    ]),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            children: [
                              ListTile(
                                  leading: Transform.scale(
                                    scale: 0.7,
                                    child: Checkbox(
                                        value: purchaseinfo,
                                        onChanged: (value) {
                                          setState(() {
                                            purchaseinfo = value!;
                                          });
                                        }),
                                  ),
                                  title: const Text(
                                    "Purchase Information",
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(0.18),
                                    1: FlexColumnWidth(0.4),
                                    2: FlexColumnWidth(0.1),
                                  },
                                  children: [
                                    TableRow(children: [
                                      const Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: Text("Purchase Price"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SizedBox(
                                          height: 35,
                                          child: TextFormField(
                                            controller: purchaseprice,
                                            enabled: purchaseinfo,
                                            decoration: InputDecoration(
                                                filled: !purchaseinfo,
                                                fillColor: Colors.grey[300],
                                                prefixIcon: Container(
                                                  color: Colors.grey,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: const <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: Text(
                                                          'INR',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                border:
                                                    const OutlineInputBorder(),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 10)),
                                            validator: (value) {
                                              if (purchaseinfo) {
                                                if (value!.isEmpty) {
                                                  return "Purchase price cannot be null";
                                                } else {
                                                  return null;
                                                }
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const Text("")
                                    ]),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        ListTile(
                            leading: Transform.scale(
                              scale: 0.7,
                              child: Checkbox(
                                  value: salesinfo,
                                  onChanged: (value) {
                                    setState(() {
                                      salesinfo = value!;
                                    });
                                  }),
                            ),
                            title: const Text(
                              "Sales Information",
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(0.18),
                              1: FlexColumnWidth(0.4),
                            },
                            children: [
                              TableRow(children: [
                                const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text("Selling Price"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    height: 35,
                                    child: TextFormField(
                                      enabled: salesinfo,
                                      decoration: InputDecoration(
                                          filled: !salesinfo,
                                          fillColor: Colors.grey[300],
                                          border: const OutlineInputBorder(),
                                          prefixIcon: Container(
                                            color: Colors.grey,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    'INR',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.only(left: 10)),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                        ListTile(
                            leading: Transform.scale(
                              scale: 0.7,
                              child: Checkbox(
                                  value: purchaseinfo,
                                  onChanged: (value) {
                                    setState(() {
                                      purchaseinfo = value!;
                                    });
                                  }),
                            ),
                            title: const Text(
                              "Purchase Information",
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(0.18),
                              1: FlexColumnWidth(0.4),
                            },
                            children: [
                              TableRow(children: [
                                const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text("Purchase Price"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    height: 35,
                                    child: TextFormField(
                                      enabled: purchaseinfo,
                                      decoration: InputDecoration(
                                          filled: !purchaseinfo,
                                          fillColor: Colors.grey[300],
                                          prefixIcon: Container(
                                            color: Colors.grey,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    'INR',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          border: const OutlineInputBorder(),
                                          contentPadding:
                                              const EdgeInsets.only(left: 10)),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        )
                      ],
                    ),
              const Divider(),
              const ListTile(
                title: Text(
                  "Tax Rates",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: MediaQuery.of(context).size.width > 850
                    ? Row(
                        children: [
                          const Text("Intra State Tax"),
                          const SizedBox(width: 70),
                          Container(
                            height: 35,
                            width: 250,
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: gstdropdown(),
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Intra State Tax"),
                          const SizedBox(height: 20),
                          Container(
                            height: 35,
                            width: 250,
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: gstdropdown(),
                          )
                        ],
                      ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: MediaQuery.of(context).size.width > 850
                    ? Row(
                        children: [
                          const Text("Inter State Tax"),
                          const SizedBox(width: 70),
                          Container(
                            height: 35,
                            width: 250,
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: igstdropdown(),
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Inter State Tax"),
                          const SizedBox(height: 20),
                          Container(
                            height: 35,
                            width: 250,
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: igstdropdown(),
                          )
                        ],
                      ),
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 35,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          String uid = await _prefService
                              .readId()
                              .then((value) => value);
                          setState(() {
                            id = uid;
                          });
                        } catch (e) {
                          Navigator.pushNamed(context, '/failure');
                        }
                        if (_key.currentState!.validate()) {
                          if (widget.update) {
                            Map<String, dynamic> body = {
                              'type': type == 0 ? "Goods" : "Service",
                              'name': name.text.trim(),
                              'hsn':
                                  hsncode.text.isEmpty ? "null" : hsncode.text,
                              'unit': unitdropdownvalue != "Select type Unit"
                                  ? unitdropdownvalue
                                  : "null",
                              'stock': stock.text,
                              'taxpref': taxpref == 0 ? 'Y' : 'N',
                              'salesprice': salesinfo ? sellingprice.text : "0",
                              'purchaseprice':
                                  purchaseinfo ? purchaseprice.text : "0",
                              'intratax': taxpref == 0 ? gstdropdownvalue : "0",
                              'intertax':
                                  taxpref == 0 ? igstdropdownvalue : "0",
                              'itemId': itemid,
                              'uid': id
                            };

                            FirebaseFirestore.instance
                                .collection("items")
                                .doc(itemid.toString())
                                .update(body)
                                .whenComplete(() {
                              widget.onUpdate("add");
                            });
                          } else {
                            int itemId = await getId() + 1;
                            Map<String, dynamic> body = {
                              'itemType': type == 0 ? "Goods" : "Service",
                              'itemName': name.text.trim(),
                              'hsn_code':
                                  hsncode.text.isEmpty ? "null" : hsncode.text,
                              'unit': unitdropdownvalue != "Select type Unit"
                                  ? unitdropdownvalue
                                  : "null",
                              'stock': stock.text,
                              'taxpref': taxpref == 0 ? 'Y' : 'N',
                              'salesprice': salesinfo ? sellingprice.text : "0",
                              'purchaseprice':
                                  purchaseinfo ? purchaseprice.text : "0",
                              'intratax': taxpref == 0 ? gstdropdownvalue : "0",
                              'intertax':
                                  taxpref == 0 ? igstdropdownvalue : "0",
                              'itemId': itemId,
                              'create_date': DateTime.now(),
                              'uid': id
                            };

                            FirebaseFirestore.instance
                                .collection("items")
                                .doc(itemId.toString())
                                .set(body)
                                .whenComplete(() {
                              FirebaseFirestore.instance
                                  .collection("local")
                                  .doc("local")
                                  .set({"itemid": itemId});
                              widget.onUpdate("add");
                            });
                          }
                        }
                      },
                      child: Text(widget.update ? "Update" : "Save"),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    width: 100,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                    "Do you want to leave the page?"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      widget.onUpdate("cancel");
                                      Navigator.pop(context, "Cancel");
                                    },
                                    child: const Text('Leave'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            });
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  unitdropdown() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButton2(
        isDense: true,
        buttonStyleData: const ButtonStyleData(
            height: 35, width: 400, padding: EdgeInsets.zero),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 250,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        autofocus: true,
        // Initial Value
        value: unitdropdownvalue,

        // Array list of items
        items: [
          "Select type Unit",
          "Dozen",
          "Pairs",
          "Piece",
          "Box",
          "Bottle",
          "Tablet",
          "Kilogram",
          "Gram",
          "Meter",
          "Unit"
        ].map((items) {
          return DropdownMenuItem(
            value: items,
            child: Text(
              items.toUpperCase(),
              style: const TextStyle(fontSize: 15),
            ),
          );
        }).toList(),

        onChanged: (String? newValue) {
          setState(() {
            unitdropdownvalue = newValue!;
          });
        },
      ),
    );
  }

  gstdropdown() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButton2(
        isDense: true,
        buttonStyleData: const ButtonStyleData(
            height: 35, width: 250, padding: EdgeInsets.zero),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 250,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        autofocus: true,
        // Initial Value
        value: gstdropdownvalue,

        items: ["0", "5", "12", "18", "28"].map((items) {
          return DropdownMenuItem(
            value: items,
            child: Text("GST$items [$items%]"),
          );
        }).toList(),

        onChanged: taxpref == 0
            ? (String? newValue) {
                setState(() {
                  gstdropdownvalue = newValue!;
                });
              }
            : null,
      ),
    );
  }

  igstdropdown() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButton2(
        isDense: true,
        buttonStyleData: const ButtonStyleData(
            height: 35, width: 250, padding: EdgeInsets.zero),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 250,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        autofocus: true,
        // Initial Value
        value: igstdropdownvalue,

        items: ["0", "5", "12", "18", "28"].map((items) {
          return DropdownMenuItem(
            value: items,
            child: Text("GST$items [$items%]"),
          );
        }).toList(),

        onChanged: taxpref == 0
            ? (String? newValue) {
                setState(() {
                  igstdropdownvalue = newValue!;
                });
              }
            : null,
      ),
    );
  }

  getId() async {
    int itemId = 0;

    await FirebaseFirestore.instance
        .collection("local")
        .doc("local")
        .get()
        .then((value) => itemId = value['itemid']);
    print(itemId);

    return itemId;
  }
}
