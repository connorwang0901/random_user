import 'package:flutter/material.dart';
import './model/user_service.dart';
import './model/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserService userService = UserService();
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = userService.fetchUsers();
  }

  Future<void> _refreshUsers() async {
    setState(() {
      futureUsers = userService.fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshUsers,
        child: FutureBuilder<List<User>>(
          future: futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  User user = snapshot.data![index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.avatarUrl),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}