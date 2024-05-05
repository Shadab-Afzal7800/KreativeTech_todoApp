import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String id;
  String text;
  bool isDone;
  TodoModel({required this.id, required this.text, required this.isDone});
  Map<String, dynamic> toMap() {
    return {'id': id, 'text': text, 'isDone': isDone};
  }

  factory TodoModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TodoModel(
        id: data['id'], text: data["text"], isDone: data["isDone"]);
  }

  static addToFirestore(TodoModel todo) async {
    try {
      await FirebaseFirestore.instance
          .collection("todos")
          .doc(todo.id)
          .set(todo.toMap());
    } catch (ex) {
      log(ex.toString());
    }
  }

  static void deleteFromFirestore(String id) async {
    try {
      await FirebaseFirestore.instance.collection('todos').doc(id).delete();
    } catch (ex) {
      log(ex.toString());
    }
  }

  static Stream<List<TodoModel>> geteTodosFromFirestore() {
    return FirebaseFirestore.instance.collection('todos').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => TodoModel.fromDocument(doc)).toList());
  }
}
