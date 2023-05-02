
import 'package:flutter/material.dart';
import 'package:todo_app_api/services/todo_services.dart';
import 'add_ascreen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = true;
  List itmes = [];
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do App'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigaterToAddPage();
        },
        label: const Text('Add Task'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: itmes.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Item To Show',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            child: ListView.builder(
              itemCount: itmes.length,
              itemBuilder: (context, index) {
                final item = itmes[index] as Map;
                final id = item['_id'] as String;
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(item['title']),
                      subtitle: Text(item['description']),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'Edit') {
                            // open edit page
                            navigaterToEditPage(item);
                          } else {
                            if (value == 'Delete') {
                              // open edit delelte
                              deleteById(id);
                            }
                          }
                        },
                        itemBuilder: (context) {
                          return const [
                            PopupMenuItem(
                              value: 'Edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: 'Delete',
                              child: Text('Delete'),
                            ),
                          ];
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteById(String id) async {
    final isSucsess = await TodoServicse.deleteById(id);
    if (isSucsess) {
      final fliterd = itmes.where((element) => element['_id'] != id).toList();
      setState(() {
        itmes = fliterd;
      });
    } else {
      showErorMessage('Deleltion Faild');
    }
  }

  Future<void> navigaterToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDo(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  void navigaterToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => const AddToDo(),
    );
    Navigator.push(context, route);
  }

  Future<void> fetchTodo() async {
    final response = await TodoServicse.fetchTodo();
    if (response != null) {
      setState(() {
        itmes = response;
      });
    } else {
      showErorMessage('Something Went Wrong');
    }
    setState(() {
      isLoading = false;
    });
  }

  void showErorMessage(String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
