class User {
  final int id;
  final String name;
  final String email;
  final String? role; // Role bisa jadi bagian dari model User dari API /user
  // Tambahkan field lain jika API /user mengembalikannya, misal avatar_url

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
  });

factory User.fromJson(Map<String, dynamic> json) {
  return User(
    // Gunakan ?? untuk memberikan nilai default jika null, atau validasi lebih lanjut
    id: json['id'] as int? ?? 0, // Atau throw error jika id wajib ada
    name: json['name'] as String? ?? 'Nama Tidak Ada',
    email: json['email'] as String? ?? 'Email Tidak Ada',
    role: json['role'] as String?,
  );
}

  // Untuk menyimpan ke shared_preferences jika perlu
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}