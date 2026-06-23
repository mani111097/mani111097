import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddExpenses extends StatefulWidget {
  final Function update;
  const AddExpenses({required this.update, Key? key}) : super(key: key);

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String? expenseType;
  String? supplystate;
  String? expCatagory;
  int type = 0;
  List expenseList = [];

  TextEditingController date = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  TextEditingController companyName = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController expId = TextEditingController();
  TextEditingController name = TextEditingController();
  Map json = {};

  idupdate() async {
    int expenseId = await getPaymentId();

    expId.text = expenseId.toString();

    FirebaseFirestore.instance
        .collection("local")
        .doc("local")
        .update({"paymentinId": expenseId});
  }

  @override
  void initState() {
    idupdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
            child: Form(
          //key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              ListTile(
                dense: true,
                title: const Text(
                  "New Expense",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: GestureDetector(
                    onTap: () {
                      widget.update("cancel");
                      context.go('/home/expenses');
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
                        child: Text("Date"),
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
                        child: Text("Expense No"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 35,
                          child: TextFormField(
                            controller: expId,
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
                        child: Text("Expense Type"),
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
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text("Expense Category"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 35,
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: expenseCatagory(),
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text("Vendor"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 35,
                          child: TextFormField(
                            //controller: date,
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
                        child: Text("State of Supply"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 35,
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: supplydropdown(),
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text("Paid Through"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 35,
                          child: TextFormField(
                            //controller: date,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.only(left: 10)),
                          ),
                        ),
                      )
                    ],
                  ),
                ]),
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
                        0: FlexColumnWidth(0.8),
                        1: FlexColumnWidth(0.42),
                        2: FlexColumnWidth(0.42),
                        3: FlexColumnWidth(0.42),
                      },
                      children: const [
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Items",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Note",
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
                    ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                              height: 0,
                            ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: expenseList.length,
                        itemBuilder: ((context, index) {}))
                  ],
                ),
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
        .then((value) => itemId = value['expenseId']);
    print(itemId + 1);

    return itemId + 1;
  }

  supplydropdown() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButton2<String>(
        isDense: true,
        hint: const Text("Select"),
        value: supplystate,
        buttonStyleData: ButtonStyleData(
          height: 40,
          width: MediaQuery.of(context).size.height * 0.8,
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
        },
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
            name.clear();
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

  expenseCatagory() {
    return Theme(
        data: Theme.of(context).copyWith(focusColor: Colors.transparent),
        child: DropdownButton2<String>(
          isDense: true,
          hint: const Text("Select"),
          value: expCatagory,
          buttonStyleData: ButtonStyleData(
            height: 40,
            width: MediaQuery.of(context).size.height * 0.8,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          onChanged: (String? newValue) {
            setState(() {
              expCatagory = newValue!;
            });
          },
          items: const [
            'Wages & Salary',
            'Rent',
            'Advance',
            'Commission',
            'Legal Charges',
            'Interest Payments',
            'Advance tax',
            'Advertisements and Marketing',
            'Business Travel Expenses',
            'License Fees',
            'Utility Expenses',
            'Bad debts',
            'Contributions Towards Charity',
            'Insurance',
            'Bank Charges',
            'Fuel or power consumption',
            'Carriage',
            'Manufacture Expenses',
            'Material Cost',
            'Printing & Stationery ',
            'Travelling Expenses',
            'Repairs & Renewals',
            'Telephone/Internet Expenses',
            'Other'
          ].map((items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
        ));
  }
}
