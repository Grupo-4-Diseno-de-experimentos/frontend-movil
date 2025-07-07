class User {
  final int? id; // ✅ Agregar el campo id
  final String name;
  final String lastName;
  final String email;
  final String role;
  final String? password;
  final DateTime? createdAt;

  User({
    this.id, // ✅ agregar
    required this.name,
    required this.lastName,
    required this.email,
    required this.role,
    this.password,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'], // ✅ leer el id desde el JSON
    name: json['name'],
    lastName: json['lastName'] ?? json['lastname'], // ✅ si tu backend usa "lastname" minúscula
    email: json['email'],
    role: json['role'],
    password: json['password'],
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, // ✅ incluir el id al serializar
    'name': name,
    'lastName': lastName,
    'email': email,
    'password': password,
    'role': role,
    'created_at': createdAt?.toIso8601String(),
  };
}