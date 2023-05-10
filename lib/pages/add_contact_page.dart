import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final TextEditingController _controller = TextEditingController();

  final db = FirebaseFirestore.instance.collection("users");
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(107, 45, 161, 1),
            title: const Text(
              "Add new contact",
              style: TextStyle(color: Colors.white),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.8,
            color: Color.fromRGBO(240, 237, 242, 1.0),
            margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.06, MediaQuery.of(context).size.height * 0.1, 0, 0),
            child: TextField(
              controller: _controller,
              cursorColor: Color.fromRGBO(107, 45, 161, 1),
              decoration: const InputDecoration(
                  label: Text(
                    "Enter friends email",
                    style: TextStyle(color: Color.fromRGBO(107, 45, 161, 1)),
                  ),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(107, 45, 161, 1))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(107, 45, 161, 1)))),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromRGBO(107, 45, 161, 1),
          onPressed: () async {
            var friendEmail = _controller.text.trim().toLowerCase();
            if (friendEmail.isEmpty) return;

            var userEmail = auth.currentUser!.email!.toLowerCase();

            // check for user email, can't allow self email
            if (userEmail == friendEmail) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You can't use your own email")));
              return;
            }

            if (!(await db.doc(friendEmail).get()).exists) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No such user")));
              return;
            }

            var snapshot = await db.doc(userEmail).get();

            List friendList = snapshot.get("friends");
            if (!friendList.contains(friendEmail)) {
              friendList.add(friendEmail);
            }

            db.doc(userEmail).update({"friends": friendList}).whenComplete(() => _controller.clear());
          },
          icon: const Icon(Icons.add),
          label: const Text("Add Contact"),
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
