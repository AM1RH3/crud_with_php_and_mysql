class User {
  final int id;
  final String name;
  final String lastName;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.age,
  });

  // Factory constructor to create a User from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id']),
      name: json['name'],
      lastName: json['lastName'],
      age: int.parse(json['age']),
    );
  }

  // Method to convert User to a JSON map
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'lastName': lastName, 'age': age};
  }
}
