import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rasitu_login/Login/login.dart';
import 'package:rasitu_login/main.dart';
import 'package:rasitu_login/module/sharedpreference.dart';

class TopContainer extends StatefulWidget {
  const TopContainer({Key? key}) : super(key: key);

  @override
  State<TopContainer> createState() => _TopContainerState();
}

class _TopContainerState extends State<TopContainer> {
  final PrefService prefService = PrefService();
  String mailId = "";

  getMailId() async {
    try {
      String id = await prefService.readMailId().then((value) => value);
      setState(() {
        mailId = id;
      });
      print(mailId);
    } catch (e) {
      Navigator.pushNamed(context, '/failure');
    }
  }

  @override
  void initState() {
    getMailId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(
                color: maincolor,
              ),
              shape: BoxShape.circle),
          child: Icon(
            Icons.person,
            color: maincolor,
          )),
      title: Text("Check",
          style: TextStyle(color: maincolor, fontWeight: FontWeight.bold)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => const Login()));
            },
            child: Text(
              mailId,
              style: TextStyle(color: maincolor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
