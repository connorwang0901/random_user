import 'package:flutter/material.dart';
import 'package:random_user/view/user_list_view.dart';
import 'package:random_user/view/search_bar.dart';
import 'package:random_user/view/user_profile_screen.dart';
import 'controller/user_controller.dart';

void main() {
  runApp(UpduoApp());
}

class UpduoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const _MainScreen(),
    );
  }
}

class _MainScreen extends StatefulWidget {
  const _MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<_MainScreen> {
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
          title: const Text('Contacts'),
          backgroundColor: Colors.purple[900],
        ),
        body: Column(children: <Widget>[
          const SizedBox(width: 10),
          MySearchBar(
            controller: _userController.emailController,
            onSearch: _userController.searchByEmail,
            isIncrease: _userController.isIncrease,
            onSort: _userController.sortUsersByName,
          ),
          Expanded(
            child: UserListView(
                onRefresh: _userController.refreshUsers,
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
        ]));
  }
}
