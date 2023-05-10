import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_story_app/routes.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(192, 182, 209, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(107, 45, 161, 1),
        title: _title,
        leading: _customisationBtn,
        actions: [_signOutBtn, SizedBox(width: 24)],
      ),
      body: Center(
        child: DottedBorder(
          color: Colors.white,
          dashPattern: const [12, 8],
          radius: Radius.circular(MediaQuery.of(context).size.width * .05),
          borderType: BorderType.RRect,
          strokeWidth: 3,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .8,
            decoration: BoxDecoration(
              // color: Colors.white,
              color: Color.fromRGBO(239, 230, 245, 1.0),
              //    border: Border.all(color: Color.fromRGBO(194, 188, 204, 1.0), width: 2),
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _btn("My Story", Icons.star, AppRoutes.userStory),
                  SizedBox(height: MediaQuery.of(context).size.height * .04),
                  _btn("My Feed", Icons.feed, AppRoutes.userFeed),
                  SizedBox(height: MediaQuery.of(context).size.height * .04),
                  _btn("My Contacts", Icons.contacts, AppRoutes.contacts),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  get _signOutBtn => IconButton(
        onPressed: () => FirebaseAuth.instance.signOut(),
        icon: const Icon(Icons.logout),
      );

  get _customisationBtn => DottedBorder(
        color: Colors.white,
        borderPadding: EdgeInsets.all(8),
        borderType: BorderType.Oval,
        strokeWidth: 2,
        dashPattern: [10, 5],
        child: IconButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.userCustomisation),
          icon: const Icon(Icons.person_rounded, size: 32),
        ),
      );

  ElevatedButton _btn(String label, IconData icon, String path) => ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(107, 45, 161, 1.0),
            fixedSize: Size(MediaQuery.of(context).size.width * .09, MediaQuery.of(context).size.height * .07)),
        onPressed: () => Navigator.pushNamed(context, path),
        child: Row(
          children: [
            Expanded(flex: 2, child: Icon(icon)),
            Expanded(flex: 3, child: Text(label)),
          ],
        ),
      );

  get _title => Text(FirebaseAuth.instance.currentUser?.displayName ?? "Home Page");
}
