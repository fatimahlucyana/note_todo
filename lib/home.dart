import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './controllers/todo_controller.dart';
import './controllers/auth_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController _todoController = Get.put(TodoController());
    final TextEditingController _controller = TextEditingController();
    final AuthController _AuthController = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Note ToDo'),
        elevation: 0,
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('Apa kamu yakin ingin keluar?'),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Icon(Icons.cancel),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          ElevatedButton(
                            child: Icon(Icons.check_circle),
                            onPressed: () async {
                              await _AuthController.logout();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.logout)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        hintText: 'Ketikan tugasmu',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Obx(() {
                    return _todoController.loading.value
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              await _todoController.storeTodo(
                                textdata: _controller.text.trim(),
                              );
                              _controller.clear();
                              _todoController.indexTodo();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                            ),
                            child: Text('Simpan'),
                          );
                  }),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () {
                  return _todoController.loading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _todoController.todos.value.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.all(10.0),
                              width: double.infinity,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: ListTile(
                                title: Text(
                                  _todoController.todos.value[index].text
                                      .toString(),
                                ),
                                subtitle: Row(
                                  children: [
                                    Checkbox(
                                        value: _todoController.todos
                                                    .value[index].completed ==
                                                1
                                            ? true
                                            : false,
                                        onChanged: (value) async {
                                          await _todoController.updateTodo(
                                            _todoController
                                                .todos.value[index].id,
                                            _todoController
                                                .todos.value[index].text,
                                          );
                                          _todoController.indexTodo();
                                        }),
                                    Text(
                                      _todoController.todos.value[index]
                                                  .completed ==
                                              1
                                          ? 'Completed'
                                          : 'Not done',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
