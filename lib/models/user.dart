class AppUser {
  final String id;
  final String phone;
  final String? name;
  final String role; // renter | agent | admin

  AppUser({required this.id, required this.phone, this.name, required this.role});

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'],
        phone: json['phone'],
        name: json['name'],
        role: json['role'],
      );
}
