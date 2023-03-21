import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService {
  static Future<List?> getTodos() async {
    const url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;
      final todosList = jsonData['items'] as List;
      return todosList;
    } else {
      return null;
    }
  }

  static Future<bool> addTodo(Map body) async {
    const url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);

    final respose = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return respose.statusCode == 201;
  }

  static Future<bool> updateTodo(String todoId, Map body) async {
    final url = 'http://api.nstack.in/v1/todos/$todoId';
    final uri = Uri.parse(url);

    final respose = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return respose.statusCode == 200;
  }

  static Future<bool> deleteTodo(String todoId) async {
    final url = 'http://api.nstack.in/v1/todos/$todoId';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }
}
