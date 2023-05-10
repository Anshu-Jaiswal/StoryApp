import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'signin_signup_page.dart';
import 'userhome_page.dart';

class AccountCheckPage extends StatelessWidget {
  const AccountCheckPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return context.watch<User?>() == null
        ? const SignInSignUpPage()
        : const UserHomePage();
  }
}
