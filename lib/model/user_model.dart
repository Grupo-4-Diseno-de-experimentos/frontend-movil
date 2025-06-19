class User {
  final String name;
  final String lastName;
  final String email;
  final String role;
  final String? password;
  final DateTime createdAt;

  User({
    required this.name,
    required this.lastName,
    required this.email,
    required this.role,
    this.password,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    lastName: json['lastName'],
    email: json['email'],
    role: json['role'],
    password: json['password'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'lastName': lastName,
    'email': email,
    'password': password,
    'role': role,
    'created_at': createdAt.toIso8601String(),
  };
}