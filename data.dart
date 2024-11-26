import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ToDoController extends GetxController {
  final todoCollection = FirebaseFirestore.instance.collection('todos');
  RxList<Map<String, String>> todos = RxList<Map<String, String>>([]);
  final nameEditingController = TextEditingController();
  final descEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final querySnapshot = await todoCollection.get();
    final todoList = querySnapshot.docs.map((doc) {
      return {
        'name': doc['name'] as String,
        'description': doc['description'] as String,
      };
    }).toList();
    todos.value = todoList;
  }

  void addTodo(String name, String description) async {
    await todoCollection.add({
      'name': name,
      'description': description,
    });
    fetchTodos();
    nameEditingController.clear();
    descEditingController.clear();
  }

  void removeTodo(String name) async {
    final doc =
        await todoCollection.where('name', isEqualTo: name).limit(1).get();
    if (doc.docs.isNotEmpty) {
      await todoCollection.doc(doc.docs.first.id).delete();
      fetchTodos();
    }
  }
}
