import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_ukraine_dk/providers/user_provider.dart';
import 'package:help_ukraine_dk/screens/aprove.dart';
import 'package:help_ukraine_dk/screens/manage_tasks.dart';
import 'package:provider/provider.dart';

class Schedule extends StatelessWidget {
  const Schedule({Key? key}) : super(key: key);

  static const route = '/schedule';

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.initializeUser(context, userProvider.user!.userId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false).clear();
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (Provider.of<UserProvider>(context, listen: false).user!.admin)
              SizedBox(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    // users awaiting approvement
                    InkWell(
                      onTap: () =>
                          Navigator.of(context).pushNamed(AproveScreen.route),
                      child: Card(
                        color: Colors.white70,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Icon(Icons.person_add),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Users awaiting approvement'),
                                    Icon(Icons.arrow_forward_ios),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Manage tasks
                    InkWell(
                      onTap: () =>
                          Navigator.of(context).pushNamed(ManageTasks.route),
                      child: Card(
                        color: Colors.white70,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Manage tasks'),
                                    Icon(Icons.arrow_forward_ios),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
