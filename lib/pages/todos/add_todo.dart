import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app_rest_api/services/todo_service.dart';
import 'package:todo_app_rest_api/uitls/snack_bar.dart';

class AddTodo extends StatefulWidget {
  final Map? todo;
  const AddTodo({super.key, this.todo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titileController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titileController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          TextField(
            controller: titileController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            minLines: 5,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: isEdit ? updateTodoData : submitTodoData,
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(isEdit ? 'Update' : 'Submit')))
        ],
      ),
    );
  }

  Future<void> submitTodoData() async {
    final text = titileController.text;
    final description = descriptionController.text;
    final body = {
      "title": text,
      "description": description,
      "is_completed": false
    };

    final respose = await TodoService.addTodo(body);
    if (respose) {
      showSuccess(context, message: 'Todo added successfully');
      titileController.text = '';
      descriptionController.text = '';
    } else {
      errorMessage(context, message: 'Todo added failed');
    }
  }

  Future<void> updateTodoData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('you must provide a todo');
      return;
    }
    final todoId = todo['_id'];
    final text = titileController.text;
    final description = descriptionController.text;
    final body = {
      "title": text,
      "description": description,
      "is_completed": false
    };

    final respose = await TodoService.updateTodo(todoId, body);
    if (respose) {
      showSuccess(context, message: 'Todo Update successfully');
    } else {
      errorMessage(context, message: 'Todo Update failed');
    }
  }
}
