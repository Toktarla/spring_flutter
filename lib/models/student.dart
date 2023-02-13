import 'dart:convert';
List<Student> postFromJson(String str) => List<Student>.from(json.decode(str).map((x) => Student.fromJson(x)));

class Student {
  int id;
  String name;
  String address;

  Student({required this.id, required this.name, required this.address});

  factory Student.fromJson(Map<dynamic, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      address: json['address'] ?? "",
    );
  }
}