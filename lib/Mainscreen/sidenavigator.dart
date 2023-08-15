import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rasitu_login/Mainscreen/constants/pageconstant.dart';
import 'package:rasitu_login/Mainscreen/constants/topbottom.dart';
import 'package:rasitu_login/Mainscreen/pages/dashboard.dart';
import 'package:rasitu_login/Mainscreen/pages/purchasebill.dart';
import 'package:rasitu_login/Mainscreen/purchase/expenses.dart';
import 'package:rasitu_login/Mainscreen/purchase/purchaseorder.dart';
import 'package:rasitu_login/Mainscreen/purchase/purchaseout.dart';
import 'package:rasitu_login/Mainscreen/purchase/return.dart';
import 'package:rasitu_login/Mainscreen/pages/invoice.dart';
import 'package:rasitu_login/Mainscreen/pages/items.dart';
import 'package:rasitu_login/Mainscreen/pages/parties.dart';
import 'package:rasitu_login/Mainscreen/sales/creditnotes.dart';
import 'package:rasitu_login/Mainscreen/sales/deliverychallan.dart';
import 'package:rasitu_login/Mainscreen/sales/estimate.dart';
import 'package:rasitu_login/Mainscreen/sales/paymentin.dart';
import 'package:rasitu_login/Mainscreen/sales/salesorder.dart';
import 'package:rasitu_login/main.dart';
import 'package:rasitu_login/module/paymentinpopup.dart';
import 'package:rasitu_login/module/sharedpreference.dart';

class SideNavigator extends StatefulWidget {
  final String page;
  final String id;

  SideNavigator({required this.page, this.id = ""});

  @override
  State<SideNavigator> createState() => _SideNavigatorState();
}

class _SideNavigatorState extends State<SideNavigator> {
  int hover = 50;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  final PrefService _prefService = PrefService();

  Color iconunselected = Colors.white;
  TextStyle unselectedtext = const TextStyle(color: Colors.white, fontSize: 15);
  TextStyle selectedtext = const TextStyle(
    color: Colors.white,
    fontSize: 15,
  );
  List tabs = [
    const Dashboard(),
    Party(),
    Items(),
    const Invoice(),
    PageConstant("Estimate", "Estimate"),
    PageConstant("Delivery Challan", "Challan"),
    PageConstant("Sales Order", "Sales Order"),
    PageConstant("Payment Received", "Payment-In"),
    PageConstant("Credit Note", "Credit Note"),
    const PurchaseBill(),
    PageConstant("Purchase Out", "Payment-Out"),
    PageConstant("Purchase Order", "Order"),
    PageConstant("Purchase Return", "Debit Note"),
    const PurchaseBill(),
    const PurchaseOut(),
    const PurchaseOrder(),
    const PurchaseReturns(),
    const Center(
      child: Text("Invoice"),
    ),
    const Center(
      child: Text("Purchase"),
    ),
    const Center(
      child: Text("Settings"),
    )
  ];

  List<String> pages = [
    'dashboard',
    'customer',
    'items',
    'invoice',
    'estimate',
    'delivery challan',
    'sales order',
    'paymentin',
    'credit notes',
    'purchase bill',
    'purchase order',
    'expenses',
  ];

