import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ToDoController {
  final todoCollection = FirebaseFirestore.instance.collection('todos');
  RxList<Map<String, String>> todos = RxList<Map<String, String>>([]);
  final nameEditingController = TextEditingController();
  final descEditingController = TextEditingController();

  Future<void> fetchTodos() async {
    //function body in lib/domain/data.dart
  }

  void addTodo(String name, String description) async {
    //function body in lib/domain/data.dart
  }

  void removeTodo(String name) async {
    //function body in lib/domain/data.dart
  }

  void handleAddTodo(String name, String description) {
    if (name.isNotEmpty && description.isNotEmpty) {
      addTodo(name, description);
      // Call the method to add the todo
    } else {
      // Handle validation or any business logic here
      Get.snackbar('Error', 'Name and description cannot be empty');
    }
  }

  void showtodo(String name, String description) {
    if (name.isNotEmpty || description.isNotEmpty) {
      showtodo(name, description);
      // Call the method to show todo task
    }
  }
}
