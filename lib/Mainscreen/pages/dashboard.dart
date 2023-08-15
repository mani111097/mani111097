import 'dart:ui';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:flutter/material.dart';
import 'package:rasitu_login/Mainscreen/constants/topbottom.dart';

import '../../main.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime _selectedDate = DateTime.now();
  List months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Padding(
            //   padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5),
            //   child: TopContainer(),
            // ),
            // const Divider(
            //   height: 1,
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: MediaQuery.of(context).size.width > 1050
                  ? Row(
                      children: [
                        returnsdetailscontainer("Sales",
                            months[_selectedDate.month - 1], 20000, 10000),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        returnsdetailscontainer("Purchase",
                            months[_selectedDate.month - 1], 20000, 5000)
                      ],
                    )
                  : Column(
                      children: [
                        returnsdetailscontainer("Sales",
                            months[_selectedDate.month - 1], 20000, 10000),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.02,
                        ),
                        returnsdetailscontainer("Purchase",
                            months[_selectedDate.month - 1], 20000, 5000)
                      ],
                    ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
              child: cashflowchart(),
            )
          ],
        ),
      ),
    );
  }

  cashflowchart() {
    Paint circlePaint = Paint()..color = Colors.black;

    Paint insideCirclePaint = Paint()..color = Colors.white;

    Paint linePaint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..color = Colors.black;

    final List<ChartData> chartData = [
      ChartData("Jan", 0),
      ChartData("Feb", 0),
      ChartData("Mar", 0),
      ChartData("April", 0),
      ChartData("May", 0),
      ChartData("June", 0),
      ChartData("July", 0),
      ChartData("August", 45),
      ChartData("September", 25),
      ChartData("October", 35),
      ChartData("November", 65),
      ChartData("December", 0),
    ];
    return MediaQuery.of(context).size.width > 1050
        ? Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.62,
            // padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                border: Border.all(color: maincolor)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      title: Text(
                        "Cash Flow",
                        style: TextStyle(color: maincolor, fontSize: 20),
                      ),
                      trailing: SizedBox(
                        width: 75,
                        child: TextButton(
                            onPressed: () {
                              showyearpicker();
                            },
                            child: Row(
                              children: [
                                Text("${_selectedDate.year}"),
                                Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: maincolor,
                                )
                              ],
                            )),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          // Chart title
                          //title: ChartTitle(text: 'Yearly Sales analysis'),
                          // Enable legend
                          legend: Legend(isVisible: true),
                          // Enable tooltip
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries<ChartData, String>>[
                            LineSeries<ChartData, String>(
                                dataSource: chartData,
                                xValueMapper: (ChartData sales, _) =>
                                    sales.month,
                                yValueMapper: (ChartData sales, _) =>
                                    sales.sales,
                                name: 'Sales',
                                color: maincolor,
                                // Enable data label
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true))
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            // padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                border: Border.all(color: maincolor)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      title: Text(
                        "Cash Flow",
                        style: TextStyle(color: maincolor, fontSize: 20),
                      ),
                      trailing: SizedBox(
                        width: 75,
                        child: TextButton(
                            onPressed: () {
                              showyearpicker();
                            },
                            child: Row(
                              children: [
                                Text("${_selectedDate.year}"),
                                Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: maincolor,
                                )
                              ],
                            )),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          // Chart title
                          //title: ChartTitle(text: 'Yearly Sales analysis'),
                          // Enable legend
                          legend: Legend(isVisible: true),
                          // Enable tooltip
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries<ChartData, String>>[
                            LineSeries<ChartData, String>(
                                dataSource: chartData,
                                xValueMapper: (ChartData sales, _) =>
                                    sales.month,
                                yValueMapper: (ChartData sales, _) =>
                                    sales.sales,
                                name: 'Sales',
                                color: maincolor,
                                // Enable data label
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true))
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  showyearpicker() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.4,
              child: YearPicker(
                firstDate: DateTime(DateTime.now().year - 100, 1),
                lastDate: DateTime(DateTime.now().year + 100, 1),
                initialDate: DateTime.now(),
                selectedDate: _selectedDate,
                onChanged: (DateTime dateTime) {
                  setState(() {
                    _selectedDate = dateTime;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          );
        });
  }

  returnsdetailscontainer(
      String title, String month, double amount, double overdue) {
    double fillcolor = 0.5;

    return MediaQuery.of(context).size.width > 1050
        ? Container(
            height: MediaQuery.of(context).size.height * 0.21,
            width: MediaQuery.of(context).size.width * 0.3,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                border: Border.all(color: maincolor)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$title",
                        style: const TextStyle(
                            color: Color.fromARGB(220, 44, 80, 154)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Text("$month",
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Text(
                    "$amount",
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    height: 3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: const [
                      Colors.blue,
                      Colors.blue,
                      Colors.red,
                      Colors.red
                    ], stops: [
                      0.0,
                      fillcolor,
                      fillcolor,
                      1.0
                    ])),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Divider(
                    color: maincolor,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Current",
                              style: TextStyle(color: Colors.blue),
                            ),
                            Text((amount - overdue).toString())
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.07,
                        ),
                        VerticalDivider(
                          color: maincolor,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.07,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("OverDue",
                                style: TextStyle(color: Colors.red)),
                            Text(overdue.toString())
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height * 0.21,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                border: Border.all(color: maincolor)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$title",
                        style: const TextStyle(
                            color: Color.fromARGB(220, 44, 80, 154)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Text("$month",
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Text(
                    "$amount",
                    //style: TextStyle(color: maincolor, fontSize: 20),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Container(
                    height: 3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: const [
                      Colors.blue,
                      Colors.blue,
                      Colors.red,
                      Colors.red
                    ], stops: [
                      0.0,
                      fillcolor,
                      fillcolor,
                      1.0
                    ])),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Divider(
                    color: maincolor,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Current",
                              style: TextStyle(color: Colors.blue),
                            ),
                            Text((amount - overdue).toString())
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.07,
                        ),
                        VerticalDivider(
                          color: maincolor,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.07,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("OverDue",
                                style: TextStyle(color: Colors.red)),
                            Text(overdue.toString())
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

class ChartData {
  ChartData(this.month, this.sales);

  final String month;
  final double sales;
}
