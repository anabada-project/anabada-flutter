class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
    required this.gender,
    required this.generation,
    this.isAdmin = false,
  });

  final String id;
  final String name;
  final String email;
  final String major;
  final String gender;
  final String generation;
  final bool isAdmin;

  AppUser copyWith({
    String? name,
    String? email,
    String? major,
    String? gender,
    String? generation,
    bool? isAdmin,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      major: major ?? this.major,
      gender: gender ?? this.gender,
      generation: generation ?? this.generation,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
