import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_story_app/pages/select_contacts.dart';

class UploadStory extends StatefulWidget {
  const UploadStory({Key? key}) : super(key: key);

  @override
  State<UploadStory> createState() => _UploadStoryState();
}

class _UploadStoryState extends State<UploadStory> {
  FilePickerResult? pickerResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload A Story"), backgroundColor: Color.fromRGBO(107, 45, 161, 1.0)),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(107, 45, 161, 1.0), fixedSize: Size(120, 40)),
              child: const Text("pick photo"),
              onPressed: () async {
                pickerResult = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
                if (pickerResult != null) {
                  setState(() {});
                }
              },
            ),
            if (pickerResult != null) Image.file(File(pickerResult!.files.first.path!)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: pickerResult == null
          ? null
          : FloatingActionButton.extended(
              //  backgroundColor: Color.fromRGBO(107, 45, 161, 1.0),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectContacts(File(pickerResult!.paths.first!), pickerResult!.names.first!),
                ),
              ),
              label: const Text("Continue"),
            ),
    );
  }
}
