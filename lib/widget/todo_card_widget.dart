import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map todo;
  final Function(Map) navigateToEditPage;
  final Function(String) deleteTodo;
  const TodoCard({
    super.key,
    required this.index,
    required this.todo,
    required this.navigateToEditPage,
    required this.deleteTodo,
  });

  @override
  Widget build(BuildContext context) {
    final todoId = todo['_id'];
    return Card(
      child: ListTile(
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
      ),
    );
  }
}
