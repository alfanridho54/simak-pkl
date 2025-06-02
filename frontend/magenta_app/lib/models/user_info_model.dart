
class UserInfo {
  final int id;
  final String name;
  final String? email;

  UserInfo({
    required this.id,
    required this.name,
    this.email,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'N/A',
      email: json['email'] as String?,
    );
  }
}