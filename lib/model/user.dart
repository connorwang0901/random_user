class User {
  final String name;
  final String email;
  final String avatarUrl;

  User({required this.name, required this.email, required this.avatarUrl});

  User.fromJson(Map<String, dynamic> json)
      :name = json['name']['first'] + " " + json['name']['last'],
      email = json['email'],
      avatarUrl = json['picture']['thumbnail'];

  get id => name;
}