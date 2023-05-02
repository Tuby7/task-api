import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class AddToDo extends StatefulWidget {
  final Map? todo;
  const AddToDo({super.key, this.todo});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TextEditingController titleControler = TextEditingController();
  TextEditingController descriptionControler = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleControler.text = title;
      descriptionControler.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add To Do'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleControler,
              decoration: const InputDecoration(
                hintText: ('Add Task'),
                hintStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: descriptionControler,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              //minLines: 8,
              decoration: const InputDecoration(
                hintText: ('Description'),
                hintStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              isEdit ? update() : submit();
            },
            child: Text(isEdit ? 'Update' : 'Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> update() async {
    final todo = widget.todo;
    if (todo == null) {
      print('you cant update couse error');
      return;
    }
    final id = todo['_id'];
    final title = titleControler.text;
    final description = descriptionControler.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final url = 'http://api.nstack.in/v1/todos$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      showSuccessMessage('Update Succsess');
    } else {
      showSuccessMessage('Update Faild');
    }
  }

  Future<void> submit() async {
    final title = titleControler.text;
    final description = descriptionControler.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      print('Creation Scsess');
      showSuccessMessage('Succsess');
    } else {
      print('Faild');

      print(response);
    }
  }

  void showSuccessMessage(String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
