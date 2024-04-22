import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _userToDo;
  List<String> todoList = [];
  TextEditingController _textFieldController = TextEditingController(); 

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  _loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todoList = prefs.getStringList('todoList') ?? []; 
    });
  }
   _saveTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', todoList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 187, 233, 251),
      appBar: AppBar(
        title: const Text('TO DO LIST', style: TextStyle(color: Colors.black54, fontSize: 30.0), ),
        backgroundColor: Colors.white54,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: todoList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(todoList[index]), 
            child: Card(
              child: ListTile(
                title: Text(todoList[index]),
                trailing: IconButton(
                 icon: Icon(
                  Icons.delete_sweep,
                  color: Colors.red[900],
                  ),
                  onPressed: () {
                    setState(() {
                      todoList.removeAt(index);
                      _saveTodoList(); 
                    });
                  },
                ),
              ),
            ),
            onDismissed: (direction) {
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          showDialog(
            context: context, 
            builder: (BuildContext context) {
              FocusScope.of(context).requestFocus(FocusNode());
              return AlertDialog(
                title: const Text('Add element'),
                content: TextField(
                  onChanged: (String value) {
                    _userToDo = value;
                  },
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (_userToDo != null) {
                        setState(() {
                          todoList.add(_userToDo!);
                          _saveTodoList();
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add'),
                  )
                ],
              );
            }
          );
        },
      child: const Icon(
        Icons.add_circle,
        color: Colors.white
      )),
    );
  }
}