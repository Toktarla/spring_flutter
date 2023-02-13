import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class StudentService {
  final String baseUrl = "http://10.0.2.2:8080/student";

  Future<List<Student>> getAllStudents() async {
    final response = await http.get(Uri.parse("$baseUrl/getAll"));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Student> students =
          body.map((dynamic item) => Student.fromJson(item)).toList();
      return students;
    } else {
      throw "Failed to load students list";
    }
  }

  Future<String> addStudent(String name,String address) async {
    Map data = {
      "name": name,
      "address":address
    };

    final response = await http.post(
      Uri.parse("$baseUrl/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return "Added successfully";
    } else {
      throw "Failed to add student";
    }
  }

  Future<String> updateStudent(int id, String name,String address) async {
    final response = await http.put(
      Uri.parse("$baseUrl/update/$id/$name/$address"),
    );

    if (response.statusCode == 200) {
      return "Student is updated";
    } else {

      throw "Failed to update student";
    }
  }

  Future<String> deleteStudent(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/delete/$id"));
    if (response.statusCode == 200) {
      return "Student is deleted";
    } else {
      throw "Failed to delete student";
    }
  }
}
