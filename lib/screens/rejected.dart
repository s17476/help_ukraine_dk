import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_ukraine_dk/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Rejected extends StatefulWidget {
  const Rejected({Key? key}) : super(key: key);

  @override
  State<Rejected> createState() => _RejectedState();
}

class _RejectedState extends State<Rejected> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).clear();
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: const Center(
        child: Text(
          'Rejected by the administrator',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
