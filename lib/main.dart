import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_story_app/pages/contact_list_page.dart';
import 'package:flutter_story_app/pages/upload_story.dart';
import 'package:flutter_story_app/pages/user_customisation_page.dart';
import 'package:flutter_story_app/routes.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'pages/account_check_page.dart';
import 'pages/add_contact_page.dart';
import 'pages/user_feed.dart';
import 'pages/user_story.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: FirebaseAuth.instance.userChanges(),
      initialData: null,
      builder: (context, child) {
        return MaterialApp(
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.home,
          routes: {
            AppRoutes.home: (context) => const AccountCheckPage(),
            AppRoutes.userCustomisation: (context) => const UserCustomisationPage(),
            AppRoutes.contacts: (context) => const ContactListPage(),
            AppRoutes.addContact: (context) => const AddContact(),
            AppRoutes.userStory: (context) => const UserStory(),
            AppRoutes.userFeed: (context) => const UserFeed(),
            AppRoutes.uploadStory: (context) => const UploadStory(),
            // AppRoutes.selectContacts: (context) => const SelectContacts(""),
          },
          builder: (context, child) => SafeArea(child: child!),
        );
      },
    );
  }
}
