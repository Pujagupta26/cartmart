import 'dart:math';

import 'package:flutter/material.dart';

drawer() {
  return Drawer(
    child: ListView(
      children: <Widget>[
        Center(
          child: UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.lightBlue.shade400,
              Colors.lightGreen.shade100
            ])),
            accountName: const Text("passed_name"),
            accountEmail: const Text("{user.email}"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: const NetworkImage(
                  "https://images.unsplash.com/photo-1667407226498-c06b03df35a8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1172&q=80"),
              key: ValueKey(Random().nextInt(100)),
            ),
          ),
        ),
        const Divider(
          color: Colors.black,
        ),
      ],
    ),
  );
}
