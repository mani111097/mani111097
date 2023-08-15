import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rasitu_login/module/customerNames.dart';

class PaymentInpopup extends StatefulWidget {
  const PaymentInpopup({Key? key}) : super(key: key);

  @override
  State<PaymentInpopup> createState() => _PaymentInpopupState();
}

class _PaymentInpopupState extends State<PaymentInpopup> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String? paymentType;

  TextEditingController date = TextEditingController(
      text: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()));

  TextEditingController companyName = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController paymentId = TextEditingController();
  Map json = {};

  @override
  void initState() {
    idupdate();
    super.initState();
  }

  idupdate() async {
    int paymentinId = await getPaymentId();
    print(paymentinId);
    paymentId.text = paymentinId.toString();

    FirebaseFirestore.instance
        .collection("local")
        .doc("local")
        .update({"paymentinId": paymentinId});
  }

  @override
  Widget build(BuildContext context) {
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
              height: 35,
              width: 100,
              child: TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Do you want to leave the page?"),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, "Cancel");
                                context.go('/home/paymentin');
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
            SizedBox(
              height: 35,
              width: 100,
              child: ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> data = {
                    "paymentId": paymentId.text,
                    "paymentDate": date.text,
                    "amount": amount.text,
                    "paymentType": paymentType,
                    "description": desc.text,
                    "customerId": json['customerId'],
                    "customerName": json['customerName'],
                    "status": "Received",
                    "uid": json['uid'],
                    "billingAddress": json['billingAddress'],
                    "shippingAddress": json['shippingAddress']
                  };
                  FirebaseFirestore.instance
                      .collection("PaymentIn")
                      .doc(paymentId.text)
                      .set(data);
                  context.go('/home/paymentin');
                },
                child: Text("Save"),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
            child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              ListTile(
                dense: true,
                title: const Text(
                  "New Payment",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: GestureDetector(
                    onTap: () {
                      context.go('/home/paymentin');
                    },
                    child: const Icon(Icons.close)),
              ),
              const Divider(),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.8,
                child: Table(columnWidths: const {
                  0: FlexColumnWidth(0.4),
                }, children: [
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text("Customer Name"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 35,
                                child: TypeAheadField<CustomerName?>(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller: companyName,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding:
                                              EdgeInsets.only(left: 10)),
                                    ),
                                    suggestionsCallback:
                                        CustomerApi.getCustomerSuggestions,
                                    itemBuilder:
                                        (context, CustomerName? suggestion) {
                                      final user = suggestion;

                                      return ListTile(
                                        title: Text(user!.name),
                                      );
                                    },
                                    onSuggestionSelected:
                                        (CustomerName? suggestion) {
                                      setState(() {
                                        companyName.text = suggestion!.name;
                                        json = suggestion.json;
                                      });
                                    })),
                            json.isNotEmpty
                                ? Text("Balance: ${json['ropAmount']}")
                                : SizedBox()
                          ],
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text("Payment No"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 35,
                          child: TextFormField(
                            controller: paymentId,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.only(left: 10)),
                          ),
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text("Payment Date"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 35,
                          child: TextFormField(
                            controller: date,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.only(left: 10)),
                          ),
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text("Amount"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 35,
                          child: TextFormField(
                            controller: amount,
                            decoration: InputDecoration(
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
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(left: 15)),
                          ),
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text("Payment Mode"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 35,
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: paymentTypeDropdown(),
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text("Description"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: desc,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                ]),
              ),
            ],
          ),
        )),
      ),
    );
  }

  getPaymentId() async {
    int itemId = 0;

    await FirebaseFirestore.instance
        .collection("local")
        .doc("local")
        .get()
        .then((value) => itemId = value['paymentinId']);
    print(itemId + 1);

    return itemId + 1;
  }

  paymentTypeDropdown() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButton2(
        isDense: true,
        hint: const Text("Select payment Mode"),
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
}
