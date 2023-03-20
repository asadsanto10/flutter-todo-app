import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
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
          const TextField(
            decoration: InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Description',
            ),
            minLines: 5,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: submitTodoData, child: const Text('SUbmit'))
        ],
      ),
    );
  }

  void submitTodoData() {}
}
