import 'package:team_task_manager/view/index.dart';

class EditTeam extends StatefulWidget {
  final String id;
  final String title;
  final String describe;

  const EditTeam({
    super.key,
    required this.id,
    required this.title,
    required this.describe,
  });

  @override
  State<EditTeam> createState() => _EditTeamState();
}

class _EditTeamState extends State<EditTeam> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final CollectionReference tasks = FirebaseFirestore.instance.collection(
    'teams',
  );

  Future<void> updateUser() {
    // Call the user's CollectionReference to add a new user
    final user = FirebaseAuth.instance.currentUser!;
    return tasks
        .doc(widget.id)
        .set({
          'title': _titleController.text, // John Doe
          'description': _descriptionController.text,
          'createdBy': user.uid,
          'createdAt': DateTime.now(),
        })
        .then((value) => log("User Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  @override
  void initState() {
    _titleController.text = widget.title;
    _descriptionController.text = widget.describe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                // key: _formKey,
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                // key: _formKey,
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Task Description',
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle task submission logic here
                    final title = _titleController.text;
                    final description = _descriptionController.text;

                    // Example: Print to console

                    updateUser();
                    log('Task Added: $title, $description');

                    // Clear fields after submission
                    _titleController.clear();
                    _descriptionController.clear();
                    Get.offNamed('/teams');
                    // Optionally, navigate back or show a success message
                    Get.snackbar(
                      "",
                      "Task added successfully!",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
