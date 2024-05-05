import 'package:flutter/material.dart';
import '../models/todo_list_model.dart';

class ToDo extends StatelessWidget {
  final TodoModel todo;
  final Function(TodoModel) onTodoChanged;
  final Function(String) onDelete;
  const ToDo(
      {super.key,
      required this.todo,
      required this.onDelete,
      required this.onTodoChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        onTap: () => onTodoChanged(todo),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone == true ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.blue,
        ),
        title: Text(
          todo.text,
          style: TextStyle(
              decoration:
                  todo.isDone == true ? TextDecoration.lineThrough : null),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            onDelete(todo.id);
          },
        ),
      ),
    );
  }
}
