import 'package:team_task_manager/view/index.dart';

class AddTask extends StatelessWidget {
  final String teamId;
  final String userId;
  AddTask({super.key, required this.teamId, required this.userId});

  final TextEditingController taskTitle = TextEditingController();
  final TextEditingController taskDescription = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              child: TextFormField(
                controller: taskTitle,
                decoration: InputDecoration(
                  label: Text("Task Title"),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
            ),
            Card(
              child: TextFormField(
                controller: taskDescription,
                decoration: InputDecoration(
                  label: Text("Description"),
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ),
            customButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Handle task submission logic here
                  final title = taskTitle.text;
                  final description = taskDescription.text;

                  await FirebaseFirestore.instance
                      .collection('teams')
                      .doc(teamId)
                      .collection('members')
                      .doc(userId)
                      .collection('tasks')
                      .doc()
                      .set({
                        'task_title': title,
                        'task_describe': description,
                        'state': '',
                        'createdAt': DateTime.now(),
                      });
                  Get.back();
                }
              },
              buttonText: "Add",
            ),
          ],
        ),
      ),
    );
  }
}
