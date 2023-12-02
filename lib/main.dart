import 'package:flutter/material.dart';
import 'package:random_user/view/UserProfileScreen.dart';
import 'controller/user.dart';
import 'controller/user_service.dart';

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
  List<User> curUserList = [];
  bool isLoadingMore = false;
  bool isIncrease = true;
  ScrollController scrollController = ScrollController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadInitialUsers();
    scrollController.addListener(onScroll);
  }

  Future<void> loadInitialUsers() async {
    List<User> initialUsers = await userService.fetchUsers();
    setState(() {
      userList = initialUsers;
      curUserList = userList;
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
        curUserList.addAll(moreUsers);
      });
    } catch (e) {
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future<void> refreshUsers() async {
    setState(() {
      userList.clear();
      curUserList.clear();
    });
    await loadInitialUsers();
  }

  void onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      loadMoreUsers();
    }
  }

  void sortUsersByName() {
    setState(() {
      isIncrease = !isIncrease;
      isIncrease
          ? userList.sort((a, b) => a.name.compareTo(b.name))
          : userList.sort((a, b) => b.name.compareTo(a.name));
    });
  }

  void searchByEmail() {
    String searchEmail = emailController.text.toLowerCase();
    setState(() {
      userList = curUserList;
      userList = userList
          .where((user) => user.email.toLowerCase().contains(searchEmail))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.sort_by_alpha),
            onPressed: sortUsersByName,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(width: 20),
          Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Search by Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: searchByEmail,
                child: Text('Submit'),
              ),
              const SizedBox(width: 20),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshUsers,
              child: ListView.builder(
                controller: scrollController,
                itemCount: userList.length + (isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= curUserList.length) {
                    return isLoadingMore
                        ? const Center(child: CircularProgressIndicator())
                        : Container();
                  }
                  User user = userList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.avatarUrl),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserProfileScreen(user: user)),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
