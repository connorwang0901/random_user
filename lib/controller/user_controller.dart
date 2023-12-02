import 'package:flutter/cupertino.dart';

import '../model/user_service.dart';
import '../model/user.dart';

class UserController {

  final UserService userService = UserService();
  ScrollController scrollController = ScrollController();
  TextEditingController emailController = TextEditingController();

  List<User> userList = [];
  List<User> curUserList = [];
  bool isLoadingMore = false;
  bool isIncrease = true;

  VoidCallback? onListenersUpdated;

  UserController() {
    loadInitialUsers();
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
    curUserList = userList;
    notifyListeners();
  }

  Future<void> loadMoreUsers() async {
    if (isLoadingMore) return;
    isLoadingMore = true;
    notifyListeners();

    try {
      List<User> moreUsers = await userService.fetchUsers();
      userList.addAll(moreUsers);
      curUserList.addAll(moreUsers);
      notifyListeners();
    } catch (e) {
    } finally {
        isLoadingMore = false;
        notifyListeners();
    }
  }

  Future<void> refreshUsers() async {
    userList.clear();
    curUserList.clear();
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
    userList = curUserList;
    userList = userList
        .where((user) => user.email.toLowerCase().contains(searchEmail))
        .toList();
    notifyListeners();
  }

}