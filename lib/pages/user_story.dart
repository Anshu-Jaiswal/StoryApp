import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_story_app/routes.dart';

class UserStory extends StatefulWidget {
  const UserStory({Key? key}) : super(key: key);

  @override
  State<UserStory> createState() => _UserStoryState();
}

class _UserStoryState extends State<UserStory> {
  FilePickerResult? pickerResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Story"), backgroundColor: const Color.fromRGBO(107, 45, 161, 1.0)),
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Center(
                  child: Text(
                "Some error",
                style: TextStyle(fontSize: 32),
              ));
            }

            return _StoryWidget(snapshot.requireData.get("story")); // return  relative path
          },
          future: _future,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(107, 45, 161, 1.0),
        onPressed: () => Navigator.pushNamed(context, AppRoutes.uploadStory),
        label: const Text("Upload New Story"),
      ),
    );
  }

  Future<DocumentSnapshot<Map>> get _future =>
      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.email!).get();
}

class _StoryWidget extends StatefulWidget {
  const _StoryWidget(this.ref, {Key? key}) : super(key: key);
  final String? ref;

  @override
  State<_StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<_StoryWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.ref == null
        ? const Center(child: Text("No story posted by you"))
        : FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError || snapshot.data == null) {
                return const Text("Some error");
              }
              return Column(
                children: [
                  Image.network(snapshot.requireData),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(107, 45, 161, 1)),
                      onPressed: () async {
                        // 1 storage deleted
                        await FirebaseStorage.instance.ref(widget.ref).delete();
                        // 2 self database -> story = null
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.email)
                            .update({'story': null});

                        setState(() {});
                      },
                      child: const Text("Delete Story"))
                ],
              );
            },
          );
  }

  Future<String> get _future => FirebaseStorage.instance.ref(widget.ref).getDownloadURL();
}
