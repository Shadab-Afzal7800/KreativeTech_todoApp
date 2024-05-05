import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/todo_list_model.dart';
import '../widgets/todo_items_tile.dart';

class MyHome extends StatefulWidget {
  MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late Stream<List<TodoModel>> _todoStream;
  final _addToDoController = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    _todoStream = TodoModel.geteTodosFromFirestore();
  }

  void showAlertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add Task"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: TextField(
                  controller: _addToDoController,
                  decoration: InputDecoration(
                      hintText: 'Add a new todo item',
                      suffixIconColor: Colors.blue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel")),
                  ElevatedButton(
                      onPressed: () {
                        if (_addToDoController.text.isEmpty) {
                          return null;
                        } else {
                          _addTodoItem(_addToDoController.text);
                          Navigator.pop(context);
                        }
                      },
                      child: Text("ADD")),
                ],
              )
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 229, 229, 229),
        body: SafeArea(
          child: Column(
            children: [
              searchBar(),
              Expanded(
                child: StreamBuilder<List<TodoModel>>(
                  stream: _todoStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else {
                      List<TodoModel> todosList = snapshot.data ?? [];
                      return Stack(
                        children: [
                          ListView(
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 50, bottom: 20),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    'ToDos',
                                    style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              for (TodoModel todoo in todosList.reversed)
                                if (todoo.text
                                    .toLowerCase()
                                    .contains(_search.toLowerCase()))
                                  ToDo(
                                    todo: todoo,
                                    onDelete: _deleteTodoItem,
                                    onTodoChanged: _handleTodoChange,
                                  ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: CupertinoButton(
                                      onPressed: () {
                                        showAlertDialog();
                                      },
                                      child: Text("Add new task"),
                                      color: Colors.blue,
                                    )),
                              )),
                            ]),
                          ),
                        ],
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleTodoChange(TodoModel todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      TodoModel.addToFirestore(todo);
    });
  }

  void _deleteTodoItem(String id) {
    setState(() {
      TodoModel.deleteFromFirestore(id);
    });
  }

  void _addTodoItem(String todo) {
    if (!_addToDoController.text.isEmpty) {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      TodoModel newTodo = TodoModel(id: id, text: todo, isDone: false);
      TodoModel.addToFirestore(newTodo);
    }

    _addToDoController.clear();
    FocusScope.of(context).unfocus();
  }

  Padding searchBar() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: TextField(
          onChanged: (value) {
            setState(() {
              _search = value;
            });
          },
          decoration: InputDecoration(
              // contentPadding: EdgeInsets.all(0),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              hintText: 'Find',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIconConstraints:
                  BoxConstraints(maxHeight: 20, minWidth: 25)),
        ),
      ),
    );
  }

  AppBar appBar_build() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color.fromARGB(255, 229, 229, 229),
      title: CircleAvatar(
        backgroundImage: AssetImage('assets/images/iconImage.jpg'),
      ),
    );
  }
}
