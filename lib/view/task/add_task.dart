import 'package:team_task_manager/view/index.dart';

// Widget for adding a new task
class AddTask extends StatelessWidget {
  final String teamId; // ID of the team
  final String userId; // ID of the user

  AddTask({super.key, required this.teamId, required this.userId});

  // Controllers for text fields
  final TextEditingController taskTitle = TextEditingController();
  final TextEditingController taskDescription = TextEditingController();

  // Key for the form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Unfocus text fields when tapping outside
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Add Task")),
        body: Form(
          key: _formKey,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              // Task title input field
              Padding(
                padding: EdgeInsets.all(8.0).r,
                child: Card(
                  child: myTextField(
                    controller: taskTitle,
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
              // Task description input field
              Padding(
                padding: EdgeInsets.all(8.0).r,
                child: Card(
                  child: myTextField(
                    controller: taskDescription,
                    label: "Description",
                    maxLines: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // Add button
              Padding(
                padding: EdgeInsets.all(8.0).r,
                child: customButton(
                  onPressed: () async {
                    // Validate form fields
                    if (_formKey.currentState!.validate()) {
                      // Get input values
                      final title = taskTitle.text;
                      final description = taskDescription.text;

                      // Save task to Firestore under the user's tasks collection
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
                      // Close the add task screen
                      Get.back();
                      // Show success message
                      Get.snackbar("Task Added Succesfully", "");
                    }
                  },
                  buttonText: "Add",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
