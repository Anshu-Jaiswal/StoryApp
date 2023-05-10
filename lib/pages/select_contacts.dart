import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SelectContacts extends StatefulWidget {
  const SelectContacts(this.file, this.filename, {Key? key}) : super(key: key);
  final File file;
  final String filename;

  @override
  State<SelectContacts> createState() => _SelectContactsState();
}

class _SelectContactsState extends State<SelectContacts> {
  final db = FirebaseFirestore.instance.collection("users");
  final auth = FirebaseAuth.instance;
  final List<String> recipients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Select Contacts"),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                child: Text(
                  "${recipients.length}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
          backgroundColor: Color.fromRGBO(107, 45, 161, 1.0)),
      body: Center(
        child: FutureBuilder(
          future: db.doc(auth.currentUser!.email!).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List friendList = snapshot.requireData.get('friends');

              if (friendList.isEmpty) {
                return const Text("No friends found");
              }

              return ListView.builder(
                itemCount: friendList.length,
                itemBuilder: (context, index) {
                  String email = friendList[index];
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(email),
                    value: recipients.contains(email),
                    activeColor: Color.fromRGBO(107, 45, 161, 1.0),
                    onChanged: (value) => setState(() => value! ? recipients.add(email) : recipients.remove(email)),
                  );
                },
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: recipients.isEmpty
          ? null
          : SizedBox(
              width: MediaQuery.of(context).size.width * .4,
              child: FloatingActionButton.extended(
                backgroundColor: Color.fromRGBO(107, 45, 161, 1.0),
                label: const Text("Upload"),
                onPressed: () async {
                  var userFolder = FirebaseAuth.instance.currentUser!.uid;

                  // 1 - storage upload -> ref

                  var path = "uploaded_stories/$userFolder/${widget.filename}";
                  var snapshot = await FirebaseStorage.instance.ref(path).putFile(widget.file);

                  // 2 - self story: null -> ref
                  var userEmail = FirebaseAuth.instance.currentUser!.email;
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(userEmail)
                      .update({"story": snapshot.ref.fullPath});

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Story Posted"),
                    duration: Duration(milliseconds: 600),
                  ));

                  // 3 - selected.each -> feed update email : ref
                  for (var r in recipients) {
                    var ds = await FirebaseFirestore.instance.collection("users").doc(r).get();
                    Map feed = ds.get("feed") as Map<String, dynamic>;

                    feed[userEmail] = snapshot.ref.fullPath;

                    FirebaseFirestore.instance.collection("users").doc(r).update({"feed": feed});
                    // {
                    // "c@m.com" : addressC,
                    // "b@m.com" : addressK
                    // }
                  }
                },
              ),
            ),
    );
  }
}
