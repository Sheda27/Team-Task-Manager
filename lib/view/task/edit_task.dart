import 'package:team_task_manager/view/index.dart';

// EditTask widget allows editing an existing task's title and description
class EditTask extends StatefulWidget {
  final String teamId; // ID of the team
  final String userId; // ID of the user
  final String edtaskTitle; // Existing task title
  final String edtaskDescription; // Existing task description
  final String? taskId; // ID of the task to edit

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
  // Controllers for text fields
  final TextEditingController _taskTitle = TextEditingController();
  final TextEditingController _taskDescription = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // Initialize controllers with existing task data
    _taskTitle.text = widget.edtaskTitle;
    _taskDescription.text = widget.edtaskDescription;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Dismiss keyboard when tapping outside input fields
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Edit Task")),
        body: Form(
          key: _formKey,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              // Task title input
              Padding(
                padding: EdgeInsets.all(8.0).r,
                child: Card(
                  child: myTextField(
                    controller: _taskTitle,
                    label: "Task Title",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // Task description input
              Padding(
                padding: EdgeInsets.all(8.0).r,
                child: Card(
                  child: myTextField(
                    controller: _taskDescription,
                    label: "Description",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    maxLines: 4,
                  ),
                ),
              ),
              // Done button to save changes
              Padding(
                padding: EdgeInsets.all(8.0).r,
                child: customButton(
                  onPressed: () async {
                    // Update task in Firestore with new values
                    if (_formKey.currentState!.validate()) {
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
                      // Go back to previous screen
                      Get.back();
                    }
                  },
                  buttonText: 'Done',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
