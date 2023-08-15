// ignore_for_file: unnecessary_string_escapes
import 'package:flutter/material.dart';
import 'package:rasitu_login/main.dart';
import 'package:google_fonts/google_fonts.dart';

class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  List<Text> basic = [
    Text(
      '1 Admin & 1 User',
      style: GoogleFonts.ptSerif(),
    ),
    Text(
      'Mobile Access',
      style: GoogleFonts.ptSerif(),
    ),
    Text(
      'Access to',
      style: GoogleFonts.ptSerif(color: maincolor, fontWeight: FontWeight.bold),
    ),
    Text(
      'Dashboard',
      style: GoogleFonts.ptSerif(),
    ),
    Text(
      'Add Items',
      style: GoogleFonts.ptSerif(),
    ),
    Text(
      'Sales',
      style: GoogleFonts.ptSerif(),
    ),
    Text(
      'Sales',
      style: GoogleFonts.ptSerif(),
    ),
    Text(
      'Online Store',
      style: GoogleFonts.ptSerif(),
    )
  ];
  List standard = [
    Text(
      '1 Admin & 3 User',
      style: GoogleFonts.ptSerif(),
    ),
    Text('Mobile Access', style: GoogleFonts.ptSerif()),
    Text('Access to',
        style:
            GoogleFonts.ptSerif(color: maincolor, fontWeight: FontWeight.bold)),
    RichText(
        text: TextSpan(
            text: 'Including everything in ',
            style: GoogleFonts.ptSerif(),
            children: [
          TextSpan(
              text: "Basic+",
              style: GoogleFonts.ptSerif(
                  color: maincolor, fontWeight: FontWeight.bold))
        ])),
    Text('Parties', style: GoogleFonts.ptSerif()),
    Text('Delivery Challan', style: GoogleFonts.ptSerif()),
    Text('Vendors', style: GoogleFonts.ptSerif()),
    Text('Payment Tracking', style: GoogleFonts.ptSerif()),
  ];
  List premium = [
    Text(
      '1 Admin & 3 User',
      style: GoogleFonts.ptSerif(),
    ),
    Text('Mobile Access', style: GoogleFonts.ptSerif()),
    Text('Access to',
        style:
            GoogleFonts.ptSerif(color: maincolor, fontWeight: FontWeight.bold)),
    RichText(
        text: TextSpan(
            text: 'Including everything in ',
            style: GoogleFonts.ptSerif(),
            children: [
          TextSpan(
              text: "Standard+",
              style: GoogleFonts.ptSerif(
                  color: maincolor, fontWeight: FontWeight.bold))
        ])),
    Text('Estimate', style: GoogleFonts.ptSerif()),
    Text('Expense Tracking', style: GoogleFonts.ptSerif()),
    Text('Return Tracking', style: GoogleFonts.ptSerif()),
    Text('Online Store (with Custom domine)', style: GoogleFonts.ptSerif()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("rasitu",
            style: TextStyle(
              color: maincolor,
              fontWeight: FontWeight.bold,
              fontFamily: "DancingScript",
              fontSize: 20,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: maincolor)),
              gradient: const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Color.fromARGB(159, 65, 125, 255),
                  Color.fromARGB(159, 65, 125, 255),
                  Colors.white,
                  Colors.white
                ],
              )),
        ),
      ),
      body: MediaQuery.of(context).size.width > 1050
          ? Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Color.fromARGB(159, 65, 125, 255),
                      Color.fromARGB(159, 65, 125, 255),
                      Colors.white,
                      Colors.white
                    ],
                  )),
                ),
                Center(
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: maincolor),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width * 0.25,
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(color: maincolor))),
                                child: top_container("BASIC", "249", basic),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width * 0.25,
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(color: maincolor))),
                                child:
                                    top_container("STANDARD", "349", standard),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width * 0.25,
                                //decoration: BoxDecoration(color: Colors.blue),
                                child: top_container("PREMIUM", "449", premium),
                              ),
                            ),
                          ],
                        )))
              ],
            )
          : SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 2,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          border: Border.all(color: maincolor),
                          borderRadius: BorderRadius.circular(10)),
                      child: top_container("BASIC", "249", basic),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          border: Border.all(color: maincolor),
                          borderRadius: BorderRadius.circular(10)),
                      child: top_container("STANDARD", "349", standard),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          border: Border.all(color: maincolor),
                          borderRadius: BorderRadius.circular(10)),
                      child: top_container("PREMIUM", "449", premium),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  top_container(String planname, String amount, List detailslist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(planname,
                  style: GoogleFonts.ibmPlexSerif(
                    color: const Color.fromARGB(255, 100, 104, 124),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.025,
                child: Divider(
                  color: maincolor,
                  thickness: 4,
                ),
              ),
              RichText(
                  text: TextSpan(text: "₹", children: [
                TextSpan(
                    text: amount,
                    style: GoogleFonts.ptSerif(
                        color: maincolor,
                        fontWeight: FontWeight.bold,
                        fontSize: 40))
              ])),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                "For organization/Monthly",
                style: GoogleFonts.ptSerif(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        side: BorderSide(color: maincolor))),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered))
                        return maincolor;
                      return const Color.fromARGB(255, 235, 240, 249);
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered))
                        return Colors.white;
                      return maincolor;
                    }),
                  ),
                  onPressed: () {},
                  child: Text(
                    "BUY NOW",
                    style: GoogleFonts.ptSerif(
                        fontWeight: FontWeight.bold, letterSpacing: 5),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: maincolor,
        ),
        Expanded(
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(30),
              itemCount: detailslist.length,
              itemBuilder: ((context, index) {
                return Row(
                  children: [
                    index != 2
                        ? Icon(
                            Icons.check,
                            size: 15,
                            color: maincolor,
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.06,
                          ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    detailslist[index],
                    // index != 2
                    //     ? Text(
                    //         detailslist[index],
                    //         style: GoogleFonts.ptSerif(color: Colors.black87),
                    //       )
                    //     : Text(detailslist[index],
                    //         style: GoogleFonts.ptSerif(
                    //             color: maincolor, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    )
                  ],
                );
              })),
        )
      ],
    );
  }
}
