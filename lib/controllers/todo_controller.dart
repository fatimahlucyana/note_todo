import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:note_todo/models/todo_model.dart';
import './../config/env.dart';
import 'dart:convert';

class TodoController extends GetxController {
  RxBool loading = false.obs;
  Rx<List<TodoModel>> todos = Rx<List<TodoModel>>([]);

  @override
  void onInit() {
    super.onInit();
    indexTodo();
  }

  Future indexTodo() async {
    try {
      todos.value.clear();
      loading.value = true;
      var response = await http.get(
        Uri.parse('${url}todos'),
        headers: {
          'Accept': 'Application/json',
        },
      );

      if (response.statusCode == 200) {
        loading.value = false;
        final content = json.decode(response.body)['todos'];
        for (var item in content) {
          todos.value.add(TodoModel.fromJson(item));
        }
      } else {
        loading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      loading.value = false;
      print(e.toString());
    }
  }

  Future updateTodo(id, text) async {
    try {
      var request = await http.put(Uri.parse('${url}todos/$id'), headers: {
        'Accept': 'Application/json',
      }, body: {
        text: text,
      });

      if (request.statusCode == 200) {
        print('Updated');
      } else {
        print(json.decode(request.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future storeTodo({required String textdata}) async {
    var data = {
      'text': textdata,
    };

    try {
      loading.value = true;
      var request = await http.post(
        Uri.parse('${url}todos/'),
        headers: {
          'Accept': 'Application/json',
        },
        body: data,
      );

      if (request.statusCode == 200) {
        loading.value = false;
        print('Added');
      } else {
        loading.value = false;
        print(json.decode(request.body));
      }
    } catch (e) {
      loading.value = false;
      print(e.toString());
    }
  }
}
