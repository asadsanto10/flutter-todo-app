import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  const AddTodo({super.key, required Map todo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titileController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
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
          ElevatedButton(onPressed: submitTodoData, child: const Text('Submit'))
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
    const url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);

    final respose = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    // print(respose.statusCode);
    // print(respose.body);
    if (respose.statusCode == 201) {
      showSuccess('Todo added successfully');
      titileController.text = '';
      descriptionController.text = '';
    } else {
      errorMessage('Todo added failed');
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
