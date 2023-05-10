import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserCustomisationPage extends StatefulWidget {
  const UserCustomisationPage({Key? key}) : super(key: key);

  @override
  State<UserCustomisationPage> createState() => _UserCustomisationPageState();
}

class _UserCustomisationPageState extends State<UserCustomisationPage> {
  final TextEditingController _username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(107, 45, 161, 1),
        centerTitle: true,
        title: const Text("Edit", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: TextField(
          controller: _username,
          cursorColor: const Color.fromRGBO(107, 45, 161, 1),
          decoration: const InputDecoration(
              label: Text("UserName", style: TextStyle(color: Color.fromRGBO(107, 45, 161, 1))),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(107, 45, 161, 1)))),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(107, 45, 161, 1),
        onPressed: () {
          if (_username.text.trim().isEmpty) return;
          FirebaseAuth.instance.currentUser!.updateDisplayName(_username.text.trim()).whenComplete(() {
            FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.email!)
                .update({"displayName": _username.text.trim()});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("UserName Updated")));
          });
        },
        label: const Text("Done", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
  }
}
