import 'package:flutter/material.dart';
import 'package:random_user/model/user.dart';

class UserListView extends StatelessWidget {
  final List<User> users;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final Function(User) onUserTap;

  const UserListView({
    Key? key,
    required this.users,
    required this.scrollController,
    required this.isLoadingMore,
    required this.onUserTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: users.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= users.length) {
          return isLoadingMore ? const Center(child: CircularProgressIndicator()) : Container();
        }
        User user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          title: Text(user.name),
          subtitle: Text(user.email),
          onTap: () => onUserTap(user),
        );
      },
    );
  }
}