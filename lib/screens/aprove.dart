import 'dart:async';

import 'package:flutter/material.dart';
import 'package:help_ukraine_dk/helpers/responsive_size.dart';
import 'package:help_ukraine_dk/helpers/size_config.dart';
import 'package:help_ukraine_dk/models/app_user.dart';
import 'package:help_ukraine_dk/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AproveScreen extends StatefulWidget {
  const AproveScreen({Key? key}) : super(key: key);

  static const route = '/aprove';

  @override
  State<AproveScreen> createState() => _AproveScreenState();
}

class _AproveScreenState extends State<AproveScreen> with ResponsiveSize {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Aprove users')),
      body: FutureBuilder(
        builder: (context, userSnap) {
          List<AppUser> users = [];
          if (userSnap.data != null) {
            users = userSnap.data as List<AppUser>;
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              AppUser user = users[index];
              return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.grey.shade300,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      CircleAvatar(
                        radius: responsiveSizePct(small: 25),
                        backgroundImage: NetworkImage(user.userImage),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          user.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(user.email),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => Provider.of<UserProvider>(context,
                                    listen: false)
                                .rejectUser(user),
                            child: const Text(
                              'Reject',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Provider.of<UserProvider>(context,
                                    listen: false)
                                .acceptUser(user),
                            child: const Text(
                              'Accept',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ));
            },
          );
        },
        future: Provider.of<UserProvider>(context).allUsersToAprove(),
      ),
    );
  }
}
