import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app_rest_api/pages/todos/add_todo.dart';
import 'package:todo_app_rest_api/routs/route.dart';
import 'package:http/http.dart' as http;

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List todoItem = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: getTodos,
          child: ListView.builder(
              itemCount: todoItem.length,
              itemBuilder: (context, index) {
                final todo = todoItem[index] as Map;
                final todoId = todo['_id'];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(todo['title']),
                  subtitle: Text(todo['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        // open delete page
                        navigateToEditPage(todo);
                      } else if (value == 'delete') {
                        // delete selected
                        deleteTodo(todoId);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete',
                          ),
                        )
                      ];
                    },
                  ),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: const Text('Add todo')),
    );
  }

  Future<void> navigateToAddPage() async {
    // final route = MaterialPageRoute(
    //   builder: (context) => const AddTodo(),
    // );
    await Navigator.pushNamed(context, MainRoute.addTodo);
    setState(() {
      isLoading = true;
    });
    getTodos();
  }

  // get todo list
  Future<void> getTodos() async {
    const url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;
      final todosList = jsonData['items'] as List;

      setState(() {
        todoItem = todosList;
      });
    } else {
      // error
      errorMessage('Todo remove faild');
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToEditPage(Map todos) {
    final route = MaterialPageRoute(
      builder: (context) => AddTodo(
        todo: todos,
      ),
    );
    Navigator.push(context, route);
  }

  Future<void> deleteTodo(String todoId) async {
    final url = 'http://api.nstack.in/v1/todos/$todoId';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filterTodos =
          todoItem.where((element) => element['_id'] != todoId).toList();
      setState(() {
        todoItem = filterTodos;
      });
    } else {
      // error
    }
  }

  void showSuccess(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void errorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
