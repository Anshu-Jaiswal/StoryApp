import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_story_app/routes.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final db = FirebaseFirestore.instance.collection("users");
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(107, 45, 161, 1),
        title: const Text("Contacts", style: TextStyle(color: Colors.white)),
        actions: [
          _addContactBtn,
          SizedBox(
            width: 18,
          )
        ],
      ),
      body: Container(
        color: Color.fromRGBO(239, 230, 245, 0.6),
        child: Center(
          child: Center(
            child: FutureBuilder(
                future: db.doc(auth.currentUser!.email!).get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  List friendList = snapshot.requireData.get('friends');

                  if (friendList.isEmpty) {
                    return const Text("No friends found");
                  }

                  return ListView.builder(
                    itemCount: friendList.length,
                    itemBuilder: (context, index) {
                      String email = friendList[index];
                      return Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Card(
                            color: Colors.grey.shade50,
                            child: ListTile(
                              leading: Text("${index + 1}"),
                              title: Text(email),
                              trailing: _removeContact(friendList, index),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget _removeContact(List<dynamic> friendList, int index) {
    return Card(
      color: Colors.white,
      shadowColor: Color.fromRGBO(107, 45, 161, 1),
      margin: EdgeInsets.fromLTRB(0, 12, 8, 4),
      child: IconButton(
        color: Color.fromRGBO(199, 176, 214, 1.0),
        icon: const Icon(Icons.delete),
        onPressed: () {
          friendList.removeAt(index);
          db.doc(auth.currentUser!.email!).update({'friends': friendList}).whenComplete(() => setState(() {}));
        },
      ),
    );
  }

  get _addContactBtn => Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
        width: 42,
        height: 24,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color: Colors.white, style: BorderStyle.solid, width: 1.5, strokeAlign: BorderSide.strokeAlignInside)),
        child: IconButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.addContact).whenComplete(() => setState(() {})),
          icon: const Icon(Icons.add),
        ),
      );
}
