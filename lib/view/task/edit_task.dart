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
      appBar: AppBar(title: Text("Edit Task")),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0).r,
              child: Card(
                child: TextFormField(
                  controller: _taskTitle,
                  decoration: InputDecoration(
                    label: Text("Task Title"),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0).r,
              child: Card(
                child: TextFormField(
                  controller: _taskDescription,
                  decoration: InputDecoration(
                    label: Text("Description"),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0).r,
              child: customButton(
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
                buttonText: 'Done',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
