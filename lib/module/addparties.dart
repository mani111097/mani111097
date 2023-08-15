import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:rasitu_login/main.dart';
import 'package:http/http.dart' as http;
import 'package:rasitu_login/module/sharedpreference.dart';

class Addparties extends StatefulWidget {
  bool edit;
  Map customerDetails = {};
  Addparties(this.edit, this.customerDetails);

  @override
  State<Addparties> createState() => _AddpartiesState();
}

class _AddpartiesState extends State<Addparties> {
  String partiestype = "Customer";
  TextEditingController posSearch = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController companyname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gstin = TextEditingController();
  TextEditingController billstreet = TextEditingController();
  TextEditingController billarea = TextEditingController();
  TextEditingController billcity = TextEditingController();
  TextEditingController billstate = TextEditingController();
  TextEditingController billzipcode = TextEditingController();
  TextEditingController billPhone = TextEditingController();
  TextEditingController billemail = TextEditingController();
  TextEditingController shipstreet = TextEditingController();
  TextEditingController shiparea = TextEditingController();
  TextEditingController shipcity = TextEditingController();
  TextEditingController shipstate = TextEditingController();
  TextEditingController shipzipcode = TextEditingController();
  TextEditingController shipPhone = TextEditingController();
  TextEditingController shipemail = TextEditingController();
  TextEditingController toPay = TextEditingController();
  TextEditingController toReceive = TextEditingController();

  int type = 0;
  String? placeofsupply;
  String? gsttype;
  bool validator = false;
  String id = "";

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final PrefService _prefService = PrefService();

