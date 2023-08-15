import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:rasitu_login/module/routeHandler.dart';

import 'module/purchaseData.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDox5NdKejuSls5FM5zfT_FhSmabpBhinY",
          authDomain: "rasitutest.firebaseapp.com",
          databaseURL:
              "https://rasitutest-default-rtdb.asia-southeast1.firebasedatabase.app",
          projectId: "rasitutest",
          storageBucket: "rasitutest.appspot.com",
          messagingSenderId: "255147951930",
          appId: "1:255147951930:web:f5334381c6a5a66d873203",
          measurementId: "G-7MC502DHB2"));

  runApp(const MyApp());
}

//Color maincolor = Colors.white;
Color maincolor = const Color.fromARGB(255, 65, 125, 255);
double screensize = 500;
// String id = "";
// String mailid = "";
//int index = 0;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PurchaseData>(
      create: (context) => PurchaseData(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Rasitu',
        theme: Theme.of(context)
            .copyWith(buttonColor: const Color.fromARGB(255, 65, 125, 255)),
        routerConfig: RouteHandler().router,
      ),
    );
  }
}
