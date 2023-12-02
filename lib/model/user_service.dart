import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';

int currentPage = 0;
final int pageSize = 20;

class UserService {
  Future<List<User>> fetchUsers() async {
    currentPage++;
    final response = await http.get(Uri.parse('https://randomuser.me/api/?results=$pageSize&page=$currentPage&nat=us'));

    if (response.statusCode == 200) {
      List<User> users = [];
      Map<String, dynamic> data = jsonDecode(response.body);
      for (var userJson in data['results']) {
        users.add(User.fromJson(userJson));
      }
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}