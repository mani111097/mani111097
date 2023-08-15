import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:rasitu_login/main.dart';
import 'package:rasitu_login/module/addparties.dart';
import 'package:rasitu_login/module/purchaseData.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:rasitu_login/module/sharedpreference.dart';

class PageBuilder extends StatefulWidget {
  String? invoiceId;
  String? name;
  PageBuilder({Key? key, this.invoiceId, this.name}) : super(key: key);
  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder>
    with AutomaticKeepAliveClientMixin<PageBuilder> {
  TextEditingController name = TextEditingController();
  TextEditingController dropdowntext = TextEditingController();
  TextEditingController shippingcharge = TextEditingController();
  TextEditingController invoiceNo = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController paid = TextEditingController();

  String? supplystate;
  bool checkbox = true;
  List itemsList = [];
  List<String> customerName = [];
  String? selection;
  List customerList = [];
  List<String> itemNames = [];
  int? customerindex;
  String? sos;
  String taxoption = "Tax Exclusive";
  String taxtype = "";
  List purchaselist = [];
  List totals = [0.0, 0.0, 0.0, 0.0];
  String id = "";
  final PrefService _prefService = PrefService();
  bool update = false;
  String? paymentType = "Cash";

  getData() async {
    print("Invoice Data ${widget.invoiceId}");
    try {
      String uid = await _prefService.readId().then((value) => value);
      setState(() {
        id = uid;
      });
      //Provider.of<PurchaseData>(context, listen: false).cleargst();
      Provider.of<PurchaseData>(context, listen: false).clearCache();
      if (widget.invoiceId!.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('items')
            .where("uid", isEqualTo: id)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            for (var element in value.docs) {
              setState(() {
                itemsList.add(element.data());
                itemNames.add(element.data()["itemName"]);
              });
            }
          }
        });
        await FirebaseFirestore.instance
            .collection('User')
            .where("userId", isEqualTo: id)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            sos = value.docs.first.data()["sos"] ?? "";
          }
        });

        await FirebaseFirestore.instance
            .collection(widget.name!.toLowerCase())
            .doc(widget.invoiceId)
            .get()
            .then((value) {
          setState(() {
            update = true;
            invoiceNo.text = value.data()!["${widget.name!.toLowerCase()}Id"];
            date.text = value.data()!["date"];
            supplystate = value.data()!["POS"].toString();
            taxoption = value.data()!["taxtype"].toString();
            customerList.add({
              "companyName": value.data()!["customerName"],
              "customerId": value.data()!["customerId"],
              "gstType": value.data()!["customergstType"],
              "GSTIN": value.data()!["customerGSTIN"],
              "billingAddress": value.data()!["billAddress"],
              "shippingAddress": value.data()!["shipAddress"],
            });
            customerindex = 0;
            purchaselist = value.data()!["purchaseList"];
            print("purchase list $purchaselist");
            Provider.of<PurchaseData>(context, listen: false)
                .updatePurchase(purchaselist);
            Provider.of<PurchaseData>(context, listen: false)
                .updateSubtotal(purchaselist);
            if (sos == supplystate) {
              Provider.of<PurchaseData>(context, listen: false)
                  .updategstType("GST");
              Provider.of<PurchaseData>(context, listen: false)
                  .gst(purchaselist);
            } else {
              Provider.of<PurchaseData>(context, listen: false)
                  .updategstType("IGST");
              Provider.of<PurchaseData>(context, listen: false)
                  .igst(purchaselist);
            }
            Provider.of<PurchaseData>(context, listen: false).updateTotal(
                Provider.of<PurchaseData>(context, listen: false).subtotal,
                Provider.of<PurchaseData>(context, listen: false).gsttotal,
                Provider.of<PurchaseData>(context, listen: false)
                    .shippingcharge,
                Provider.of<PurchaseData>(context, listen: false).taxtype);
          });
        });
      } else {
        await FirebaseFirestore.instance
            .collection('items')
            .where("uid", isEqualTo: id)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            for (var element in value.docs) {
              setState(() {
                itemsList.add(element.data());
                itemNames.add(element.data()["itemName"]);
              });
            }
          }
        });
        await FirebaseFirestore.instance
            .collection('Customers')
            .where("uid", isEqualTo: id)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            for (var element in value.docs) {
              setState(() {
                customerList.add(element.data());
                customerName.add(element.data()["companyName"]);
              });
            }
          } else {
            customerName.add("+ Add Customer");
          }
        });
        await FirebaseFirestore.instance
            .collection('User')
            .where("userId", isEqualTo: id)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            sos = value.docs.first.data()["sos"] ?? "";
          }
        });
        setState(() {
          update = false;
          invoiceNo.text =
              DateTime.now().millisecond.toString().padLeft(3, "0") +
                  DateTime.now().day.toString().padLeft(2, "0") +
                  DateTime.now().month.toString().padLeft(2, "0") +
                  DateTime.now().microsecond.toString().padLeft(3, "0");
          date.text = intl.DateFormat('yyyy-MM-dd').format(DateTime.now());
        });
      }
    } catch (e) {
      print(e);
    }

    //Navigator.pop(context);

    print(customerList);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 1.0, offset: Offset(0.1, 0.1)),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
                height: 40,
                width: 120,
                child: TextButton(
                    onPressed: () {
                      Provider.of<PurchaseData>(context, listen: false)
                          .clearCache();

                      context.go('/home/${widget.name!.toLowerCase()}');
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.blue),
                    ))),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
                height: 40,
                width: 120,
                child: ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> invoiceBody = {
                        "uid": id,
                        "${widget.name!.toLowerCase()}Id": invoiceNo.text,
                        "customerName": customerList[customerindex!]
                            ["companyName"],
                        "customerId": customerList[customerindex!]
                            ["customerId"],
                        "billAddress": customerList[customerindex!]
                            ["billingAddress"],
                        "shipAddress": customerList[customerindex!]
                            ["shippingAddress"],
                        "POS": supplystate,
                        "taxtype":
                            Provider.of<PurchaseData>(context, listen: false)
                                        .taxtype ==
                                    0.0
                                ? "Tax Exclusive"
                                : "Tax Inclusive",
                        "totalTax":
                            Provider.of<PurchaseData>(context, listen: false)
                                .gsttotal,
                        "total":
                            Provider.of<PurchaseData>(context, listen: false)
                                .total
                                .roundToDouble()
                                .toString(),
                        "subtotal":
                            Provider.of<PurchaseData>(context, listen: false)
                                .subtotal
                                .toString(),
                        "shippingCharges":
                            Provider.of<PurchaseData>(context, listen: false)
                                .shippingcharge
                                .toString(),
                        "purchaseList": purchaselist,
                        "date": date.text,
                        "status":
                            Provider.of<PurchaseData>(context, listen: false)
                                        .balance ==
                                    0
                                ? "Paid"
                                : "Credit",
                        "paymentType": paymentType,
                        "balance":
                            Provider.of<PurchaseData>(context, listen: false)
                                .balance
                                .toString()
                      };

                      if (update) {
                        FirebaseFirestore.instance
                            .collection(widget.name!.toLowerCase())
                            .doc(invoiceNo.text)
                            .update(invoiceBody)
                            .whenComplete(() {
                          Provider.of<PurchaseData>(context, listen: false)
                              .clearCache();
                          context.go('/home/${widget.name!.toLowerCase()}');
                        });
                      } else {
                        FirebaseFirestore.instance
                            .collection(widget.name!.toLowerCase())
                            .doc(invoiceNo.text)
                            .set(invoiceBody)
                            .whenComplete(() {
                          Provider.of<PurchaseData>(context, listen: false)
                              .clearCache();
                          context.go('/home/${widget.name!.toLowerCase()}');
                        });
                      }
                    },
                    child: const Text("Save"))),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.name!,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          InkWell(
            onTap: () => context.go('/home/${widget.name!.toLowerCase()}'),
            child: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              MediaQuery.of(context).size.width > 1000
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 34,
                                width: 250,
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                          focusColor: Colors.transparent),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          iconStyleData: const IconStyleData(
                                              icon: SizedBox()),
                                          isExpanded: true,
                                          hint: Text(
                                            'Select Customer',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),

                                          items: customerName
                                              .map((item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          value: selection,
                                          onChanged: (value) async {
                                            if (value != "+ Add Customer") {
                                              for (int i = 0;
                                                  i < customerList.length;
                                                  i++) {
                                                if ("${customerList[i]["companyName"]}" ==
                                                    value) {
                                                  if (sos ==
                                                      customerList[i]["pos"]) {
                                                    Provider.of<PurchaseData>(
                                                            context,
                                                            listen: false)
                                                        .updategstType("GST");
                                                    setState(() {
                                                      customerindex = i;
                                                      supplystate =
                                                          customerList[i]
                                                              ["pos"];
                                                      taxtype = "GST";
                                                    });
                                                  } else {
                                                    Provider.of<PurchaseData>(
                                                            context,
                                                            listen: false)
                                                        .updategstType("IGST");
                                                    setState(() {
                                                      customerindex = i;
                                                      supplystate =
                                                          customerList[i]
                                                              ["pos"];
                                                      taxtype = "IGST";
                                                    });
                                                  }
                                                }
                                              }
                                            } else {
                                              var res = await showDialog(
                                                  context: context,
                                                  builder: (builder) =>
                                                      Addparties(false, {}));

                                              if (res == "Added") {
                                                try {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Customers')
                                                      .where("uid",
                                                          isEqualTo: id)
                                                      .get()
                                                      .then((value) {
                                                    if (value.docs.isNotEmpty) {
                                                      setState(() {
                                                        customerList.clear();
                                                      });
                                                      for (var element
                                                          in value.docs) {
                                                        setState(() {
                                                          customerList.add(
                                                              element.data());
                                                          customerName.add(
                                                              element.data()[
                                                                  "companyName"]);
                                                        });
                                                      }
                                                    }
                                                  });
                                                  setState(() {
                                                    customerName
                                                        .add("+ Add Customer");
                                                  });
                                                } catch (e) {
                                                  print(e);
                                                }
                                              }
                                            }

                                            setState(() {
                                              selection = value as String;
                                            });
                                          },
                                          buttonStyleData:
                                              const ButtonStyleData(
                                            height: 40,
                                            width: 200,
                                          ),
                                          dropdownStyleData:
                                              const DropdownStyleData(
                                            maxHeight: 200,
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                          ),
                                          dropdownSearchData:
                                              DropdownSearchData(
                                            searchController: name,
                                            searchInnerWidgetHeight: 50,
                                            searchInnerWidget: Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 4,
                                                right: 8,
                                                left: 8,
                                              ),
                                              child: TextFormField(
                                                expands: true,
                                                maxLines: null,
                                                controller: name,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              return (item.value!
                                                  .toLowerCase()
                                                  .toString()
                                                  .contains(searchValue
                                                      .toLowerCase()));
                                            },
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              name.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.person_add,
                                      color: maincolor,
                                    )
                                  ],
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            MediaQuery.of(context).size.width > 850
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customerindex != null
                                                ? const Text(
                                                    "Billing Address:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : const SizedBox(),
                                            Text(customerindex != null
                                                ? "${customerList[customerindex!]["billingAddress"]["billStreet"]},\n${customerList[customerindex!]["billingAddress"]["billArea"]},\n${customerList[customerindex!]["billingAddress"]["billCity"]}-${customerList[customerindex!]["billingAddress"]["billZipcode"]}\n${customerList[customerindex!]["billingAddress"]["billPhone"]}"
                                                : ""),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(customerindex != null
                                                ? "GST Type: ${customerList[customerindex!]["gstType"]}"
                                                : ""),
                                          ],
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   width: 150,
                                      // ),
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customerindex != null
                                                ? const Text(
                                                    "Shipping Address:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : const SizedBox(),
                                            Text(customerindex != null
                                                ? "${customerList[customerindex!]["shippingAddress"]["shipStreet"]},\n${customerList[customerindex!]["shippingAddress"]["shipArea"]},\n${customerList[customerindex!]["shippingAddress"]["shipCity"]}-${customerList[customerindex!]["shippingAddress"]["shipZipcode"]}\n${customerList[customerindex!]["shippingAddress"]["shipPhone"]}"
                                                : ""),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(customerindex != null
                                                ? customerList[customerindex!]
                                                            ["GSTIN"] !=
                                                        "null"
                                                    ? "GSTIN: ${customerList[customerindex!]["GSTIN"]}"
                                                    : ""
                                                : ""),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customerindex != null
                                                ? const Text(
                                                    "Billing Address:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : const SizedBox(),
                                            Text(customerindex != null
                                                ? "${customerList[customerindex!]["billingAddress"]["billStreet"]},\n${customerList[customerindex!]["billingAddress"]["billArea"]},\n${customerList[customerindex!]["billingAddress"]["billCity"]}-${customerList[customerindex!]["billingAddress"]["billZipcode"]}\n${customerList[customerindex!]["billingAddress"]["billPhone"]}"
                                                : ""),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(customerindex != null
                                                ? "GST Type: ${customerList[customerindex!]["gstType"]}"
                                                : ""),
                                          ],
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   width: 150,
                                      // ),
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customerindex != null
                                                ? const Text(
                                                    "Shipping Address:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : const SizedBox(),
                                            Text(customerindex != null
                                                ? "${customerList[customerindex!]["shippingAddress"]["shipStreet"]},\n${customerList[customerindex!]["shippingAddress"]["shipArea"]},\n${customerList[customerindex!]["shippingAddress"]["shipCity"]}-${customerList[customerindex!]["shippingAddress"]["shipZipcode"]}\n${customerList[customerindex!]["shippingAddress"]["shipPhone"]}"
                                                : ""),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(customerindex != null
                                                ? customerList[customerindex!]
                                                            ["GSTIN"] !=
                                                        "null"
                                                    ? "GSTIN: ${customerList[customerindex!]["GSTIN"]}"
                                                    : ""
                                                : ""),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                          ],
                        ),
                        SizedBox(
                          width: 350,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("${widget.name} No.:"),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: invoiceNo,
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("${widget.name} Date:"),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: date,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2015),
                                                lastDate: DateTime(2100));

                                        print(pickedDate);

                                        if (pickedDate != null) {
                                          String formatedDate =
                                              intl.DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          setState(() {
                                            date.text = formatedDate;
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("State of Supply:"),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(child: supplydropdown())
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("Item Rates are"),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(child: taxOption())
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 34,
                                width: 250,
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(focusColor: Colors.transparent),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      iconStyleData:
                                          const IconStyleData(icon: SizedBox()),
                                      isExpanded: true,
                                      hint: Text(
                                        'Select Customer',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                      items: customerName
                                          .map((item) => DropdownMenuItem(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      value: selection,
                                      onChanged: (value) async {
                                        if (value != "+ Add Customer") {
                                          for (int i = 0;
                                              i < customerList.length;
                                              i++) {
                                            if ("${customerList[i]["companyName"]}" ==
                                                value) {
                                              if (sos ==
                                                  customerList[i]["pos"]) {
                                                Provider.of<PurchaseData>(
                                                        context,
                                                        listen: false)
                                                    .updategstType("GST");
                                                setState(() {
                                                  customerindex = i;
                                                  supplystate =
                                                      customerList[i]["pos"];
                                                  taxtype = "GST";
                                                });
                                              } else {
                                                Provider.of<PurchaseData>(
                                                        context,
                                                        listen: false)
                                                    .updategstType("IGST");
                                                setState(() {
                                                  customerindex = i;
                                                  supplystate =
                                                      customerList[i]["pos"];
                                                  taxtype = "IGST";
                                                });
                                              }
                                            }
                                          }
                                        } else {
                                          var res = await showDialog(
                                              context: context,
                                              builder: (builder) =>
                                                  Addparties(false, {}));

                                          if (res == "Added") {
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('Customers')
                                                  .where("uid", isEqualTo: id)
                                                  .get()
                                                  .then((value) {
                                                if (value.docs.isNotEmpty) {
                                                  setState(() {
                                                    customerList.clear();
                                                  });
                                                  for (var element
                                                      in value.docs) {
                                                    setState(() {
                                                      customerList
                                                          .add(element.data());
                                                      customerName.add(
                                                          element.data()[
                                                              "companyName"]);
                                                    });
                                                  }
                                                }
                                              });
                                              setState(() {
                                                customerName
                                                    .add("+ Add Customer");
                                              });
                                            } catch (e) {
                                              print(e);
                                            }
                                          }
                                        }

                                        setState(() {
                                          selection = value as String;
                                        });
                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        height: 40,
                                        width: 200,
                                      ),
                                      dropdownStyleData:
                                          const DropdownStyleData(
                                        maxHeight: 200,
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                      ),
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: name,
                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Container(
                                          height: 50,
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 4,
                                            right: 8,
                                            left: 8,
                                          ),
                                          child: TextFormField(
                                            expands: true,
                                            maxLines: null,
                                            controller: name,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                        ),
                                        searchMatchFn: (item, searchValue) {
                                          return (item.value!
                                              .toLowerCase()
                                              .toString()
                                              .contains(
                                                  searchValue.toLowerCase()));
                                        },
                                      ),
                                      //This to clear the search value when you close the menu
                                      onMenuStateChange: (isOpen) {
                                        if (!isOpen) {
                                          name.clear();
                                        }
                                      },
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            MediaQuery.of(context).size.width > 850
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customerindex != null
                                                ? const Text(
                                                    "Billing Address:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : const SizedBox(),
                                            Text(customerindex != null
                                                ? "${customerList[customerindex!]["billingAddress"]["billStreet"]},\n${customerList[customerindex!]["billingAddress"]["billArea"]},\n${customerList[customerindex!]["billingAddress"]["billCity"]}-${customerList[customerindex!]["billingAddress"]["billZipcode"]}\n${customerList[customerindex!]["billingAddress"]["billPhone"]}"
                                                : ""),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(customerindex != null
                                                ? "GST Type: ${customerList[customerindex!]["gstType"]}"
                                                : ""),
                                          ],
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   width: 150,
                                      // ),
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customerindex != null
                                                ? const Text(
                                                    "Shipping Address:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : const SizedBox(),
                                            Text(customerindex != null
                                                ? "${customerList[customerindex!]["shippingAddress"]["shipStreet"]},\n${customerList[customerindex!]["shippingAddress"]["shipArea"]},\n${customerList[customerindex!]["shippingAddress"]["shipCity"]}-${customerList[customerindex!]["shippingAddress"]["shipZipcode"]}\n${customerList[customerindex!]["shippingAddress"]["shipPhone"]}"
                                                : ""),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(customerindex != null
                                                ? customerList[customerindex!]
                                                            ["GSTIN"] !=
                                                        "null"
                                                    ? "GSTIN: ${customerList[customerindex!]["GSTIN"]}"
                                                    : ""
                                                : ""),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customerindex != null
                                                ? const Text(
                                                    "Billing Address:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : const SizedBox(),
                                            Text(customerindex != null
                                                ? "${customerList[customerindex!]["billingAddress"]["billStreet"]},\n${customerList[customerindex!]["billingAddress"]["billArea"]},\n${customerList[customerindex!]["billingAddress"]["billCity"]}-${customerList[customerindex!]["billingAddress"]["billZipcode"]}\n${customerList[customerindex!]["billingAddress"]["billPhone"]}"
                                                : ""),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(customerindex != null
                                                ? "GST Type: ${customerList[customerindex!]["gstType"]}"
                                                : ""),
                                          ],
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   width: 150,
                                      // ),
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customerindex != null
                                                ? const Text(
                                                    "Shipping Address:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : const SizedBox(),
                                            Text(customerindex != null
                                                ? "${customerList[customerindex!]["shippingAddress"]["shipStreet"]},\n${customerList[customerindex!]["shippingAddress"]["shipArea"]},\n${customerList[customerindex!]["shippingAddress"]["shipCity"]}-${customerList[customerindex!]["shippingAddress"]["shipZipcode"]}\n${customerList[customerindex!]["shippingAddress"]["shipPhone"]}"
                                                : ""),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(customerindex != null
                                                ? customerList[customerindex!]
                                                            ["GSTIN"] !=
                                                        "null"
                                                    ? "GSTIN: ${customerList[customerindex!]["GSTIN"]}"
                                                    : ""
                                                : ""),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                          ],
                        ),
                        SizedBox(
                          width: 350,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("${widget.name} No.:"),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: invoiceNo,
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("${widget.name} Date:"),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: date,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2015),
                                                lastDate: DateTime(2100));

                                        print(pickedDate);

                                        if (pickedDate != null) {
                                          String formatedDate =
                                              intl.DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          setState(() {
                                            date.text = formatedDate;
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("State of Supply:"),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(child: supplydropdown())
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("Item Rates are"),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(child: taxOption())
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        width: 0.5,
                        color: Colors.grey,
                        style: BorderStyle.solid)),
                child: Column(
                  children: [
                    Table(
                      border: TableBorder.symmetric(
                        // outside: const BorderSide(
                        //     width: 0.5, color: Colors.grey, style: BorderStyle.solid),
                        inside: const BorderSide(
                            width: 0.5,
                            color: Colors.grey,
                            style: BorderStyle.solid),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(0.15),
                        1: FlexColumnWidth(1.2),
                        2: FlexColumnWidth(0.42),
                        3: FlexColumnWidth(0.42),
                        4: FlexColumnWidth(0.42),
                        5: FlexColumnWidth(0.42),
                        6: FlexColumnWidth(0.42),
                      },
                      children: const [
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "#",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Item",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Quantity",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Rate",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Discount",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Tax",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Amount",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ])
                      ],
                    ),
                    const Divider(
                      height: 0,
                    ),
                    ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                              height: 0,
                            ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: purchaselist.length,
                        itemBuilder: ((context, index) {
                          print("index $index");

                          return TableContent(
                            key: UniqueKey(),
                            purchaseValue: purchaselist[index],
                            index: index,
                            //tax: taxtype,
                            onUpdate: (value, index) {
                              Provider.of<PurchaseData>(context, listen: false)
                                  .updatePurchase(value);
                              Provider.of<PurchaseData>(context, listen: false)
                                  .updateSubtotal(value);

                              Provider.of<PurchaseData>(context, listen: false)
                                  .cleargst();
                              Provider.of<PurchaseData>(context, listen: false)
                                  .gst(value);
                              Provider.of<PurchaseData>(context, listen: false)
                                  .igst(value);
                              Provider.of<PurchaseData>(context, listen: false)
                                  .updateTotal(
                                      Provider.of<PurchaseData>(context,
                                              listen: false)
                                          .subtotal,
                                      Provider.of<PurchaseData>(context,
                                              listen: false)
                                          .gsttotal,
                                      Provider.of<PurchaseData>(context,
                                              listen: false)
                                          .shippingcharge,
                                      Provider.of<PurchaseData>(context,
                                              listen: false)
                                          .taxtype);
                              totalContainer();
                            },
                            onDelete: (value) {
                              Provider.of<PurchaseData>(context, listen: false)
                                  .cleargst();

                              setState(() {
                                purchaselist.remove(value);
                              });
                              Provider.of<PurchaseData>(context, listen: false)
                                  .updatePurchase(purchaselist);
                              Provider.of<PurchaseData>(context, listen: false)
                                  .updateSubtotal(purchaselist);

                              Provider.of<PurchaseData>(context, listen: false)
                                  .gst(purchaselist);
                              Provider.of<PurchaseData>(context, listen: false)
                                  .igst(purchaselist);
                              Provider.of<PurchaseData>(context, listen: false)
                                  .updateTotal(
                                      Provider.of<PurchaseData>(context,
                                              listen: false)
                                          .subtotal,
                                      Provider.of<PurchaseData>(context,
                                              listen: false)
                                          .gsttotal,
                                      Provider.of<PurchaseData>(context,
                                              listen: false)
                                          .shippingcharge,
                                      Provider.of<PurchaseData>(context,
                                              listen: false)
                                          .taxtype);
                              totalContainer();
                            },
                          );
                        })),
                    const Divider(
                      height: 0,
                    ),
                    Table(
                      border: TableBorder.symmetric(
                        inside: const BorderSide(
                            width: 0.5,
                            color: Colors.grey,
                            style: BorderStyle.solid),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(0.15),
                        1: FlexColumnWidth(1.2),
                        2: FlexColumnWidth(0.42),
                        3: FlexColumnWidth(0.42),
                        4: FlexColumnWidth(0.42),
                        5: FlexColumnWidth(0.42),
                        6: FlexColumnWidth(0.42),
                      },
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              (purchaselist.length + 1).toString(),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(focusColor: Colors.transparent),
                            child: DropDownField(
                              controller: dropdowntext,
                              hintText: 'Items',
                              items: itemNames,
                              textStyle: const TextStyle(),
                              onValueChanged: (value) {
                                for (int i = 0; i < itemsList.length; i++) {
                                  if (itemsList[i]["itemName"] == value) {
                                    Map<String, dynamic> paurchasedata = {
                                      "itemId": itemsList[i]["itemId"],
                                      "itemName": itemsList[i]["itemName"],
                                      "description": "",
                                      "quantity": 1.0,
                                      "type": itemsList[i]["itemType"],
                                      "code": "${itemsList[i]["hsn_code"]}",
                                      "unit": itemsList[i]["unit"],
                                      "rate": itemsList[i]["salesprice"],
                                      "discount": 0.0,
                                      "tax": itemsList[i]["intertax"],
                                      "amount": 1.0 *
                                          double.parse(
                                              itemsList[i]["salesprice"]),
                                      "taxType": Provider.of<PurchaseData>(
                                                      context,
                                                      listen: false)
                                                  .taxtype ==
                                              0.0
                                          ? "Tax Exclusive"
                                          : "Tax Inclusive"
                                    };

                                    setState(() {
                                      purchaselist.add(paurchasedata);
                                    });
                                    Provider.of<PurchaseData>(context,
                                            listen: false)
                                        .updatePurchase(purchaselist);
                                    Provider.of<PurchaseData>(context,
                                            listen: false)
                                        .updateSubtotal(purchaselist);
                                    if (Provider.of<PurchaseData>(context,
                                                listen: false)
                                            .gsttype ==
                                        "GST") {
                                      Provider.of<PurchaseData>(context,
                                              listen: false)
                                          .gst(purchaselist);
                                    } else {
                                      Provider.of<PurchaseData>(context,
                                              listen: false)
                                          .igst(purchaselist);
                                    }
                                    Provider.of<PurchaseData>(context,
                                            listen: false)
                                        .updateTotal(
                                            Provider.of<PurchaseData>(context,
                                                    listen: false)
                                                .subtotal,
                                            Provider.of<PurchaseData>(context,
                                                    listen: false)
                                                .gsttotal,
                                            Provider.of<PurchaseData>(context,
                                                    listen: false)
                                                .shippingcharge,
                                            Provider.of<PurchaseData>(context,
                                                    listen: false)
                                                .taxtype);
                                  }
                                }
                                dropdowntext.clear();
                              },
                            ),
                          ),
                          TextFormField(
                            enabled: false,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(
                                  10,
                                )),
                          ),
                          TextFormField(
                            enabled: false,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(
                                  10,
                                )),
                          ),
                          TextFormField(
                            enabled: false,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(
                                  10,
                                )),
                          ),
                          TextFormField(
                            enabled: false,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(
                                  10,
                                )),
                          ),
                          TextFormField(
                            enabled: false,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(
                                  10,
                                )),
                          ),
                        ])
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    leftSideContainer(),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const Text("Payment Type"),
                    //     paymentTypeDropdown(),
                    //   ],
                    // ),
                    totalContainer()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  leftSideContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Payment Type"),
            const SizedBox(
              height: 10,
            ),
            paymentTypeDropdown(),
            const SizedBox(
              height: 80,
            ),
            const Text("Terms & Condition"),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            )
          ],
        ),
      ),
    );
  }

  totalContainer() {
    return Consumer<PurchaseData>(
      builder: (context, value, child) {
        return Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: 400,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                value.taxtype == 1.0
                    ? ListTile(
                        title: const Text(
                          "Sub Total",
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: const Text("(Tax Inclusive)"),
                        trailing: Text(value.purchaseList.isNotEmpty
                            ? value.subtotal.toStringAsFixed(2)
                            : "0.0"),
                      )
                    : ListTile(
                        title: const Text(
                          "Sub Total",
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: Text(value.purchaseList.isNotEmpty
                            ? value.subtotal.toStringAsFixed(2)
                            : "0.0"),
                      ),
                value.gsttype == "GST"
                    ? value.purchaseList.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.gstList.length,
                            itemBuilder: (context, index) {
                              return gstcart(value.gstList, index);
                            })
                        : const SizedBox()
                    : value.gsttype == "IGST"
                        ? value.purchaseList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: value.igstList.length,
                                itemBuilder: (context, index) {
                                  return igstcart(value.igstList, index);
                                })
                            : const SizedBox()
                        : const SizedBox(),
                ListTile(
                  title: const Text(
                    "Shipping Charges",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: shippingcharge,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (values) {
                        if (values.isNotEmpty) {
                          Provider.of<PurchaseData>(context, listen: false)
                              .updateshippingCharge(values);

                          Provider.of<PurchaseData>(context, listen: false)
                              .updateTotal(value.subtotal, value.gsttotal,
                                  double.parse(values), value.taxtype);
                        } else {
                          Provider.of<PurchaseData>(context, listen: false)
                              .updateshippingCharge("0.0");
                          Provider.of<PurchaseData>(context, listen: false)
                              .updateTotal(value.subtotal, value.gsttotal, 0.0,
                                  value.taxtype);
                        }
                      },
                    ),
                  ),
                ),
                ListTile(
                  title: const Text(
                    "Round off",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: roundoff(value) < 0.5
                      ? Text("-" + roundoff(value).toString())
                      : Text(roundoff(value).toString()),
                ),
                ListTile(
                    title: const Text(
                      "Total ( ₹ )",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    trailing: Text(
                      value.purchaseList.isNotEmpty
                          ? value.total.roundToDouble().toString()
                          : "0.0",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    )),
                widget.name == "Invoice"
                    ? ListTile(
                        leading: Checkbox(
                            value: checkbox,
                            onChanged: (values) {
                              setState(() {
                                checkbox = !checkbox;
                              });
                              if (checkbox) {
                                setState(() {
                                  paid.text =
                                      value.total.roundToDouble().toString();
                                });
                              } else {
                                setState(() {
                                  paid.clear();
                                });
                              }
                            }),
                        title: const Text(
                          "Paid",
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: paid,
                            textDirection: TextDirection.rtl,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: value.purchaseList.isNotEmpty
                                  ? checkbox
                                      ? value.total.roundToDouble().toString()
                                      : ""
                                  : "0.0",
                              hintStyle: const TextStyle(color: Colors.black),
                              hintTextDirection: TextDirection.rtl,
                              contentPadding: const EdgeInsets.all(10),
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (values) {
                              if (values.isNotEmpty) {
                                double payment = value.total.roundToDouble() -
                                    double.parse(values);
                                Provider.of<PurchaseData>(context,
                                        listen: false)
                                    .updateBalance(payment.toString());
                              } else {
                                Provider.of<PurchaseData>(context,
                                        listen: false)
                                    .updateBalance("0.0");
                              }
                            },
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.name == "Invoice"
                    ? ListTile(
                        title: const Text(
                          "Balance ( ₹ )",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        trailing: Text(
                          value.purchaseList.isNotEmpty
                              ? value.balance.roundToDouble().toString()
                              : "0.0",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ))
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  paymentTypeDropdown() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButton2(
        isDense: true,
        hint: const Text("Select payment Mode"),
        buttonStyleData: const ButtonStyleData(
            height: 20, width: 200, padding: EdgeInsets.zero),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 250,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 25,
        ),
        autofocus: true,
        // Initial Value
        value: paymentType,

        // Array list of items
        items: ["Cash", "Card", "Check", "UPI", "Online"].map((items) {
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
            paymentType = newValue!;
          });
        },
      ),
    );
  }

  taxOption() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButton2(
        isDense: true,
        buttonStyleData: const ButtonStyleData(
          height: 25,
          width: 250,
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        autofocus: true,
        // Initial Value
        value: taxoption,

        items: ["Tax Inclusive", "Tax Exclusive"].map((items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),

        onChanged: (String? newValue) {
          var purchaselist =
              Provider.of<PurchaseData>(context, listen: false).purchaseList;

          setState(() {
            taxoption = newValue!;
          });

          print(taxoption);

          if (taxoption == "Tax Exclusive") {
            Provider.of<PurchaseData>(context, listen: false).taxoption(0.0);
          } else {
            Provider.of<PurchaseData>(context, listen: false).taxoption(1.0);
          }
          print(Provider.of<PurchaseData>(context, listen: false).taxtype);

          Provider.of<PurchaseData>(context, listen: false)
              .updateSubtotal(purchaselist);
          Provider.of<PurchaseData>(context, listen: false).cleargst();
          Provider.of<PurchaseData>(context, listen: false).gst(purchaselist);
          Provider.of<PurchaseData>(context, listen: false).igst(purchaselist);
          Provider.of<PurchaseData>(context, listen: false).updateTotal(
              Provider.of<PurchaseData>(context, listen: false).subtotal,
              Provider.of<PurchaseData>(context, listen: false).gsttotal,
              Provider.of<PurchaseData>(context, listen: false).shippingcharge,
              Provider.of<PurchaseData>(context, listen: false).taxtype);

          totalContainer();
        },
      ),
    );
  }

  gstcart(List gstList, int index) {
    print(gstList);
    return Column(
      children: [
        double.parse(gstList[index]["amount"].toString()) != 0
            ? ListTile(
                title: Text(
                  "SGST${(int.parse(gstList[index]["tax"]) / 2)} [${(int.parse(gstList[index]["tax"]) / 2)}%]",
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: Text(gstList[index]["tax"] == "0"
                    ? "0"
                    : "${double.parse(gstList[index]["amount"]) / 2}"),
              )
            : const SizedBox(),
        double.parse(gstList[index]["amount"].toString()) != 0
            ? ListTile(
                title: Text(
                  "CGST${(int.parse(gstList[index]["tax"]) / 2)} [${(int.parse(gstList[index]["tax"]) / 2)}%]",
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: Text(gstList[index]["tax"] == "0"
                    ? "0"
                    : "${double.parse(gstList[index]["amount"]) / 2}"),
              )
            : const SizedBox()
      ],
    );
  }

  igstcart(List igstList, int index) {
    return Column(
      children: [
        double.parse(igstList[index]["amount"].toString()) != 0
            ? ListTile(
                title: Text(
                  "IGST${igstList[index]["tax"]} [${igstList[index]["tax"]}%]",
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: Text(igstList[index]["tax"] == "0"
                    ? "0"
                    : "${double.parse(igstList[index]["amount"])}"),
              )
            : const SizedBox(),
      ],
    );
  }

  double roundoff(PurchaseData data) {
    double roundoff = 0;
    double total = data.gsttype == "" || data.taxtype == 1.0
        ? data.subtotal + data.shippingcharge
        : data.subtotal + data.shippingcharge + data.gsttotal;
    roundoff = total - total.toInt();
    print(roundoff);
    return double.parse(roundoff.toStringAsFixed(2));
  }

  @override
  bool get wantKeepAlive => true;

  supplydropdown() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButton2<String>(
        isDense: true,
        hint: const Text("Select"),
        value: supplystate,
        buttonStyleData: const ButtonStyleData(
          height: 25,
          width: 250,
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        onChanged: (String? newValue) {
          setState(() {
            supplystate = newValue!;
          });
          print(sos);
          if (sos == supplystate) {
            Provider.of<PurchaseData>(context, listen: false).cleargst();
            Provider.of<PurchaseData>(context, listen: false)
                .updategstType("GST");
            Provider.of<PurchaseData>(context, listen: false).gst(purchaselist);
          } else {
            Provider.of<PurchaseData>(context, listen: false).cleargst();
            Provider.of<PurchaseData>(context, listen: false)
                .updategstType("IGST");
            Provider.of<PurchaseData>(context, listen: false)
                .igst(purchaselist);
          }
        },
        //icon: const Icon(Icons.keyboard_arrow_down),
        items: [
          "Andaman and Nicobar Islands",
          "Andhra Pradesh",
          "Arunachal Pradesh",
          "Assam",
          "Bihar",
          "Chandigarh",
          "Chhattisgarh",
          "Dadra and Nagar Haveli",
          "Daman and Diu",
          "Delhi",
          "Goa",
          "Gujarat",
          "Haryana",
          "Himachal Pradesh",
          "Jammu and Kashmir",
          "Jharkhand",
          "Karnataka",
          "Kerala",
          "Ladakh",
          "Lakshadweep",
          "Madhya Pradesh",
          "Maharashtra",
          "Manipur",
          "Meghalaya",
          "Mizoram",
          "Nagaland",
          "Odisha",
          "Puducherry",
          "Punjab",
          "Rajasthan",
          "Sikkim",
          "Tamil Nadu",
          "Telangana",
          "Tripura",
          "Uttar Pradesh",
          "Uttarakhand",
          "West Bengal"
        ].map((items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
      ),
    );
  }
}

class TableContent extends StatefulWidget {
  final Map purchaseValue;
  final int index;
  //final String tax;
  final Function onUpdate;
  final Function onDelete;

  const TableContent(
      {Key? key,
      required this.purchaseValue,
      required this.index,
      //required this.tax,
      required this.onUpdate,
      required this.onDelete})
      : super(key: key);

  @override
  State<TableContent> createState() => _TableContentState();
}

class _TableContentState extends State<TableContent> {
  TextEditingController itemname = TextEditingController();
  TextEditingController itemQuantity = TextEditingController();
  TextEditingController itemRate = TextEditingController();
  TextEditingController itemDiscount = TextEditingController();
  TextEditingController itemTax = TextEditingController();
  TextEditingController itemAmount = TextEditingController();
  String unit = "";
  String type = "";
  String code = "";

  String? gstdropdownvalue;
  String igstdropdownvalue = "0";

  List purchaseList = [];

  setData() {
    var purchaselist =
        Provider.of<PurchaseData>(context, listen: false).purchaseList;
    print(
        "purchaseList $purchaseList ${Provider.of<PurchaseData>(context, listen: false).gsttype}");
    unit = purchaselist[widget.index]["unit"];
    type = purchaselist[widget.index]["type"];
    code = purchaselist[widget.index]["code"];
    itemname.text = purchaselist[widget.index]["itemName"].toString();
    itemQuantity.text = purchaselist[widget.index]["quantity"].toString();
    itemRate.text =
        double.parse(purchaselist[widget.index]["rate"].toString()).toString();
    itemDiscount.text = purchaselist[widget.index]["discount"].toString();
    itemTax.text =
        Provider.of<PurchaseData>(context, listen: false).gsttype == ""
            ? "Non Taxable"
            : "";
    gstdropdownvalue = purchaselist[widget.index]["tax"].toString();
    igstdropdownvalue = purchaselist[widget.index]["tax"].toString();
    itemAmount.text =
        Provider.of<PurchaseData>(context, listen: false).gsttype == ""
            ? purchaselist[widget.index]["amount"].toString()
            : double.parse(purchaselist[widget.index]["amount"].toString())
                .toString();
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.symmetric(
        inside: const BorderSide(
            width: 0.5, color: Colors.grey, style: BorderStyle.solid),
      ),
      columnWidths: const {
        0: FlexColumnWidth(0.15),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(0.42),
        3: FlexColumnWidth(0.42),
        4: FlexColumnWidth(0.42),
        5: FlexColumnWidth(0.42),
        6: FlexColumnWidth(0.42),
      },
      children: [
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              (widget.index + 1).toString(),
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text(itemname.text),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                code == "null"
                    ? Text("$type (HSN: -)")
                    : type == "Goods"
                        ? Text("$type (HSN: $code)")
                        : Text("$type (SAC: $code)"),
                TextFormField(
                  maxLines: 3,
                  onChanged: (value) {
                    var purchaselist =
                        Provider.of<PurchaseData>(context, listen: false)
                            .purchaseList;
                    purchaselist[widget.index]["description"] = value;
                  },
                  decoration: const InputDecoration(
                      hintText: "Description", border: InputBorder.none),
                )
              ],
            ),
            trailing: InkWell(
                onTap: () {
                  widget.onDelete(widget.purchaseValue);
                  Provider.of<PurchaseData>(context, listen: false).gst(
                      Provider.of<PurchaseData>(context, listen: false)
                          .purchaseList);
                  Provider.of<PurchaseData>(context, listen: false).igst(
                      Provider.of<PurchaseData>(context, listen: false)
                          .purchaseList);
                },
                child: const Icon(Icons.close)),
          ),
          TextFormField(
            controller: itemQuantity,
            textDirection: TextDirection.rtl,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: false),
            decoration: InputDecoration(
                border: InputBorder.none,
                suffix: unit == "null" ? Text("") : Text(unit),
                contentPadding: const EdgeInsets.all(
                  10,
                )),
            onChanged: (value) {
              var purchaselist =
                  Provider.of<PurchaseData>(context, listen: false)
                      .purchaseList;
              if (value.isNotEmpty) {
                purchaselist[widget.index]["quantity"] = double.parse(value);
                purchaselist[widget.index]["amount"] = calculation(
                  double.parse(value),
                  double.parse(purchaselist[widget.index]["rate"].toString()),
                  double.parse(
                      purchaselist[widget.index]["discount"].toString()),
                );
                itemAmount.text = calculation(
                  double.parse(value),
                  double.parse(purchaselist[widget.index]["rate"].toString()),
                  double.parse(
                      purchaselist[widget.index]["discount"].toString()),
                );

                widget.onUpdate(purchaselist, widget.index);
              }
            },
          ),
          TextFormField(
            controller: itemRate,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(
                  10,
                )),
            onChanged: (value) {
              var purchaselist =
                  Provider.of<PurchaseData>(context, listen: false)
                      .purchaseList;
              if (value.isNotEmpty) {
                purchaselist[widget.index]["rate"] =
                    (double.parse(value)).toString();
                purchaselist[widget.index]["amount"] = calculation(
                  double.parse(
                      purchaselist[widget.index]["quantity"].toString()),
                  double.parse(value),
                  double.parse(
                      purchaselist[widget.index]["discount"].toString()),
                );
                itemAmount.text = calculation(
                  double.parse(
                      purchaselist[widget.index]["quantity"].toString()),
                  double.parse(value),
                  double.parse(
                      purchaselist[widget.index]["discount"].toString()),
                );

                widget.onUpdate(purchaselist, widget.index);
              }
            },
          ),
          TextFormField(
            textDirection: TextDirection.rtl,
            controller: itemDiscount,
            decoration: const InputDecoration(
                border: InputBorder.none,
                suffix: Text("%"),
                contentPadding: EdgeInsets.all(
                  10,
                )),
            onChanged: (value) {
              var purchaselist =
                  Provider.of<PurchaseData>(context, listen: false)
                      .purchaseList;
              if (value.isNotEmpty) {
                purchaselist[widget.index]["discount"] =
                    (double.parse(value)).toString();
                purchaselist[widget.index]["amount"] = calculation(
                  double.parse(
                      purchaselist[widget.index]["quantity"].toString()),
                  double.parse(purchaselist[widget.index]["rate"].toString()),
                  double.parse(value),
                );
                itemAmount.text = calculation(
                  double.parse(
                      purchaselist[widget.index]["quantity"].toString()),
                  double.parse(purchaselist[widget.index]["rate"].toString()),
                  double.parse(value),
                );

                widget.onUpdate(purchaselist, widget.index);
              }
            },
          ),
          Provider.of<PurchaseData>(context, listen: false).gsttype != ""
              ? Provider.of<PurchaseData>(context, listen: false).gsttype ==
                      "GST"
                  ? gstdropdown()
                  : igstdropdown()
              : TextFormField(
                  enabled: false,
                  textDirection: TextDirection.rtl,
                  controller: itemTax,
                  decoration: InputDecoration(
                      prefix: Text(
                          Provider.of<PurchaseData>(context, listen: false)
                              .gsttype),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(
                        10,
                      )),
                ),
          TextFormField(
            controller: itemAmount,
            textDirection: TextDirection.rtl,
            enabled: false,
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(
                  10,
                )),
          ),
        ])
      ],
    );
  }

  gstdropdown() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          // Initial Value
          value: gstdropdownvalue,
          buttonStyleData: const ButtonStyleData(
            //height: 25  ,
            width: 180,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 250,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),

          items: ["0", "5", "12", "18", "28"].map((items) {
            return DropdownMenuItem(
              value: items,
              child: Text("GST$items [$items%]"),
            );
          }).toList(),

          onChanged: (String? newValue) {
            setState(() {
              gstdropdownvalue = newValue!;
            });
            var purchaselist =
                Provider.of<PurchaseData>(context, listen: false).purchaseList;

            purchaselist[widget.index]["tax"] = newValue;
            print(purchaselist);
            Provider.of<PurchaseData>(context, listen: false).cleargst();
            Provider.of<PurchaseData>(context, listen: false).gst(purchaselist);
            Provider.of<PurchaseData>(context, listen: false).updateTotal(
                Provider.of<PurchaseData>(context, listen: false).subtotal,
                Provider.of<PurchaseData>(context, listen: false).gsttotal,
                Provider.of<PurchaseData>(context, listen: false)
                    .shippingcharge,
                Provider.of<PurchaseData>(context, listen: false).taxtype);
          },
        ),
      ),
    );
  }

  igstdropdown() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          // Initial Value
          value: igstdropdownvalue,
          isExpanded: true,
          items: ["0", "5", "12", "18", "28"].map((items) {
            return DropdownMenuItem(
              value: items,
              child: Text("IGST$items [$items%]"),
            );
          }).toList(),

          onChanged: (String? newValue) {
            var purchaselist =
                Provider.of<PurchaseData>(context, listen: false).purchaseList;

            purchaselist[widget.index]["tax"] = newValue;
            print(purchaselist);
            Provider.of<PurchaseData>(context, listen: false).cleargst();
            Provider.of<PurchaseData>(context, listen: false)
                .igst(purchaselist);
            Provider.of<PurchaseData>(context, listen: false).updateTotal(
                Provider.of<PurchaseData>(context, listen: false).subtotal,
                Provider.of<PurchaseData>(context, listen: false).gsttotal,
                Provider.of<PurchaseData>(context, listen: false)
                    .shippingcharge,
                Provider.of<PurchaseData>(context, listen: false).taxtype);

            setState(() {
              igstdropdownvalue = newValue!;
            });
          },
        ),
      ),
    );
  }

  String calculation(double quantity, double rate, double discount) {
    double percentage = rate * (discount / 100);
    double discounttotal = rate - percentage;
    double total = quantity * discounttotal;

    return total.toStringAsFixed(2);
  }
}
