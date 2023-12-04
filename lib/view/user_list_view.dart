import 'package:flutter/material.dart';
import 'package:random_user/model/user.dart';

class UserListView extends StatelessWidget {
  final List<User> users;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final Function(User) onUserTap;
  final Future<void> Function() onRefresh;

  const UserListView({
    Key? key,
    required this.users,
    required this.scrollController,
    required this.isLoadingMore,
    required this.onUserTap,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.builder(
          controller: scrollController,
          itemCount: users.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= users.length) {
              return isLoadingMore
                  ? const Center(child: CircularProgressIndicator())
                  : Container();
            }
            User user = users[index];
            return ListTile(
              leading: Hero(
                tag: 'user-${user.id}',
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
              ),
              title: Text(user.name),
              subtitle: Text(user.email),
              onTap: () => onUserTap(user),
            );
          },
        ));
  }
}
