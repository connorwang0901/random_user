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
  List<User> userList = [];
  bool isLoadingMore = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadInitialUsers();
    scrollController.addListener(_onScroll);
  }

  Future<void> loadInitialUsers() async {
    List<User> initialUsers = await userService.fetchUsers();
    setState(() {
      userList = initialUsers;
    });
  }

  Future<void> loadMoreUsers() async {
    if (isLoadingMore) return;
    setState(() {
      isLoadingMore = true;
    });

    try {
      List<User> moreUsers = await userService.fetchUsers();
      setState(() {
        userList.addAll(moreUsers);
      });
    } catch (e) {
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future<void> _refreshUsers() async {
    setState(() {
      currentPage = 0;
      userList.clear();
    });
    await loadInitialUsers();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      loadMoreUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User List'),
        ),
        body: RefreshIndicator(
            onRefresh: _refreshUsers,
            child: ListView.builder(
              controller: scrollController,
              itemCount: userList.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= userList.length) {
                  return isLoadingMore
                      ? Center(child: CircularProgressIndicator())
                      : Container();
                }
                User user = userList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            )
        )
    );
  }
}
