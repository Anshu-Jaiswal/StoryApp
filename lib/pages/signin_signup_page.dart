import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInSignUpPage extends StatefulWidget {
  const SignInSignUpPage({Key? key}) : super(key: key);

  @override
  State<SignInSignUpPage> createState() => _SignInSignUpPageState();
}

class _SignInSignUpPageState extends State<SignInSignUpPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  var hidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromRGBO(107, 45, 161, 1.0), title: Text("Welcome")),
      body: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  cursorColor: Color.fromRGBO(107, 45, 161, 1),
                  controller: _email,
                  decoration: const InputDecoration(
                    label: Text("Enter email", style: TextStyle(color: Color.fromRGBO(107, 45, 161, 1.0))),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(107, 45, 161, 1))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(107, 45, 161, 1))),
                  ),
                ),
                TextField(
                  controller: _password,
                  cursorColor: Color.fromRGBO(107, 45, 161, 1),
                  obscureText: hidden, // to hide password
                  decoration: InputDecoration(
                    label: const Text("Enter password", style: TextStyle(color: Color.fromRGBO(107, 45, 161, 1.0))),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(107, 45, 161, 1))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(107, 45, 161, 1))),
                    suffixIcon: IconButton(
                      color: Color.fromRGBO(192, 182, 209, 1.0),
                      onPressed: () => setState(() => hidden = !hidden),
                      icon: Icon(hidden ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(107, 45, 161, 1.0)),
                    onPressed: _signInOldUser,
                    child: const Text("Log In")),
              ],
            ),
          ),
          const Spacer(),
          Card(
            margin: EdgeInsets.fromLTRB(30, 0, 30, 15),
            color: Color.fromRGBO(209, 201, 214, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("New User?"),
                TextButton(
                    onPressed: _signUpNewUser,
                    child: const Text(
                      "Create Account",
                      style: TextStyle(color: Color.fromRGBO(107, 45, 161, 1)),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  _signInOldUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text, password: _password.text);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _signUpNewUser() async {
    var email = _email.text;
    var password = _password.text;
    try {
      var cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      Map<String, Object?> values = {
        "auth_uid": cred.user!.uid,
        "friends": [],
        "story": null, // self-posted story
        "feed": {}, // feed of stories from anyone
        "displayName": null,
      };
      FirebaseFirestore.instance.collection("users").doc(email).set(values);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }
}
