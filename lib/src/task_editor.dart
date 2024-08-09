import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:fungor_api/fungor_api.dart';
import 'package:provider/provider.dart';

showTaskEditor(BuildContext context, {Task? selectedTask}) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => TaskEditor(linkedTask: selectedTask),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))));
}

class TaskEditor extends StatefulWidget {
  const TaskEditor({super.key, this.linkedTask});

  final Task? linkedTask;

  @override
  State<TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  final titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final localLinkedTask = widget.linkedTask;

    titleController.text = localLinkedTask?.title ?? '';

    return Container(
        height: 200,
        margin: const EdgeInsets.all(20),
        child: Center(
            child: Column(children: [
          TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Task title",
                suffixIcon: IconButton(
                    onPressed: () {
                      if (localLinkedTask != null) {
                        //(db.update(db.tasks)..where((task) => task.id.equals(localLinkedTask.id))).write(TasksCompanion(title: d.Value(titleController.text)));
                        db.update(db.tasks).replace(TasksCompanion.insert(
                            id: d.Value(localLinkedTask.id),
                            title: titleController.text));
                        Navigator.pop(context);
                      } else {
                        db.into(db.tasks).insert(
                            TasksCompanion.insert(title: titleController.text));
                        // clear the form
                        titleController.clear();
                      }
                    },
                    icon: Icon(localLinkedTask != null
                        ? Icons.check
                        : Icons.arrow_upward)),
              )),
          ElevatedButton(
            child: const Text('Close BottomSheet'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ])));
  }
}
