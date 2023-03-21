import 'package:flutter/material.dart';
import 'package:todo_app_rest_api/pages/todos/add_todo.dart';
import 'package:todo_app_rest_api/routs/route.dart';

import 'package:todo_app_rest_api/services/todo_service.dart';
import 'package:todo_app_rest_api/uitls/snack_bar.dart';
import 'package:todo_app_rest_api/widget/todo_card_widget.dart';

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
        // ignore: sort_child_properties_last
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: getTodos,
          child: Visibility(
            visible: todoItem.isNotEmpty,
            replacement: const Center(child: Text('No todo items')),
            child: ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: todoItem.length,
                itemBuilder: (context, index) {
                  final todo = todoItem[index] as Map;
                  // final todoId = todo['_id'];
                  return TodoCard(
                      index: index,
                      todo: todo,
                      navigateToEditPage: navigateToEditPage,
                      deleteTodo: deleteTodo);
                }),
          ),
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
    final response = await TodoService.getTodos();
    // print(response.statusCode);
    // print(response.body);
    if (response != null) {
      setState(() {
        todoItem = response;
      });
    } else {
      // error
      // ignore: use_build_context_synchronously
      errorMessage(context, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> navigateToEditPage(Map todos) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodo(
        todo: todos,
      ),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    getTodos();
  }

  Future<void> deleteTodo(String todoId) async {
    final response = await TodoService.deleteTodo(todoId);
    if (response) {
      final filterTodos =
          todoItem.where((element) => element['_id'] != todoId).toList();
      setState(() {
        todoItem = filterTodos;
      });
    } else {
      // error
    }
  }
}
