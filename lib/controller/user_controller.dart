import 'package:flutter/cupertino.dart';
import '../model/user_service.dart';
import '../model/user.dart';

class UserController {

  final UserService userService = UserService();
  ScrollController scrollController = ScrollController();
  TextEditingController emailController = TextEditingController();

  List<User> userList = [];
  List<User> completeUserList = [];
  bool isLoadingMore = false;
  bool isIncrease = true;

  VoidCallback? onListenersUpdated;

  UserController() {
    scrollController.addListener(onScroll);
  }

  void notifyListeners() {
    if (onListenersUpdated != null) {
      onListenersUpdated!();
    }
  }

  Future<void> loadInitialUsers() async {
    List<User> initialUsers = await userService.fetchUsers();
    userList = initialUsers;
    completeUserList = userList;
    notifyListeners();
  }

  Future<void> loadMoreUsers() async {
    if (isLoadingMore) return;
    isLoadingMore = true;
    notifyListeners();

    try {
      List<User> moreUsers = await userService.fetchUsers();
      
      for (User newUser in moreUsers) {
        if (!completeUserList.any((user) => user.id == newUser.id)) {
            completeUserList.add(newUser);
        }

        if (!userList.any((user) => user.id == newUser.id)) {
            userList.add(newUser);
        }

        notifyListeners();
      }

    } catch (e) {
      throw Exception(e);
    } finally {
        isLoadingMore = false;
        notifyListeners();
    }
  }

  Future<void> refreshUsers() async {
    userList.clear();
    completeUserList.clear();
    notifyListeners();
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
      isIncrease = !isIncrease;
      isIncrease
          ? userList.sort((a, b) => a.name.compareTo(b.name))
          : userList.sort((a, b) => b.name.compareTo(a.name));
      notifyListeners();
  }

  void searchByEmail() {
    String searchEmail = emailController.text.toLowerCase();
    userList = completeUserList;
    userList = userList
        .where((user) => user.email.toLowerCase().contains(searchEmail))
        .toList();
    notifyListeners();
  }

}

