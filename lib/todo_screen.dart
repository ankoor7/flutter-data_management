import 'package:bloc_and_sembast/bloc/todo_bloc.dart';
import 'package:bloc_and_sembast/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data/todo.dart';

class TodoScreen extends StatelessWidget {
  final Todo todo;
  final bool isNew;
  final TodoBloc bloc;
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtCompleteBy = TextEditingController();
  final TextEditingController txtPriority = TextEditingController();

  TodoScreen(this.todo, this.isNew) : bloc = TodoBloc();

  Future save() async {
    todo.name = txtName.text;
    todo.description = txtDescription.text;
    todo.completeBy = txtCompleteBy.text;
    todo.priority = int.tryParse(txtPriority.text);
    if (isNew) {
      bloc.todosInsertSink.add(todo);
    } else {
      bloc.todosUpdateSink.add(todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    txtName.text = todo.name;
    txtDescription.text = todo.description;
    txtCompleteBy.text = todo.completeBy;
    txtPriority.text = todo.priority.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            inputField('Name', txtName),
            inputField('Description', txtDescription),
            inputField('Complete by', txtCompleteBy, keyboardType: TextInputType.datetime),
            inputField('Priority', txtPriority, keyboardType: TextInputType.number),
            Padding(
                padding: edgeInsets,
                child: MaterialButton(
                  color: Colors.green,
                  child: Text('Save'),
                  onPressed: () {
                    save().then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                        (Route<dynamic> route) => false));
                  },
                ),
            )
          ],
        ),
      ),
    );
  }

  final edgeInsets = EdgeInsets.all(20);
  Widget inputField(String hint, TextEditingController controller, { TextInputType keyboardType = TextInputType.text }) =>
      Padding(
        padding: edgeInsets,
        child: TextField(
          controller: controller,
          decoration:
          InputDecoration(border: InputBorder.none, hintText: hint),
          keyboardType: keyboardType,
        ),

      );
}
