import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_ukraine_dk/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AwaitConfirmation extends StatefulWidget {
  const AwaitConfirmation({Key? key}) : super(key: key);

  @override
  State<AwaitConfirmation> createState() => _AwaitConfirmationState();
}

class _AwaitConfirmationState extends State<AwaitConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Text('Awaiting administrator confirmation'),
      ),
    );
  }
}
