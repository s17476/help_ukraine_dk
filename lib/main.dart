import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:help_ukraine_dk/firebase_options.dart';
import 'package:help_ukraine_dk/providers/user_provider.dart';
import 'package:help_ukraine_dk/screens/auth_screen.dart';
import 'package:help_ukraine_dk/screens/await_confirmation.dart';
import 'package:help_ukraine_dk/screens/email_verification.dart';
import 'package:help_ukraine_dk/screens/initialization_fail.dart';
import 'package:help_ukraine_dk/screens/loading.dart';
import 'package:help_ukraine_dk/screens/schedule.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool emailVerified = false;
  bool emailSent = false;

  Future<void> sendVerificationEmail(User? user) async {
    if (!emailSent) {
      await user?.sendEmailVerification();
      emailSent = true;
    }
    Timer.periodic(const Duration(seconds: 3), (_) {
      print('$emailVerified xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

      setState(() {
        emailVerified = user?.emailVerified ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Help Ukraine',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.yellow.shade600,
        ),
        routes: {Schedule.route: (ctx) => const Schedule()},
        home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              // print(snapshot.error);
              return const InitializationFail();
            }
            //Firebase initialized
            if (snapshot.connectionState == ConnectionState.done) {
              return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext ctx, AsyncSnapshot<User?> userSnapshot) {
                  //set status bar and bottom navigation colors
                  // SystemChrome.setSystemUIOverlayStyle(
                  //     const SystemUiOverlayStyle(
                  //   systemNavigationBarColor: Colors.black,
                  //   statusBarColor: Colors.black,
                  // ));
                  //user logged in
                  if (userSnapshot.hasData) {
                    UserProvider userProvider =
                        Provider.of<UserProvider>(context);
                    User? user = FirebaseAuth.instance.currentUser;
                    // user data initialized
                    if (userProvider.user != null) {
                      if (!emailVerified) {
                        sendVerificationEmail(user);
                        return const EmailVerification();
                      }
                      if (userProvider.user!.approved) {
                        return const Schedule();
                      } else {
                        return const AwaitConfirmation();
                      }
                    } else {
                      // initialize user provider
                      userProvider.initializeUser(
                          context, userSnapshot.data!.uid);
                    }
                  } else if (!userSnapshot.hasData &&
                      userSnapshot.connectionState != ConnectionState.waiting) {
                    // print('auth        ' + userSnapshot.connectionState.name);
                    return const AuthScreen();
                  }
                  return const Loading();
                },
              );
            }
            return const Loading();
          },
        ),
      ),
    );
  }
}
