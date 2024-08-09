import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fungor_api/fungor_api.dart';
import 'package:fungor_ui/src/task_editor.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final tasks = db.select(db.tasks).watch();
    
    return StreamBuilder(stream: tasks, builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
      if (snapshot.hasData) {
        return ListView(children: snapshot.data!.map<Widget>((task) => TaskListTile(task: task)).toList());
      } else {
        return ListView(children: const []);
      }
    });
  }
}

class TaskListTile extends StatelessWidget {
  const TaskListTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description),
      onTap: () {
        showTaskEditor(context, selectedTask: task);
      },
      leading: IconButton(icon: Icon(Icons.close), onPressed: () {
        (db.delete(db.tasks)..where((t) => t.id.equals(task.id))).go();
      }),
    );
  }
}