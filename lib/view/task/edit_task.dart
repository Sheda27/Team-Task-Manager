import 'package:team_task_manager/view/index.dart';

class EditTask extends StatefulWidget {
  final String teamId;
  final String userId;
  final String edtaskTitle;
  final String edtaskDescription;
  final String? taskId;
  const EditTask({
    super.key,
    required this.teamId,
    required this.userId,
    required this.edtaskTitle,
    required this.edtaskDescription,
    required this.taskId,
  });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  @override
  void initState() {
    _taskTitle.text = widget.edtaskTitle;
    _taskDescription.text = widget.edtaskDescription;
    super.initState();
  }

  final TextEditingController _taskTitle = TextEditingController();

  final TextEditingController _taskDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _taskTitle,
              decoration: InputDecoration(label: Text("Task Title")),
            ),
            TextField(
              controller: _taskDescription,
              decoration: InputDecoration(label: Text("Description")),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('teams')
                    .doc(widget.teamId)
                    .collection('members')
                    .doc(widget.userId)
                    .collection('tasks')
                    .doc(widget.taskId)
                    .set({
                      'task_title': _taskTitle.text,
                      'task_describe': _taskDescription.text,
                      'state': '',
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                Get.back();
              },
              child: Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
