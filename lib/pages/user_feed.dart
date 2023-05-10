import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserFeed extends StatelessWidget {
  const UserFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(107, 45, 161, 1.0),
        title: const Text("Feed"),
      ),
      body: Center(
        child: FutureBuilder(
          future: _future,
          builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData)
              return const CircularProgressIndicator();
            else if (snapshot.hasError || snapshot.data == null) return const Text("Error");

            Map<String, dynamic> feed = snapshot.requireData.get('feed');

            if (feed.isEmpty) return const Text("No feed");

            var senders = feed.keys.toList();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        ClipRRect(
                            child: _X(feed[senders[index]]),
                            borderRadius:
                                BorderRadius.only(bottomRight: Radius.circular(16), topLeft: Radius.circular(16))),
                        Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Text(senders[index]),
                          ),
                          color: Color.fromRGBO(209, 201, 214, 1.0),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                    thickness: 2, color: Color.fromRGBO(107, 45, 161, 1), height: 48, indent: 50, endIndent: 50),
                itemCount: senders.length,
              ),
            );
          },
        ),
      ),
    );
  }

  // currentUser -> database -> feed -> Map :: {sender:{"story":post},sender2:{}} -> each entry -> image and text
  Future<DocumentSnapshot<Map<String, dynamic>>> get _future =>
      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.email!).get();
}

class _X extends StatelessWidget {
  const _X(this.ref, {Key? key}) : super(key: key);
  final String ref;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          try {
            return Image.network(
              snapshot.requireData,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2,
              fit: BoxFit.fill,
            );
          } catch (e) {
            return const Text("Error");
          }
        },
      ),
    );
  }

  Future<String> get _future => FirebaseStorage.instance.ref(ref).getDownloadURL();
}
