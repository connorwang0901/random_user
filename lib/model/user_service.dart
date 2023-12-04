import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'user.dart';

int currentPage = 1;
Random rand = Random();
List<String> countryList = ['us', 'fr', 'dk','gb'];
const int pageSize = 20;

class UserService {
  Future<List<User>> fetchUsers() async {
    String country = countryList[rand.nextInt(3)];
    currentPage++;
    final response = await http.get(Uri.parse('https://randomuser.me/api/?results=$pageSize&page=$currentPage&nat=$country'));

    if (response.statusCode == 200) {
      List<User> users = [];
      Map<String, dynamic> data = jsonDecode(response.body);
      for (var userJson in data['results']) {
        User newUser = User.fromJson(userJson);
        users.add(newUser);
      }
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}