import 'package:flutter/material.dart';
import 'package:spring/models/student.dart';
import 'package:spring/services/student_service.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StudentService _studentService = StudentService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressUpdateController = TextEditingController();

  final TextEditingController _updateController = TextEditingController();

  List<Student> _students = [];
  bool isLoad = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() async {
    try {
      final students = await _studentService.getAllStudents();
      setState(() {
        _students = students;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to load students list")));
    }
    setState(() {
      isLoad = false;
    });
  }

  void _addStudent() async {
    try {
      final message = await _studentService.addStudent(_nameController.text,_addressController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      setState(() {
        _nameController.text = "";
        _loadStudents();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to add student")));
    }
  }

  void _updateStudent(int id, String name,String address) async {
    try {
      final message = await _studentService.updateStudent(id, name,address);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      setState(() {
        _loadStudents();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to update student")));
    }
  }

  void _deleteStudent(int id) async {
    try {
      final message = await _studentService.deleteStudent(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      setState(() {
        _loadStudents();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to delete student")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student List"),
      ),
      body: Column(
        children: [
          Visibility(
            visible: isLoad,
            child: const LinearProgressIndicator(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return ListTile(
                  title: Column(
                    children: [

                      Text("${student.id}) ${student.name}"),
                      Text(student.address),


                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: Container(
                              margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: SingleChildScrollView(
                                child: AlertDialog(
                                  title: const Text("Edit Student"),
                                  content: Column(
                                    children: [
                                      TextField(
                                        controller: _updateController,
                                        decoration: const InputDecoration(hintText: "Name"),

                                      ),
                                      const SizedBox(height: 15,),
                                      TextField(
                                        controller: _addressUpdateController,
                                        decoration: const InputDecoration(hintText: "Address"),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text("Cancel"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: const Text("Update"),
                                      onPressed: () {
                                        _updateStudent(
                                          student.id, _updateController.text,_addressUpdateController.text);
                                        Navigator.pop(context);

                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),

                  leading: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Delete Student"),
                            content: Text(
                                "Are you sure you want to delete ${student
                                    .name}?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text("Delete"),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _deleteStudent(student.id);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    child: AlertDialog(
                      title: const Text("Add Student"),
                      content: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(hintText: "Name"),
                          ),
                          const SizedBox(height: 15,),
                          TextField(
                            controller: _addressController,
                            decoration: const InputDecoration(hintText: "Address"),
                          ),

                        ],
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: const Text("Add"),
                          onPressed: () {
                            _addStudent();
                            Navigator.pop(context);

                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
