import 'package:flutter/material.dart';
import 'package:random_user/view/user_list_view.dart';
import 'package:random_user/view/search_bar.dart';
import 'package:random_user/view/user_profile_screen.dart';
import 'controller/user_controller.dart';


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
  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _userController.onListenersUpdated = () {
      setState(() {});
    };
    _userController.loadInitialUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User List'),
        ),
        body: Column(children: <Widget>[
          SizedBox(width: 30),
          MySearchBar(
            controller: _userController.emailController,
            onSearch: _userController.searchByEmail,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _userController.refreshUsers,
              child: UserListView(
                  users: _userController.userList,
                  scrollController: _userController.scrollController,
                  isLoadingMore: _userController.isLoadingMore,
                  onUserTap: (user) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(user: user),
                      ),
                    );
                  }),
            ),
          ),
        ]));
  }
}
