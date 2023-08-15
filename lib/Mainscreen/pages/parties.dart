import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rasitu_login/Mainscreen/constants/topbottom.dart';
import 'package:rasitu_login/module/addparties.dart';
import 'package:rasitu_login/module/sharedpreference.dart';
import '../../main.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class Party extends StatefulWidget {
  String id;
  String page;
  Party({this.id = "", this.page = "", Key? key}) : super(key: key);

  @override
  State<Party> createState() => _PartyState();
}

class _PartyState extends State<Party> {
  bool addparties = false;
  bool addpartiestype = false;
  bool noparties = false;
  bool partiesSelection = false;
  bool itemSelection = false;
  List partyjsonList = [];
  List partyId = [];
  int partyIndex = 0;
  int selection = 0;
  bool nodata = false;
  //late TabController _tabController;
  final PrefService _prefService = PrefService();

  getData() async {
    try {
      String id = await _prefService.readId().then((value) => value);
      await FirebaseFirestore.instance
          .collection('Customers')
          .where('uid', isEqualTo: id)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.forEach((element) {
            setState(() {
              partyjsonList.add(element.data());
              partyId.add(element.data()['customerId']);
            });
          });
        }
      });
    } on Exception catch (e) {
      print("Exception returns ${e.toString()}");
    } catch (e) {
      print("Exception returns ${e.toString()}");
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
    partyIndex = widget.page == "customer"
        ? widget.id.isNotEmpty
            ? partyId.indexOf(widget.id)
            : 0
        : 0;
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          partyjsonList.isNotEmpty
              ? "Phone: ${partyjsonList[partyIndex]["phone"]}"
              : "",
          style: const TextStyle(fontSize: 15),
        ),
        Text(
          partyjsonList.isNotEmpty
              ? "Email: ${partyjsonList[partyIndex]["email"]}"
              : "",
          style: const TextStyle(fontSize: 15),
        ),
        Text(
          partyjsonList.isNotEmpty
              ? "GST Type: ${partyjsonList[partyIndex]["gstType"]}"
              : "",
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
    return Scaffold(
      body: nodata
          ? noData()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      !itemSelection
                          ? Container(
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
                                        color: Color.fromARGB(
                                            255, 218, 218, 218))),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                      title: Text(
                                        "Customer",
                                        style: TextStyle(
                                            color: maincolor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: SizedBox(
                                        width: 90,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: maincolor),
                                          onPressed: () async {
                                            print(MediaQuery.of(context)
                                                .size
                                                .width);
                                            if (MediaQuery.of(context)
                                                    .size
                                                    .width >
                                                850) {
                                              print("called popup");
                                              var res = await showDialog(
                                                  context: context,
                                                  builder: (builder) =>
                                                      Addparties(false, {}));
                                              if (res == "Added") {
                                                getData();
                                              }
                                            } else {
                                              var res = await Addparties(
                                                  false, const {});
                                            }
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
                                      "Customer",
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
                                  // const Divider(),
                                  Expanded(
                                      child: partyjsonList.isNotEmpty
                                          ? ListView.builder(
                                              itemCount: partyjsonList.length,
                                              itemBuilder: ((context, i) {
                                                return InkWell(
                                                    onTap: () {
                                                      if (MediaQuery.of(context)
                                                              .size
                                                              .width <
                                                          850) {
                                                        setState(() {
                                                          partyIndex = i;
                                                          itemSelection = true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          partyIndex = i;
                                                        });
                                                      }
                                                      context.go(
                                                          '/home/customer/${partyjsonList[partyIndex]["customerId"]}');
                                                    },
                                                    child: ListTile(
                                                      dense: true,
                                                      visualDensity:
                                                          const VisualDensity(
                                                              vertical: -3),
                                                      title: Text(
                                                          partyjsonList[i]
                                                              ["companyName"]),
                                                      trailing: Text(
                                                          partyjsonList[i]
                                                              ["type"]),
                                                    ));
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
                            )
                          : SizedBox(),

                      //Detail Container
                      MediaQuery.of(context).size.width > 650
                          ? Expanded(
                              child: SingleChildScrollView(
                              padding:
                                  const EdgeInsets.only(right: 15.0, left: 15),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                        title: partyjsonList.isNotEmpty
                                            ? Text(
                                                "${partyjsonList[partyIndex]["companyName"]}"
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              )
                                            : Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                    Colors.grey.shade200,
                                                child: Container(
                                                  height: 10,
                                                  width: 150,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        subtitle: partyjsonList.isNotEmpty
                                            ? Text(
                                                "${partyjsonList[partyIndex]["firstName"]} ${partyjsonList[partyIndex]["lastName"]}",
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              )
                                            : Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                    Colors.grey.shade200,
                                                child: Container(
                                                  height: 10,
                                                  width: 150,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        trailing: SizedBox(
                                            width: 90,
                                            child: Row(children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    var res = await showDialog(
                                                        context: context,
                                                        builder: (builder) =>
                                                            Addparties(
                                                                true,
                                                                partyjsonList[
                                                                    partyIndex]));
                                                    if (res == "Added") {
                                                      getData();
                                                    }
                                                  },
                                                  icon: const Icon(Icons.edit)),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (builder) => Dialog(
                                                                  child:
                                                                      Container(
                                                                    height: 300,
                                                                    width: 300,
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            15),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        const SizedBox(
                                                                          height:
                                                                              25,
                                                                        ),
                                                                        Container(
                                                                          padding:
                                                                              const EdgeInsets.all(15),
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all(color: Colors.red)),
                                                                          child:
                                                                              const Icon(
                                                                            Icons.close,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                35,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              25,
                                                                        ),
                                                                        const Text(
                                                                          "Are you sure?",
                                                                          style:
                                                                              TextStyle(fontSize: 20),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        const Text(
                                                                          "Do you really want to delete these record? This process cannot be undone.",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            ElevatedButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context, "cancel");
                                                                                },
                                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                                                                                child: const Padding(
                                                                                  padding: EdgeInsets.all(10.0),
                                                                                  child: Text(
                                                                                    "Cancel",
                                                                                    // style: TextStyle(
                                                                                    //     color:
                                                                                    //         Colors.white),
                                                                                  ),
                                                                                )),
                                                                            ElevatedButton(
                                                                                onPressed: () async {},
                                                                                child: const Padding(
                                                                                  padding: EdgeInsets.all(10.0),
                                                                                  child: Text(
                                                                                    "Delete",
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ))
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ));
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete))
                                            ]))),
                                    // : const SizedBox(),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selection = 0;
                                              });
                                            },
                                            child: Text(
                                              "Overview",
                                              style: selection == 0
                                                  ? const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 65, 125, 255),
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : const TextStyle(),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selection = 1;
                                              });
                                            },
                                            child: Text(
                                              "Transaction",
                                              style: selection == 1
                                                  ? const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 65, 125, 255),
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : const TextStyle(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    selection == 0
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15.0, left: 15),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      partyjsonList.isNotEmpty
                                                          ? Text(
                                                              "Primary Contacts"
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            )
                                                          : Shimmer.fromColors(
                                                              baseColor: Colors
                                                                  .grey
                                                                  .shade300,
                                                              highlightColor:
                                                                  Colors.grey
                                                                      .shade200,
                                                              child: Container(
                                                                height: 10,
                                                                width: 150,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                          child: Divider()),
                                                      partyjsonList.isNotEmpty
                                                          ? Text(
                                                              "Name: ${partyjsonList[partyIndex]["firstName"]} ${partyjsonList[partyIndex]["lastName"]}",
                                                            )
                                                          : Shimmer.fromColors(
                                                              baseColor: Colors
                                                                  .grey
                                                                  .shade300,
                                                              highlightColor:
                                                                  Colors.grey
                                                                      .shade200,
                                                              child: Container(
                                                                height: 10,
                                                                width: 150,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      partyjsonList.isNotEmpty
                                                          ? Text(
                                                              "Phone: ${partyjsonList[partyIndex]["phone"]}",
                                                            )
                                                          : Shimmer.fromColors(
                                                              baseColor: Colors
                                                                  .grey
                                                                  .shade300,
                                                              highlightColor:
                                                                  Colors.grey
                                                                      .shade200,
                                                              child: Container(
                                                                height: 10,
                                                                width: 150,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      partyjsonList.isNotEmpty
                                                          ? Text(
                                                              "Email: ${partyjsonList[partyIndex]["email"]}",
                                                            )
                                                          : Shimmer.fromColors(
                                                              baseColor: Colors
                                                                  .grey
                                                                  .shade300,
                                                              highlightColor:
                                                                  Colors.grey
                                                                      .shade200,
                                                              child: Container(
                                                                height: 10,
                                                                width: 150,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      partyjsonList.isNotEmpty
                                                          ? Text(
                                                              "Address Details"
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            )
                                                          : Shimmer.fromColors(
                                                              baseColor: Colors
                                                                  .grey
                                                                  .shade300,
                                                              highlightColor:
                                                                  Colors.grey
                                                                      .shade200,
                                                              child: Container(
                                                                height: 10,
                                                                width: 150,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                          child: Divider()),
                                                      partyjsonList.isNotEmpty
                                                          ? Text(
                                                              partyjsonList
                                                                      .isNotEmpty
                                                                  ? "Billing Address: \n${partyjsonList[partyIndex]["billingAddress"]["billStreet"]},\n${partyjsonList[partyIndex]["billingAddress"]["billArea"]},\n${partyjsonList[partyIndex]["billingAddress"]["billCity"]}-${partyjsonList[partyIndex]["billingAddress"]["billZipcode"]}"
                                                                  : "Address:",
                                                              softWrap: false,
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
                                                            )
                                                          : Shimmer.fromColors(
                                                              baseColor: Colors
                                                                  .grey
                                                                  .shade300,
                                                              highlightColor:
                                                                  Colors.grey
                                                                      .shade200,
                                                              child: Container(
                                                                height: 40,
                                                                width: 150,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      partyjsonList.isNotEmpty
                                                          ? Text(
                                                              partyjsonList
                                                                      .isNotEmpty
                                                                  ? "Shipping Address: \n${partyjsonList[partyIndex]["shippingAddress"]["shipStreet"]},\n${partyjsonList[partyIndex]["shippingAddress"]["shipArea"]},\n${partyjsonList[partyIndex]["shippingAddress"]["shipCity"]}-${partyjsonList[partyIndex]["shippingAddress"]["shipZipcode"]}"
                                                                  : "Address:",
                                                              softWrap: false,
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
                                                            )
                                                          : Shimmer.fromColors(
                                                              baseColor: Colors
                                                                  .grey
                                                                  .shade300,
                                                              highlightColor:
                                                                  Colors.grey
                                                                      .shade200,
                                                              child: Container(
                                                                height: 40,
                                                                width: 150,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                    ]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15.0, left: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    partyjsonList.isNotEmpty
                                                        ? Text(
                                                            "Other Details"
                                                                .toUpperCase(),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                          )
                                                        : Shimmer.fromColors(
                                                            baseColor: Colors
                                                                .grey.shade300,
                                                            highlightColor:
                                                                Colors.grey
                                                                    .shade200,
                                                            child: Container(
                                                              height: 10,
                                                              width: 150,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                        child: Divider()),
                                                    partyjsonList.isNotEmpty
                                                        ? Text(
                                                            "GST Treatment: ${partyjsonList[partyIndex]["gstType"]}",
                                                          )
                                                        : Shimmer.fromColors(
                                                            baseColor: Colors
                                                                .grey.shade300,
                                                            highlightColor:
                                                                Colors.grey
                                                                    .shade200,
                                                            child: Container(
                                                              height: 10,
                                                              width: 150,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    partyjsonList.isNotEmpty
                                                        ? Text(
                                                            "GSTIN: ${partyjsonList[partyIndex]["gstIN"]}",
                                                          )
                                                        : Shimmer.fromColors(
                                                            baseColor: Colors
                                                                .grey.shade300,
                                                            highlightColor:
                                                                Colors.grey
                                                                    .shade200,
                                                            child: Container(
                                                              height: 10,
                                                              width: 150,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    partyjsonList.isNotEmpty
                                                        ? Text(
                                                            "POS: ${partyjsonList[partyIndex]["pos"]}",
                                                          )
                                                        : Shimmer.fromColors(
                                                            baseColor: Colors
                                                                .grey.shade300,
                                                            highlightColor:
                                                                Colors.grey
                                                                    .shade200,
                                                            child: Container(
                                                              height: 10,
                                                              width: 150,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        : const Text(
                                            "Currently there is no transaction")
                                  ],
                                ),
                              ),
                            ))
                          : itemSelection
                              ? Expanded(
                                  child: SingleChildScrollView(
                                  padding: const EdgeInsets.only(
                                      right: 15.0, left: 15),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  itemSelection = false;
                                                });
                                              },
                                              child: const Text("back")),
                                        ),
                                        ListTile(
                                            title: partyjsonList.isNotEmpty
                                                ? Text(
                                                    "${partyjsonList[partyIndex]["companyName"]}"
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  )
                                                : Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey.shade300,
                                                    highlightColor:
                                                        Colors.grey.shade200,
                                                    child: Container(
                                                      height: 10,
                                                      width: 150,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                            subtitle: partyjsonList.isNotEmpty
                                                ? Text(
                                                    "${partyjsonList[partyIndex]["firstName"]} ${partyjsonList[partyIndex]["lastName"]}",
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  )
                                                : Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey.shade300,
                                                    highlightColor:
                                                        Colors.grey.shade200,
                                                    child: Container(
                                                      height: 10,
                                                      width: 150,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                            trailing: SizedBox(
                                                width: 90,
                                                child: Row(children: [
                                                  IconButton(
                                                      onPressed: () async {
                                                        var res = await showDialog(
                                                            context: context,
                                                            builder: (builder) =>
                                                                Addparties(
                                                                    true,
                                                                    partyjsonList[
                                                                        partyIndex]));
                                                        if (res == "Added") {
                                                          getData();
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit)),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (builder) =>
                                                                    Dialog(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            300,
                                                                        width:
                                                                            300,
                                                                        padding:
                                                                            const EdgeInsets.all(15),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            const SizedBox(
                                                                              height: 25,
                                                                            ),
                                                                            Container(
                                                                              padding: const EdgeInsets.all(15),
                                                                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.red)),
                                                                              child: const Icon(
                                                                                Icons.close,
                                                                                color: Colors.red,
                                                                                size: 35,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 25,
                                                                            ),
                                                                            const Text(
                                                                              "Are you sure?",
                                                                              style: TextStyle(fontSize: 20),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            const Text(
                                                                              "Do you really want to delete these record? This process cannot be undone.",
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                ElevatedButton(
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context, "cancel");
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                                                                                    child: const Padding(
                                                                                      padding: EdgeInsets.all(10.0),
                                                                                      child: Text(
                                                                                        "Cancel",
                                                                                        // style: TextStyle(
                                                                                        //     color:
                                                                                        //         Colors.white),
                                                                                      ),
                                                                                    )),
                                                                                ElevatedButton(
                                                                                    onPressed: () async {},
                                                                                    child: const Padding(
                                                                                      padding: EdgeInsets.all(10.0),
                                                                                      child: Text(
                                                                                        "Delete",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    ))
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ));
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete))
                                                ]))),
                                        // : const SizedBox(),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selection = 0;
                                                  });
                                                },
                                                child: Text(
                                                  "Overview",
                                                  style: selection == 0
                                                      ? const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              65,
                                                              125,
                                                              255),
                                                          fontWeight:
                                                              FontWeight.bold)
                                                      : const TextStyle(),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selection = 1;
                                                  });
                                                },
                                                child: Text(
                                                  "Transaction",
                                                  style: selection == 1
                                                      ? const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              65,
                                                              125,
                                                              255),
                                                          fontWeight:
                                                              FontWeight.bold)
                                                      : const TextStyle(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(),
                                        selection == 0
                                            ? Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15.0,
                                                            left: 15),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          partyjsonList
                                                                  .isNotEmpty
                                                              ? Text(
                                                                  "Primary Contacts"
                                                                      .toUpperCase(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                )
                                                              : Shimmer
                                                                  .fromColors(
                                                                  baseColor: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  highlightColor:
                                                                      Colors
                                                                          .grey
                                                                          .shade200,
                                                                  child:
                                                                      Container(
                                                                    height: 10,
                                                                    width: 150,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                          SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.2,
                                                              child: Divider()),
                                                          partyjsonList
                                                                  .isNotEmpty
                                                              ? Text(
                                                                  "Name: ${partyjsonList[partyIndex]["firstName"]} ${partyjsonList[partyIndex]["lastName"]}",
                                                                )
                                                              : Shimmer
                                                                  .fromColors(
                                                                  baseColor: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  highlightColor:
                                                                      Colors
                                                                          .grey
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
                                                          partyjsonList
                                                                  .isNotEmpty
                                                              ? Text(
                                                                  "Phone: ${partyjsonList[partyIndex]["phone"]}",
                                                                )
                                                              : Shimmer
                                                                  .fromColors(
                                                                  baseColor: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  highlightColor:
                                                                      Colors
                                                                          .grey
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
                                                          partyjsonList
                                                                  .isNotEmpty
                                                              ? Text(
                                                                  "Email: ${partyjsonList[partyIndex]["email"]}",
                                                                )
                                                              : Shimmer
                                                                  .fromColors(
                                                                  baseColor: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  highlightColor:
                                                                      Colors
                                                                          .grey
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
                                                            height: 20,
                                                          ),
                                                          partyjsonList
                                                                  .isNotEmpty
                                                              ? Text(
                                                                  "Address Details"
                                                                      .toUpperCase(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                )
                                                              : Shimmer
                                                                  .fromColors(
                                                                  baseColor: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  highlightColor:
                                                                      Colors
                                                                          .grey
                                                                          .shade200,
                                                                  child:
                                                                      Container(
                                                                    height: 10,
                                                                    width: 150,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                          SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.2,
                                                              child: Divider()),
                                                          partyjsonList
                                                                  .isNotEmpty
                                                              ? Text(
                                                                  partyjsonList
                                                                          .isNotEmpty
                                                                      ? "Billing Address: \n${partyjsonList[partyIndex]["billingAddress"]["billStreet"]},\n${partyjsonList[partyIndex]["billingAddress"]["billArea"]},\n${partyjsonList[partyIndex]["billingAddress"]["billCity"]}-${partyjsonList[partyIndex]["billingAddress"]["billZipcode"]}"
                                                                      : "Address:",
                                                                  softWrap:
                                                                      false,
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
                                                                      Colors
                                                                          .grey
                                                                          .shade200,
                                                                  child:
                                                                      Container(
                                                                    height: 40,
                                                                    width: 150,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          partyjsonList
                                                                  .isNotEmpty
                                                              ? Text(
                                                                  partyjsonList
                                                                          .isNotEmpty
                                                                      ? "Shipping Address: \n${partyjsonList[partyIndex]["shippingAddress"]["shipStreet"]},\n${partyjsonList[partyIndex]["shippingAddress"]["shipArea"]},\n${partyjsonList[partyIndex]["shippingAddress"]["shipCity"]}-${partyjsonList[partyIndex]["shippingAddress"]["shipZipcode"]}"
                                                                      : "Address:",
                                                                  softWrap:
                                                                      false,
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
                                                                      Colors
                                                                          .grey
                                                                          .shade200,
                                                                  child:
                                                                      Container(
                                                                    height: 40,
                                                                    width: 150,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                        ]),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15.0,
                                                            left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        partyjsonList.isNotEmpty
                                                            ? Text(
                                                                "Other Details"
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
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
                                                        SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2,
                                                            child: Divider()),
                                                        partyjsonList.isNotEmpty
                                                            ? Text(
                                                                "GST Treatment: ${partyjsonList[partyIndex]["gstType"]}",
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
                                                        partyjsonList.isNotEmpty
                                                            ? Text(
                                                                "GSTIN: ${partyjsonList[partyIndex]["gstIN"]}",
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
                                                        partyjsonList.isNotEmpty
                                                            ? Text(
                                                                "POS: ${partyjsonList[partyIndex]["pos"]}",
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
                                                  )
                                                ],
                                              )
                                            : const Text(
                                                "Currently there is no transaction")
                                      ],
                                    ),
                                  ),
                                ))
                              : const SizedBox()
                    ],
                  ),
                )
              ],
            ),
    );
  }

  tablecontent(int partyIndex) {
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
              child: Text(partyjsonList[partyIndex]["type"]),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(partyjsonList[partyIndex]["companyName"]),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(DateFormat('MM/dd/yyyy')
                  .format(partyjsonList[partyIndex]["created_date"].toDate())),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("${partyjsonList[partyIndex]["gstType"]}"),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(partyjsonList[partyIndex]["ropAmount"]),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text((int.parse(partyjsonList[partyIndex]["customerId"]))
                  .toString()),
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
              "Currently you dont have any data available. Add Customer to grow your business."),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          ElevatedButton(
              onPressed: () async {
                var res = await showDialog(
                    context: context,
                    builder: (builder) => Addparties(false, {}));
                if (res == "Added") {
                  getData();
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Add Customer"),
              ))
        ],
      ),
    );
  }
}