  void initState() {
    if (widget.edit) {
      setState(() {
        type = widget.customerDetails["type"] == "Business" ? 0 : 1;
        firstname.text = widget.customerDetails["firstName"];
        lastname.text = widget.customerDetails["lastName"];
        companyname.text = widget.customerDetails["companyName"];
        phone.text = widget.customerDetails["phone"];
        email.text = widget.customerDetails["email"];
        gsttype = widget.customerDetails["gstType"];
        placeofsupply = widget.customerDetails["pos"];
        gstin.text = widget.customerDetails["gstIN"];
        billstreet.text =
            widget.customerDetails["billingAddress"]["billStreet"];
        billarea.text = widget.customerDetails["billingAddress"]["billArea"];
        billcity.text = widget.customerDetails["billingAddress"]["billCity"];
        billstate.text = widget.customerDetails["billingAddress"]["billState"];
        billzipcode.text =
            widget.customerDetails["billingAddress"]["billZipcode"];
        billPhone.text = widget.customerDetails["billingAddress"]["billPhone"];
        billemail.text = widget.customerDetails["billingAddress"]["billEmail"];
        shipstreet.text =
            widget.customerDetails["shippingAddress"]["shipStreet"];
        shiparea.text = widget.customerDetails["shippingAddress"]["shipArea"];
        shipcity.text = widget.customerDetails["shippingAddress"]["shipCity"];
        shipstate.text = widget.customerDetails["shippingAddress"]["shipState"];
        shipzipcode.text =
            widget.customerDetails["shippingAddress"]["shipZipcode"];
        shipPhone.text = widget.customerDetails["shippingAddress"]["shipPhone"];
        shipemail.text = widget.customerDetails["shippingAddress"]["shipEmail"];
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  ListTile(
                    dense: true,
                    title: const Text(
                      "New Customer",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close)),
                  ),
                  const Divider(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(0.2),
                        1: FlexColumnWidth(0.4),
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
                                  const Text("Business"),
                                  MediaQuery.of(context).size.width > 850
                                      ? const SizedBox(
                                          width: 50,
                                        )
                                      : const SizedBox(),
                                  Radio(
                                      value: 1,
                                      groupValue: type,
                                      onChanged: ((value) {
                                        setState(() {
                                          type = 1;
                                        });
                                      })),
                                  const Text("Individual")
                                ],
                              )),
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text("Primary Contact"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: TextFormField(
                                      controller: firstname,
                                      decoration: const InputDecoration(
                                          hintText: "First Name",
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(10)),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "First Name cant be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: lastname,
                                    decoration: const InputDecoration(
                                        hintText: "Last Name",
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(10)),
                                    validator: (value) {
                                      if (gsttype == null &&
                                          placeofsupply == null) {
                                        setState(() {
                                          validator = true;
                                        });
                                      } else {
                                        setState(() {
                                          validator = false;
                                        });
                                      }
                                      if (value!.isEmpty) {
                                        return "Second Name cant be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text("Company Name"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: companyname,
                              decoration: const InputDecoration(
                                  hintText: "Company Name",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Company Name cant be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text("Customer Email"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: email,
                              decoration: const InputDecoration(
                                  hintText: "Customer Email",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email cant be empty";
                                } else {
                                  if (value.contains("@") &&
                                      value.contains(".com")) {
                                    return null;
                                  } else {
                                    return "Invalid Email Id";
                                  }
                                }
                              },
                            ),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text("Customer Phone"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: phone,
                              maxLength: 10,
                              // buildCounter: (BuildContext context, {int currentLength,bool isFocused,int maxLength}) => "null",
                              decoration: const InputDecoration(
                                  hintText: "Customer Phone",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  counterText: "",
                                  contentPadding: EdgeInsets.all(10)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email cant be empty";
                                } else {
                                  if (value.length < 10) {
                                    return "Invalid phone number";
                                  } else {
                                    return null;
                                  }
                                }
                              },
                            ),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text("GST Type"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: validator
                                            ? gsttype == null
                                                ? Colors.redAccent
                                                : Colors.grey
                                            : Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: gsttypedropdown()),
                          )
                        ]),
                        gsttype == "Registered business"
                            ? TableRow(children: [
                                const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text("GSTIN/UIN"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    controller: gstin,
                                    decoration: const InputDecoration(
                                        hintText: "GSTIN/UIN",
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(10)),
                                    validator: (value) {
                                      if (gsttype == "Registered business") {
                                        return value!.isEmpty
                                            ? "GSTIN/UIN cant be empty"
                                            : null;
                                      }
                                    },
                                  ),
                                )
                              ])
                            : const TableRow(
                                children: [SizedBox(), SizedBox()]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text("Place of Supply"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: validator
                                            ? placeofsupply == null
                                                ? Colors.redAccent
                                                : Colors.grey
                                            : Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: supplydropdown()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text("To Pay"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: toPay,
                              decoration: const InputDecoration(
                                  hintText: "if any",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10)),
                            ),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text("To Receive"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: toReceive,
                              decoration: const InputDecoration(
                                  hintText: "if any",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10)),
                            ),
                          )
                        ])
                      ],
                    ),
                  ),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(0.2),
                      1: FlexColumnWidth(0.4),
                      2: FlexColumnWidth(0.2),
                      3: FlexColumnWidth(0.4),
                    },
                    children: [
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text(
                            "Billing Address",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(""),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 18.0, bottom: 18, left: 15),
                          child: Text(
                            "Shipping Address",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextButton(
                              onPressed: () {
                                shipstreet.text = billstreet.text;
                                shiparea.text = billarea.text;
                                shipcity.text = billcity.text;
                                shipstate.text = billstate.text;
                                shipzipcode.text = billzipcode.text;
                                shipPhone.text = billPhone.text;
                                shipemail.text = billemail.text;
                              },
                              child: const Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text("Copy Billing Address"))),
                        )
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("House No & Street"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: billstreet,
                            maxLines: 3,
                            decoration: const InputDecoration(
                                hintText: "House No & Street",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "HouseNo/Street name is required"
                                  : null;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("House No & Street"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: shipstreet,
                            maxLines: 3,
                            decoration: const InputDecoration(
                                hintText: "House No & Street",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "HouseNo/Street name is required"
                                  : null;
                            },
                          ),
                        )
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("Area"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: billarea,
                            decoration: const InputDecoration(
                                hintText: "Area",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Area name is required"
                                  : null;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("Area"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: shiparea,
                            decoration: const InputDecoration(
                                hintText: "Area",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Area name is required"
                                  : null;
                            },
                          ),
                        )
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("City"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: billcity,
                            decoration: const InputDecoration(
                                hintText: "City",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "City name is required"
                                  : null;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("City"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: shipcity,
                            decoration: const InputDecoration(
                                hintText: "City",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "City name is required"
                                  : null;
                            },
                          ),
                        )
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("State"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: billstate,
                            decoration: const InputDecoration(
                                hintText: "State",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "State is required"
                                  : null;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("State"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: shipstate,
                            decoration: const InputDecoration(
                                hintText: "State",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "State is required"
                                  : null;
                            },
                          ),
                        )
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("Zipcode"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: billzipcode,
                            decoration: const InputDecoration(
                                hintText: "Zipcode",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Zip name is required"
                                  : null;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("Zipcode"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: shipzipcode,
                            decoration: const InputDecoration(
                                hintText: "Zipcode",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Zip name is required"
                                  : null;
                            },
                          ),
                        )
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("Phone"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: billPhone,
                            decoration: const InputDecoration(
                                hintText: "Phone",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Phone is required"
                                  : null;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("Phone"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: shipPhone,
                            decoration: const InputDecoration(
                                hintText: "Phone",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Phone is required"
                                  : null;
                            },
                          ),
                        )
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("Email"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: billemail,
                            decoration: const InputDecoration(
                                hintText: "Email",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Email is required"
                                  : null;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text("Email"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: shipemail,
                            decoration: const InputDecoration(
                                hintText: "Email",
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Email is required"
                                  : null;
                            },
                          ),
                        )
                      ]),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, "cancel");
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.blue),
                                  ))),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                              height: 35,
                              width: 90,
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
                                      if (widget.edit) {
                                        if (gsttype != null &&
                                            placeofsupply != null) {
                                          setState(() {
                                            validator = false;
                                          });
                                          Map<String, dynamic> body = {
                                            "uid": id,
                                            "customerId": widget
                                                .customerDetails["CustomerId"],
                                            'type': type == 0
                                                ? "Business"
                                                : "Individual",
                                            'firstName': firstname.text,
                                            'lastName': lastname.text,
                                            'companyName': companyname.text,
                                            'email': email.text,
                                            'phone': phone.text,
                                            'gstType': gsttype,
                                            'gstIN': gstin.text.isNotEmpty
                                                ? gstin.text
                                                : "",
                                            'pos': placeofsupply,
                                            'rop': toReceive.text.isNotEmpty
                                                ? toReceive.text
                                                : "",
                                            'ropAmount': toPay.text.isNotEmpty
                                                ? toPay.text
                                                : "0",
                                            'billingAddress': {
                                              'billStreet': billstreet.text,
                                              'billArea': billarea.text,
                                              'billCity': billcity.text,
                                              'billState': billstate.text,
                                              'billZipcode': billzipcode.text,
                                              'billPhone': billPhone.text,
                                              'billEmail': billemail.text,
                                            },
                                            'shippingAddress': {
                                              'shipStreet': shipstreet.text,
                                              'shipArea': shiparea.text,
                                              'shipCity': shipcity.text,
                                              'shipState': shipstate.text,
                                              'shipZipcode': shipzipcode.text,
                                              'shipPhone': shipPhone.text,
                                              'shipEmail': shipemail.text,
                                            }
                                          };

                                          print(body);

                                          try {
                                            FirebaseFirestore.instance
                                                .collection('Customers')
                                                .doc(widget.customerDetails[
                                                        "CustomerId"]
                                                    .toString())
                                                .update(body)
                                                .whenComplete(() {
                                              Navigator.pop(context, "Added");
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
                                        } else {
                                          setState(() {
                                            validator = true;
                                          });
                                        }
                                      } else {
                                        if (gsttype != null &&
                                            placeofsupply != null) {
                                          setState(() {
                                            validator = false;
                                          });

                                          int customerId =
                                              await getCustomerId() + 1;

                                          Map<String, dynamic> body = {
                                            "uid": id,
                                            "customerId": customerId.toString(),
                                            'type': type == 0
                                                ? "Business"
                                                : "Individual",
                                            'firstName': firstname.text,
                                            'lastName': lastname.text,
                                            'companyName': companyname.text,
                                            'email': email.text,
                                            'phone': phone.text,
                                            'gstType': gsttype,
                                            'gstIN': gstin.text.isNotEmpty
                                                ? gstin.text
                                                : "",
                                            'pos': placeofsupply,
                                            'rop': toReceive.text.isNotEmpty
                                                ? toReceive.text
                                                : "",
                                            'ropAmount': toPay.text.isNotEmpty
                                                ? toPay.text
                                                : "0",
                                            'billingAddress': {
                                              'billStreet': billstreet.text,
                                              'billArea': billarea.text,
                                              'billCity': billcity.text,
                                              'billState': billstate.text,
                                              'billZipcode': billzipcode.text,
                                              'billPhone': billPhone.text,
                                              'billEmail': billemail.text,
                                            },
                                            'shippingAddress': {
                                              'shipStreet': shipstreet.text,
                                              'shipArea': shiparea.text,
                                              'shipCity': shipcity.text,
                                              'shipState': shipstate.text,
                                              'shipZipcode': shipzipcode.text,
                                              'shipPhone': shipPhone.text,
                                              'shipEmail': shipemail.text,
                                            }
                                          };

                                          try {
                                            FirebaseFirestore.instance
                                                .collection('Customers')
                                                .doc(customerId.toString())
                                                .set(body)
                                                .whenComplete(() {
                                              FirebaseFirestore.instance
                                                  .collection("local")
                                                  .doc("local")
                                                  .update({
                                                "customerId": customerId
                                              });
                                              Navigator.pop(context, "Added");
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
                                        } else {
                                          setState(() {
                                            validator = true;
                                          });
                                        }
                                      }
                                    }
                                  },
                                  child: Text(
                                    widget.edit ? "Update" : "Save",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                        ],
                      ))
                ],
              ),
            ),
          )),
    );
  }

  gsttypedropdown() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isDense: true,
          hint: const Text("Select"),
          value: gsttype,
          icon: const Icon(Icons.keyboard_arrow_down),

          // Array list of items
          items: ["Unregistered/Consumer", "Registered business"]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),

          onChanged: (String? newValue) {
            setState(() {
              gsttype = newValue;
            });
          },
        ),
      ),
    );
  }

  supplydropdown() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isDense: true,
          hint: const Text("Select"),
          value: placeofsupply,
          onChanged: (String? newValue) {
            setState(() {
              placeofsupply = newValue!;
            });
          },
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
          dropdownSearchData: DropdownSearchData(
            searchController: posSearch,
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
                controller: posSearch,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return (item.value!
                  .toLowerCase()
                  .toString()
                  .contains(searchValue.toLowerCase()));
            },
          ),
          //This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              posSearch.clear();
            }
          },
        ),
      ),
    );
  }

  getCustomerId() async {
    int customerId = 0;

    await FirebaseFirestore.instance
        .collection("local")
        .doc("local")
        .get()
        .then((value) => customerId = value['shippingId']);

    return (customerId + 1);
  }
}