  drawer() {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 65, 125, 255),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: Text("rasitu",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "DancingScript",
                    fontSize: 20,
                  )),
            ),
          ),
          const Divider(),
          Expanded(child: sideElements())
        ],
      ),
    );
  }

  sideElements() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (event) {
              setState(() {
                hover = 0;
              });
            },
            onExit: (event) {
              setState(() {
                hover = 50;
              });
            },
            child: GestureDetector(
                onTap: (() {
                  context.go('/home/dashboard');
                }),
                child: Container(
                  height: 35,
                  width: 200,
                  decoration: BoxDecoration(
                      color: hover == 0 ? Colors.blue[600] : Colors.transparent,
                      border: const Border(
                          bottom: BorderSide(color: Colors.transparent))),
                  child: menuitem(
                      title: "Dashboard",
                      icon: Icon(
                        Icons.home,
                        size: pages.indexOf(widget.page) == 0 ? 20 : 18,
                        color: pages.indexOf(widget.page) == 0
                            ? Colors.white
                            : iconunselected,
                      ),
                      selected: pages.indexOf(widget.page) == 0 ? true : false,
                      style: pages.indexOf(widget.page) == 0
                          ? selectedtext
                          : unselectedtext),
                )),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (event) {
              setState(() {
                hover = 1;
              });
            },
            onExit: (event) {
              setState(() {
                hover = 50;
              });
            },
            child: GestureDetector(
                onTap: (() {
                  context.go('/home/customer');
                }),
                child: Container(
                  height: 35,
                  width: 200,
                  decoration: BoxDecoration(
                      color: hover == 1 ? Colors.blue[600] : Colors.transparent,
                      border: const Border(
                          bottom: BorderSide(color: Colors.transparent))),
                  child: menuitem(
                      title: "Parties",
                      icon: Icon(
                        Icons.people,
                        size: pages.indexOf(widget.page) == 1 ? 20 : 18,
                        color: pages.indexOf(widget.page) == 1
                            ? Colors.white
                            : iconunselected,
                      ),
                      selected: pages.indexOf(widget.page) == 1 ? true : false,
                      style: pages.indexOf(widget.page) == 1
                          ? selectedtext
                          : unselectedtext),
                )),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (event) {
              setState(() {
                hover = 2;
              });
            },
            onExit: (event) {
              setState(() {
                hover = 50;
              });
            },
            child: GestureDetector(
                onTap: (() {
                  print(widget.page + widget.id);
                  context.go('/home/items');
                }),
                child: Container(
                  height: 35,
                  width: 200,
                  decoration: BoxDecoration(
                      color: hover == 2 ? Colors.blue[600] : Colors.transparent,
                      border: const Border(
                          bottom: BorderSide(color: Colors.transparent))),
                  child: menuitem(
                      title: "Items",
                      icon: Icon(
                        Icons.content_paste_rounded,
                        size: pages.indexOf(widget.page) == 2 ? 20 : 18,
                        color: pages.indexOf(widget.page) == 2
                            ? Colors.white
                            : iconunselected,
                      ),
                      selected: pages.indexOf(widget.page) == 2 ? true : false,
                      style: pages.indexOf(widget.page) == 2
                          ? selectedtext
                          : unselectedtext),
                )),
          ),

          //Sales
          ListTileTheme(
            dense: true,
            child: Theme(
              data: Theme.of(context).copyWith(
                  hoverColor: Colors.blue[600],
                  dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: true,
                tilePadding: EdgeInsets.zero,
                title: menuitem(
                    title: "Sales",
                    icon: Icon(
                      Icons.shopping_cart,
                      size: 18,
                      color: iconunselected,
                    ),
                    selected: false,
                    style: unselectedtext),
                textColor: Colors.white,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) {
                      setState(() {
                        hover = 3;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        hover = 50;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          context.go('/home/invoice');
                        });
                      },
                      child: Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: hover == 3
                                ? Colors.blue[600]
                                : Colors.transparent,
                            border: const Border(
                                bottom: BorderSide(color: Colors.transparent))),
                        child: menuitem(
                            title: "Invoice",
                            icon: const Icon(
                              Icons.settings,
                              size: 20,
                              color: Colors.transparent,
                            ),
                            selected:
                                pages.indexOf(widget.page) == 3 ? true : false,
                            style: pages.indexOf(widget.page) == 3
                                ? selectedtext
                                : unselectedtext),
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) {
                      setState(() {
                        hover = 4;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        hover = 50;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        context.go('/home/estimate');
                      },
                      child: Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: hover == 4
                                ? Colors.blue[600]
                                : Colors.transparent,
                            border: const Border(
                                bottom: BorderSide(color: Colors.transparent))),
                        child: menuitem(
                            title: "Estimate",
                            icon: const Icon(
                              Icons.settings,
                              size: 20,
                              color: Colors.transparent,
                            ),
                            selected:
                                pages.indexOf(widget.page) == 4 ? true : false,
                            style: pages.indexOf(widget.page) == 4
                                ? selectedtext
                                : unselectedtext),
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) {
                      setState(() {
                        hover = 5;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        hover = 50;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        context.go('/home/delivery challan');
                      },
                      child: Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: hover == 5
                                ? Colors.blue[600]
                                : Colors.transparent,
                            border: const Border(
                                bottom: BorderSide(color: Colors.transparent))),
                        child: menuitem(
                            title: "Delivery Challans",
                            icon: const Icon(
                              Icons.settings,
                              size: 20,
                              color: Colors.transparent,
                            ),
                            selected:
                                pages.indexOf(widget.page) == 5 ? true : false,
                            style: pages.indexOf(widget.page) == 5
                                ? selectedtext
                                : unselectedtext),
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) {
                      setState(() {
                        hover = 6;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        hover = 50;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        context.go('/home/sales order');
                      },
                      child: Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: hover == 6
                                ? Colors.blue[600]
                                : Colors.transparent,
                            border: const Border(
                                bottom: BorderSide(color: Colors.transparent))),
                        child: menuitem(
                            title: "Sales Order",
                            icon: const Icon(
                              Icons.settings,
                              size: 20,
                              color: Colors.transparent,
                            ),
                            selected:
                                pages.indexOf(widget.page) == 6 ? true : false,
                            style: pages.indexOf(widget.page) == 6
                                ? selectedtext
                                : unselectedtext),
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) {
                      setState(() {
                        hover = 7;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        hover = 50;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        context.go('/home/paymentin');
                      },
                      child: Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: hover == 7
                                ? Colors.blue[600]
                                : Colors.transparent,
                            border: const Border(
                                bottom: BorderSide(color: Colors.transparent))),
                        child: menuitem(
                            title: "Payment Received",
                            icon: const Icon(
                              Icons.settings,
                              size: 20,
                              color: Colors.transparent,
                            ),
                            selected:
                                pages.indexOf(widget.page) == 7 ? true : false,
                            style: pages.indexOf(widget.page) == 7
                                ? selectedtext
                                : unselectedtext),
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) {
                      setState(() {
                        hover = 8;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        hover = 50;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        context.go('/home/credit notes');
                      },
                      child: Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: hover == 8
                                ? Colors.blue[600]
                                : Colors.transparent,
                            border: const Border(
                                bottom: BorderSide(color: Colors.transparent))),
                        child: menuitem(
                            title: "Credit Notes",
                            icon: const Icon(
                              Icons.settings,
                              size: 20,
                              color: Colors.transparent,
                            ),
                            selected:
                                pages.indexOf(widget.page) == 8 ? true : false,
                            style: pages.indexOf(widget.page) == 8
                                ? selectedtext
                                : unselectedtext),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          //Purchase
          ListTileTheme(
            dense: true,
            child: Theme(
              data: Theme.of(context).copyWith(
                  hoverColor: Colors.blue[600],
                  dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: true,
                tilePadding: EdgeInsets.zero,
                collapsedIconColor: Colors.white,
                title: menuitem(
                    title: "Purchase",
                    icon: Icon(
                      Icons.shopping_bag,
                      size: 18,
                      color: iconunselected,
                    ),
                    selected: false,
                    style: unselectedtext),
                textColor: Colors.white,
                iconColor: Colors.white,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) {
                      setState(() {
                        hover = 9;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        hover = 50;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        context.go('/home/purchase bill');
                      },
                      child: Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: hover == 9
                                ? Colors.blue[600]
                                : Colors.transparent,
                            border: const Border(
                                bottom: BorderSide(color: Colors.transparent))),
                        child: menuitem(
                            title: "Purchase Bills",
                            icon: const Icon(
                              Icons.settings,
                              size: 20,
                              color: Colors.transparent,
                            ),
                            selected:
                                pages.indexOf(widget.page) == 9 ? true : false,
                            style: pages.indexOf(widget.page) == 9
                                ? selectedtext
                                : unselectedtext),
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) {
                      setState(() {
                        hover = 10;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        hover = 50;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        context.go('/home/purchase order');
                      },
                      child: Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: hover == 10
                                ? Colors.blue[600]
                                : Colors.transparent,
                            border: const Border(
                                bottom: BorderSide(color: Colors.transparent))),
                        child: menuitem(
                            title: "Purchase Order",
                            icon: const Icon(
                              Icons.settings,
                              size: 20,
                              color: Colors.transparent,
                            ),
                            selected:
                                pages.indexOf(widget.page) == 10 ? true : false,
                            style: pages.indexOf(widget.page) == 10
                                ? selectedtext
                                : unselectedtext),
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) {
                      setState(() {
                        hover = 11;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        hover = 50;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        context.go('/home/expenses');
                      },
                      child: Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: hover == 11
                                ? Colors.blue[600]
                                : Colors.transparent,
                            border: const Border(
                                bottom: BorderSide(color: Colors.transparent))),
                        child: menuitem(
                            title: "Expenses",
                            icon: const Icon(
                              Icons.settings,
                              size: 20,
                              color: Colors.transparent,
                            ),
                            selected:
                                pages.indexOf(widget.page) == 11 ? true : false,
                            style: pages.indexOf(widget.page) == 11
                                ? selectedtext
                                : unselectedtext),
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) {
                      setState(() {
                        hover = 12;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        hover = 50;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        context.go('/home/dashboard');
                      },
                      child: Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: hover == 12
                                ? Colors.blue[600]
                                : Colors.transparent,
                            border: const Border(
                                bottom: BorderSide(color: Colors.transparent))),
                        child: menuitem(
                            title: "Purchase Return",
                            icon: const Icon(
                              Icons.settings,
                              size: 20,
                              color: Colors.transparent,
                            ),
                            selected:
                                pages.indexOf(widget.page) == 12 ? true : false,
                            style: pages.indexOf(widget.page) == 12
                                ? selectedtext
                                : unselectedtext),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onTap: (() {
                  context.go('/home/dashboard');
                }),
                child: Container(
                  height: 35,
                  width: 200,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.transparent))),
                  child: menuitem(
                      title: "Online Store",
                      icon: Icon(
                        Icons.store,
                        size: pages.indexOf(widget.page) == 4 ? 20 : 18,
                        color: pages.indexOf(widget.page) == 4
                            ? Colors.white
                            : iconunselected,
                      ),
                      selected: pages.indexOf(widget.page) == 4 ? true : false,
                      style: pages.indexOf(widget.page) == 4
                          ? selectedtext
                          : unselectedtext),
                )),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onTap: (() {
                  context.go('/home/dashboard');
                }),
                child: Container(
                  height: 35,
                  width: 200,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.transparent))),
                  child: menuitem(
                      title: "Setting",
                      icon: Icon(
                        Icons.settings,
                        size: pages.indexOf(widget.page) == 5 ? 20 : 18,
                        color: pages.indexOf(widget.page) == 5
                            ? Colors.white
                            : iconunselected,
                      ),
                      selected: pages.indexOf(widget.page) == 5 ? true : false,
                      style: pages.indexOf(widget.page) == 5
                          ? selectedtext
                          : unselectedtext),
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldkey,
        drawer: drawer(),
        appBar: MediaQuery.of(context).size.width < 850
            ? AppBar(
                backgroundColor: const Color.fromARGB(255, 65, 125, 255),
                leading: GestureDetector(
                    onTap: () {
                      scaffoldkey.currentState?.openDrawer();
                    },
                    child: const Icon(Icons.menu)),
                title: const Text("rasitu",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "DancingScript",
                      fontSize: 20,
                    )),
              )
            : null,
        body: MediaQuery.of(context).size.width > 850
            ? Row(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: maincolor,
                      child: ListView(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text("rasitu",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "DancingScript",
                                    fontSize: 20,
                                  )),
                            ),
                          ),
                          const Divider(),
                          sideElements()
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 5),
                            child: TopContainer(),
                          ),
                          Expanded(
                              child: Container(
                            color: Colors.red,
                            child: IndexedStack(
                              index: pages.indexOf(widget.page),
                              children: [
                                const Dashboard(),
                                Party(
                                  id: widget.id,
                                  page: widget.page,
                                ),
                                Items(
                                  id: widget.id,
                                  page: widget.page,
                                ),
                                const Invoice(),
                                const Estimate(),
                                const Delivery(),
                                const SalesOrder(),
                                Paymentin(
                                  type: widget.id,
                                ),
                                const CreditNotes(),
                                const PurchaseBill(),
                                const PurchaseOrder(),
                                const Expenses(),
                                const PaymentInpopup(),
                              ],
                            ),
                          ))
                        ],
                      ))
                ],
              )
            : Column(
                children: [
                  Expanded(
                      child: Container(
                    color: Colors.red,
                    child: IndexedStack(
                      index: pages.indexOf(widget.page),
                      children: [
                        const Dashboard(),
                        Party(
                          id: widget.id,
                          page: widget.page,
                        ),
                        Items(
                          id: widget.id,
                          page: widget.page,
                        ),
                        const Invoice(),
                        const Estimate(),
                        const Delivery(),
                        const SalesOrder(),
                        Paymentin(
                          type: widget.id,
                        ),
                        const CreditNotes(),
                        const PurchaseBill(),
                        const PurchaseOrder(),
                        const Expenses()
                      ],
                    ),
                  ))
                ],
              ));
  }

  Widget menuitem(
      {String? title, Icon? icon, TextStyle? style, bool? selected}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        children: [
          selected == true
              ? Container(
                  height: 35,
                  width: 5,
                  color: Colors.white,
                )
              : Container(
                  height: 35,
                  width: 5,
                  color: Colors.transparent,
                ),
          const SizedBox(
            width: 15,
          ),
          icon!,
          const SizedBox(
            width: 8,
          ),
          Text(
            title!,
            style: style,
          ),
        ],
      ),
    );
  }
}
