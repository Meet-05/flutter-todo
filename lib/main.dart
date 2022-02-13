import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/screens/landing_screen.dart';
import 'package:todo_app/screens/on_boarding_screen.dart';
import './providers/google_signin.dart';
import 'package:provider/provider.dart';
import 'screens/task_home.dart';
import './screens/on_boarding_screen.dart';
import './screens/loading_screen.dart';
import './screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'Nunito'),
        home: ChangeNotifierProvider<GoogleSignInProvider>(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                final signInProvider =
                    Provider.of<GoogleSignInProvider>(context);
                if (signInProvider.isSigningIn) {
                  return LoadingScreen();
                } else if (snapshot.hasData) {
                  return LadningScreen();
                } else {
                  return OnBoardingScreen();
                }
              }),
        ));
  }
}
