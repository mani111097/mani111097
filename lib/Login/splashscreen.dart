import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:rasitu_login/Login/login.dart';
import 'package:rasitu_login/Mainscreen/sidenavigator.dart';
import 'package:rasitu_login/main.dart';
import 'package:rasitu_login/module/sharedpreference.dart';
import 'package:http/http.dart' as http;

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final PrefService _prefService = PrefService();

  checklogin() {
    _prefService.readCache().then((value) async {
      print(value);
      try {
        var result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: value[0], password: value[1]);

        if (result.user != null) {
          Navigator.pushNamed(context, '/home/dashboard');
        }
      } catch (e) {
        print(e);
        Navigator.pushNamed(context, '/login');
      }
    });
  }

  @override
  void initState() {
    checklogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              "images/rasitu.png",
              height: 50,
            ),
            const Center(
              child: Text("rasitu",
                  style: TextStyle(
                    color: Color.fromARGB(255, 65, 125, 255),
                    fontWeight: FontWeight.bold,
                    fontFamily: "DancingScript",
                    fontSize: 25,
                  )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
            ),
            const CircularProgressIndicator(
              color: Color.fromARGB(255, 65, 125, 255),
            )
          ],
        ),
      ),
    );
  }
}
