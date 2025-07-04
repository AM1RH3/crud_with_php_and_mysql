import 'dart:convert';
import 'package:crud_with_php_and_mysql/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeViewModel with ChangeNotifier {
  final String baseUrl = 'http://10.0.2.2/flutter-server/index.php';
  List<User> users = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  int? selectedUserIndex;
  bool isUpdateMode = false;

  // دریافت داده‌ها
  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        users = data.map((json) => User.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  // افزودن کاربر جدید
  Future<void> addUser() async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text,
          'lastName': lastNameController.text,
          'age': ageController.text,
        }),
      );
      if (response.statusCode == 200) {
        nameController.clear();
        lastNameController.clear();
        ageController.clear();
        await fetchUsers();
      } else {
        throw Exception('Failed to add user');
      }
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  // حذف کاربر
  Future<void> deleteUser(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(baseUrl),
        body: jsonEncode({'id': id}),
      );
      if (response.statusCode == 200) {
        await fetchUsers();
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  // به‌روزرسانی کاربر
  Future<void> updateUser(String id) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'name': nameController.text,
          'lastName': lastNameController.text,
          'age': ageController.text,
        }),
      );
      if (response.statusCode == 200) {
        isUpdateMode = false;
        nameController.clear();
        lastNameController.clear();
        ageController.clear();
        selectedUserIndex = null;
        await fetchUsers();
        notifyListeners();
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // آماده‌سازی برای ویرایش
  void prepareForUpdate(int index) {
    isUpdateMode = true;
    selectedUserIndex = index;
    final user = users[index];
    nameController.text = user.name;
    lastNameController.text = user.lastName;
    ageController.text = user.age.toString();
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    super.dispose();
  }
}
