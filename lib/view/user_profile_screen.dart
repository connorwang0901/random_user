import 'package:flutter/material.dart';
import '../model/user.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;

  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'user-${user.id}',
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
            ),
            const SizedBox(height: 30),
            Text("Name: ${user.name}"),
            Text("Email: ${user.email}"),
          ],
        ),
      ),
    );
  }
}
