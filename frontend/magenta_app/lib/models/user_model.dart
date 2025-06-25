class User {
  final int id;
  final String name;
  final String? nim;
  final String email;
  final String? role;
  final String? avatar;

  User({
    required this.id,
    required this.name,
    this.nim,
    required this.email,
    this.role,
    this.avatar,
  });

factory User.fromJson(Map<String, dynamic> json) {
  return User(
   
    id: json['id'] as int? ?? 0,
    name: json['name'] as String? ?? 'Nama Tidak Ada',
    nim: json['nim'] as String?,
    email: json['email'] as String? ?? 'Email Tidak Ada',
    role: json['role'] as String?,
    avatar: json['avatar'] as String?,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nim': nim,
      'email': email,
      'role': role,
      'avatar': avatar
    };
  }
}