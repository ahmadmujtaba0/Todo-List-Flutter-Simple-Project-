import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 131, 80, 135)),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<String> _todoList =[];
  final TextEditingController _textController =TextEditingController();


  // add new task to list 
  void _addTodoItem(String task)
  {
    if(task.isNotEmpty)
    {
      setState(() 
      {
        _todoList.add(task);
      });
      _textController.clear();
    }
  }

  // remove task from list
  void _removeTodoItem(int index)
  {
    setState(() 
    {
      _todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('To Do List' , style: TextStyle(fontSize: 25),),
      ),
      
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                //input text 
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter new task',
                    ),
                  ),
                  ),

                  //button to add text

                  InkWell(
                    onTap: (){
                      _addTodoItem(_textController.text);
                    },
                    child: Container(

                      padding: const EdgeInsets.all(8.0),
                      color: Colors.lightBlueAccent,
                      child: const Text ('Add',style: TextStyle(color: Colors.white)
                      ),
                    ),
                  )
                ],
              ),
            ),

            //Task List
            Expanded(
              child: ListView.builder(
                itemCount: _todoList.length,
                itemBuilder: (context, index){
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10.0),
                    color:  Colors.red[50],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _todoList[index],
                          style: const TextStyle(fontSize: 18),
                        ),

                        // remove task buttoun
                        InkWell(
                          onTap: (){
                            _removeTodoItem(index);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.redAccent,
                            child: const Text('Delete', style: TextStyle(color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  );
                }
              ),    
            ),
        ],
      ) 
    );
  }
}
