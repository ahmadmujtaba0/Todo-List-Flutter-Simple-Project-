import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoList extends StatelessWidget {
  final ToDoController controller = Get.put(ToDoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.todos.length,
          itemBuilder: (context, index) {
            final todo = controller.todos[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.blue, width: 1),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                title: Text(
                  todo['name'] ?? '', // Handle null case
                  style: const TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  todo['description'] ?? '', // Handle null case
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => controller.removeTodo(todo['name'] ?? ''),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Todo'),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ToDoController extends GetxController {
  final _todoCollection = FirebaseFirestore.instance.collection('todos');
  RxList<Map<String, String>> todos = RxList<Map<String, String>>([]);
  final nameEditingController = TextEditingController();
  final descEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    final querySnapshot = await _todoCollection.get();
    final todoList = querySnapshot.docs.map((doc) {
      return {
        'name': doc['name'] as String,
        'description': doc['description'] as String,
      };
    }).toList();
    todos.value = todoList;
  }

  void addTodo(String name, String description) async {
    await _todoCollection.add({
      'name': name,
      'description': description,
    });
    _fetchTodos();
    nameEditingController.clear();
    descEditingController.clear();
  }

  void removeTodo(String name) async {
    final doc =
        await _todoCollection.where('name', isEqualTo: name).limit(1).get();
    if (doc.docs.isNotEmpty) {
      await _todoCollection.doc(doc.docs.first.id).delete();
      _fetchTodos();
    }
  }
}
