import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppColors {
  static const Color primaryColor = Color.fromARGB(255, 253, 156, 139);
  static const Color secondaryColor = Color.fromARGB(255, 243, 194, 243);
  static const Color backgroundColor = Color.fromARGB(255, 177, 188, 178);
}

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

class ToDoList extends StatelessWidget {
  final ToDoController controller = Get.put(ToDoController());

  ToDoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My To-Do List',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6, color: Colors.white),
            onPressed: () {
              Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Obx(
          () => ListView.builder(
            itemCount: controller.todos.length,
            itemBuilder: (context, index) {
              final todo = controller.todos[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(
                    todo['name'] ?? '',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  subtitle: Text(
                    todo['description'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.removeTodo(todo['name'] ?? ''),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(todo['name'] ?? ''),
                        content: Text(todo['description'] ?? ''),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.add, color: AppColors.primaryColor),
                  SizedBox(width: 10),
                  Text('Add Todo'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller.nameEditingController,
                    decoration:
                        const InputDecoration(hintText: 'Enter task name'),
                  ),
                  TextField(
                    controller: controller.descEditingController,
                    decoration: const InputDecoration(
                        hintText: 'Enter task description'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final name = controller.nameEditingController.text;
                    final description = controller.descEditingController.text;
                    controller.addTodo(name, description);
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
