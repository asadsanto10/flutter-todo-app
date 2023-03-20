import 'package:flutter/material.dart';
import 'package:todo_app_rest_api/pages/todos/add_todo.dart';
import 'package:todo_app_rest_api/routs/route.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: const Text('Add todo')),
    );
  }

  void navigateToAddPage() {
    // final route = MaterialPageRoute(
    //   builder: (context) => const AddTodo(),
    // );
    Navigator.pushNamed(context, MainRoute.addTodo);
  }
}
