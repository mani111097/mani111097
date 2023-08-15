import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rasitu_login/Mainscreen/sidenavigator.dart';
import 'package:rasitu_login/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasitu_login/module/sharedpreference.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool login = true;
  bool registration = true;
  List container = [];
  bool passObscure = true;
  int index = 0;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController companyname = TextEditingController();
  TextEditingController companyphone = TextEditingController();
  TextEditingController emailid = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController referal = TextEditingController();
  TextEditingController sosSearch = TextEditingController();

  String? stateofsupply;
  String id = "";

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  final GlobalKey<FormState> _form1 = GlobalKey<FormState>();

  final PrefService _prefService = PrefService();

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    container = [home(), about(), contact()];
    return Scaffold(
      body: MediaQuery.of(context).size.width > 750
          ? Stack(children: [
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
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        maincolor,
                        maincolor,
                        Colors.white,
                        Colors.white
                      ], stops: const [
                        0.0,
                        0.5,
                        0.5,
                        1.0
                      ]),
                      //border: Border.all(color: maincolor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: home(),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: login
                                ? loginpannel()
                                : registration
                                    ? Registration()
                                    : Registration2()),
                      ]),
                ),
              ),
            ])
          : Stack(
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
                    width: MediaQuery.of(context).size.width * 0.75,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: maincolor),
                        borderRadius: BorderRadius.circular(10)),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Text("rasitu",
                            style: TextStyle(
                              color: maincolor,
                              fontWeight: FontWeight.bold,
                              fontFamily: "DancingScript",
                              fontSize: 18,
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.55,
                            //width: MediaQuery.of(context).size.width * 0.2,
                            child: login
                                ? loginpannel()
                                : registration
                                    ? Registration()
                                    : Registration2()),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  contact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            "Contact Us",
            style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            "We are happy to help you. You can contact us on",
            style: TextStyle(
              color: Color.fromARGB(192, 255, 255, 255),
            ),
          ),
        ),
      ],
    );
  }

  about() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            "About Rasitu",
            style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            "Rasitu is a small start up which helps small growing business. We help people grow the business world wide.",
            style: TextStyle(
              color: Color.fromARGB(192, 255, 255, 255),
            ),
          ),
        ),
      ],
    );
  }

  home() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("rasitu",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "DancingScript",
                fontSize: 18,
              )),
          Text("Welcome to rasitu",
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Image.asset(
            "images/data-amico.png",
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Text("Build for your business",
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          const Text(
            "We have solution for all you business. We are \ncustomisable to meet the requirement of your \nbusiness as per your unique business \nrequirements.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  loginpannel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/rasitu.png",
              height: 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.02,
            ),
            const Text(
              "Login",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),

        //const Text("We are ready to help you, Login to Explore"),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width > 750
              ? MediaQuery.of(context).size.width * 0.23
              : MediaQuery.of(context).size.width,
          child: TextFormField(
            controller: email,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 10),
                fillColor: Color.fromARGB(255, 229, 229, 229),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 0.0),
                ),
                hintText: "Email Id",
                labelStyle: TextStyle(color: Colors.grey),
                // focusColor: Colors.grey,
                prefixIcon: Icon(Icons.mail)),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width > 750
              ? MediaQuery.of(context).size.width * 0.23
              : MediaQuery.of(context).size.width,
          child: TextFormField(
            controller: password,
            obscureText: passObscure,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 5),
              fillColor: Color.fromARGB(255, 229, 229, 229),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0),
              ),
              hintText: "Password",
              prefixIcon: Icon(Icons.key_rounded),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        const Text("Forgot Password?"),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width > 750
              ? MediaQuery.of(context).size.width * 0.23
              : MediaQuery.of(context).size.width,
          child: ElevatedButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const Center(child: CircularProgressIndicator());
                    });

                try {
                  var result = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email.text, password: password.text);

                  if (result.user != null) {
                    _prefService.createCache(email.text, password.text);

                    await FirebaseFirestore.instance
                        .collection('User')
                        .where("Email", isEqualTo: email.text)
                        .get()
                        .then((value) => id = value.docs.first['userId']);

                    print("id $id");

                    _prefService.createidCache(id);

                    context.go("/home/dashboard");
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (builder) => const SideNavigator()));
                  }
                } catch (e) {
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return AlertDialog(
                          title: const Text("Login Failed"),
                          content: Text(e.toString()),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text("Close"))
                          ],
                        );
                      });
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: maincolor),
              child: const Text("Login")),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        GestureDetector(
          onTap: (() {
            setState(() {
              login = false;
            });
          }),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create your Account",
                style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 102, 102, 102),
                    fontWeight: FontWeight.w400),
              ),
              const Icon(
                Icons.arrow_forward_sharp,
                size: 12,
                color: Color.fromARGB(255, 102, 102, 102),
              )
            ],
          ),
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Registration() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
        child: Form(
          key: _form1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              TextFormField(
                controller: companyname,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 5),
                    fillColor: Color.fromARGB(255, 229, 229, 229),
                    filled: true,
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    hintText: "Customer Name",
                    prefixIcon: Icon(Icons.person)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Company Name cannot be null";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              TextFormField(
                controller: companyphone,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 5),
                    fillColor: Color.fromARGB(255, 229, 229, 229),
                    filled: true,
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    hintText: "Mobile Number",
                    prefixIcon: Icon(Icons.phone)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Mobile Number cannot be null";
                  } else {
                    if (value.length < 10) {
                      return "Mobile number entered is invalid";
                    } else {
                      return null;
                    }
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              TextFormField(
                controller: emailid,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 5),
                    fillColor: Color.fromARGB(255, 229, 229, 229),
                    filled: true,
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    hintText: "Email Address",
                    prefixIcon: Icon(Icons.mail)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email Address cannot be null";
                  } else {
                    if (value.contains(".com") && value.contains("@")) {
                      return null;
                    } else {
                      return "Email Id entered is invalid";
                    }
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 0, color: Colors.white),
                    color: const Color.fromARGB(255, 229, 229, 229),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_history,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: supplydropdown()))
                    ],
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              TextFormField(
                controller: newpassword,
                obscureText: true,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 5),
                    fillColor: Color.fromARGB(255, 229, 229, 229),
                    filled: true,
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    hintText: "Password",
                    prefixIcon: Icon(Icons.key)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password is empty";
                  } else {
                    if (value.length < 8 && !letterReg.hasMatch(value) ||
                        !numReg.hasMatch(value)) {
                      return "Please enter a strong password";
                    } else {
                      return null;
                    }
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              TextFormField(
                controller: confirmpassword,
                obscureText: true,
                decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 5),
                    fillColor: Color.fromARGB(255, 229, 229, 229),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    hintText: "Confirm Password",
                    prefixIcon: Icon(Icons.key)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password is empty";
                  } else {
                    if (value != newpassword.text) {
                      return "Password doesnt match";
                    } else {
                      return null;
                    }
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              TextFormField(
                controller: referal,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 5),
                    fillColor: Color.fromARGB(255, 229, 229, 229),
                    filled: true,
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    hintText: "Referral Code (Optional)",
                    prefixIcon: Icon(Icons.person)),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_form1.currentState!.validate()) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            });

                        if (stateofsupply != null) {
                          String userId = DateTime.now().year.toString() +
                              DateTime.now().month.toString() +
                              DateTime.now().millisecond.toString() +
                              DateTime.now().day.toString();
                          Map<String, dynamic> data = {
                            'Name': companyname.text,
                            'Phone': companyphone.text,
                            'Email': emailid.text,
                            'userId': userId,
                            'sos': stateofsupply,
                            'Referral': referal.text.isEmpty ? "" : referal.text
                          };
                          // ignore: unrelated_type_equality_checks
                          if (await accountValidation(
                                  emailid.text, companyphone.text) ==
                              0) {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailid.text,
                                    password: newpassword.text);
                            FirebaseFirestore.instance
                                .collection("User")
                                .doc(userId)
                                .set(data);

                            Navigator.pop(context);

                            setState(() {
                              login = true;
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (builder) => AlertDialog(
                                      title: const Text("Alert"),
                                      content: const Text(
                                          "Email/Phone already been used"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Close"))
                                      ],
                                    ));
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: maincolor),
                    child: const Text("Sign Up")),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    login = true;
                  });
                }),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account",
                      style: GoogleFonts.openSans(
                          color: const Color.fromARGB(255, 102, 102, 102),
                          fontWeight: FontWeight.w400),
                    ),
                    const Icon(
                      Icons.arrow_forward_sharp,
                      size: 12,
                      color: Color.fromARGB(255, 102, 102, 102),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<int> accountValidation(String email, String phone) async {
    int emailcheck = await FirebaseFirestore.instance
        .collection("User")
        .where('Email', isEqualTo: email)
        .get()
        .then((value) => value.docs.length);

    int phonecheck = await FirebaseFirestore.instance
        .collection("User")
        .where('Phone', isEqualTo: phone)
        .get()
        .then((value) => value.docs.length);

    print(emailcheck + phonecheck);

    int length = emailcheck + phonecheck;

    return length;
  }

  Registration2() {
    return SizedBox(
      // padding: const EdgeInsets.all(50),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Create Account",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width > 1050
                ? MediaQuery.of(context).size.width * 0.25
                : MediaQuery.of(context).size.width,
            child: TextFormField(
              controller: street,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  fillColor: Color.fromARGB(255, 229, 229, 229),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.0),
                  ),
                  hintText: "House Number and Street",
                  prefixIcon: Icon(Icons.location_city_rounded)),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width > 1050
                ? MediaQuery.of(context).size.width * 0.25
                : MediaQuery.of(context).size.width,
            child: TextFormField(
              controller: area,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  fillColor: Color.fromARGB(255, 229, 229, 229),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.0),
                  ),
                  hintText: "Area",
                  prefixIcon: Icon(Icons.location_city_rounded)),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width > 1050
                ? MediaQuery.of(context).size.width * 0.25
                : MediaQuery.of(context).size.width,
            child: TextFormField(
              controller: city,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  fillColor: Color.fromARGB(255, 229, 229, 229),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.0),
                  ),
                  hintText: "City",
                  prefixIcon: Icon(Icons.location_city_rounded)),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width > 1050
                ? MediaQuery.of(context).size.width * 0.25
                : MediaQuery.of(context).size.width,
            child: TextFormField(
              controller: state,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  fillColor: Color.fromARGB(255, 229, 229, 229),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.0),
                  ),
                  hintText: "State",
                  prefixIcon: Icon(Icons.location_city_rounded)),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width > 1050
                ? MediaQuery.of(context).size.width * 0.25
                : MediaQuery.of(context).size.width,
            child: TextFormField(
              controller: pincode,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  fillColor: Color.fromARGB(255, 229, 229, 229),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.0),
                  ),
                  hintText: "Pincode",
                  prefixIcon: Icon(Icons.location_city_rounded)),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width > 1050
                ? MediaQuery.of(context).size.width * 0.25
                : MediaQuery.of(context).size.width,
            child: TextFormField(
              controller: referal,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  fillColor: Color.fromARGB(255, 229, 229, 229),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.0),
                  ),
                  hintText: "Referral Code (Optional)",
                  prefixIcon: Icon(Icons.person)),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width > 1050
                ? MediaQuery.of(context).size.width * 0.25
                : MediaQuery.of(context).size.width,
            child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const SideNavigator()),
                  // );
                },
                style: ElevatedButton.styleFrom(backgroundColor: maincolor),
                child: const Text("Next")),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          GestureDetector(
            onTap: (() {
              setState(() {
                registration = true;
              });
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.arrow_back_sharp,
                  size: 12,
                  color: Color.fromARGB(255, 102, 102, 102),
                ),
                Text(
                  "Previous page",
                  style: GoogleFonts.openSans(
                      color: const Color.fromARGB(255, 102, 102, 102),
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  supplydropdown() {
    return Theme(
      data: Theme.of(context).copyWith(focusColor: Colors.transparent),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isDense: true,
          hint: const Text("State of Supply"),
          value: stateofsupply,
          onChanged: (String? newValue) {
            setState(() {
              stateofsupply = newValue!;
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
            width: 200,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 250,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: sosSearch,
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
                controller: sosSearch,
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
              sosSearch.clear();
            }
          },
        ),
      ),
    );
  }
}
