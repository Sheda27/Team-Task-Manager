import 'package:team_task_manager/view/index.dart';

// EditTeam widget allows editing an existing team's details
class EditTeam extends StatefulWidget {
  final String id; // Team document ID in Firestore
  final String title; // Initial team title
  final String describe; // Initial team description

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
  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Key for the form validation
  final GlobalKey<FormState> _formKey = GlobalKey();

  // Reference to the 'teams' collection in Firestore
  final CollectionReference tasks = FirebaseFirestore.instance.collection(
    'teams',
  );

  // Updates the team document in Firestore
  Future<void> updateUser() {
    final user = FirebaseAuth.instance.currentUser!;
    return tasks
        .doc(widget.id)
        .set({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'createdBy': user.uid,
          'createdAt': DateTime.now(),
        })
        .then((value) => log("User Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  @override
  void initState() {
    // Initialize text fields with existing team data
    _titleController.text = widget.title;
    _descriptionController.text = widget.describe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Add Team')),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Team name input field
              Padding(
                padding: EdgeInsets.all(8.0).r,
                child: Card(
                  child: myTextField(
                    controller: _titleController,
                    label: 'Team Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // Team description input field
              Padding(
                padding: EdgeInsets.all(8.0).r,
                child: Card(
                  child: myTextField(
                    controller: _descriptionController,
                    label: 'Team Description',
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
              // Submit button
              Padding(
                padding: EdgeInsets.all(8.0).r,
                child: customButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // If form is valid, update the team
                      final title = _titleController.text;
                      final description = _descriptionController.text;

                      updateUser();
                      log('Task Added: $title, $description');

                      // Clear fields after submission
                      _titleController.clear();
                      _descriptionController.clear();
                      Get.offNamed('/teams'); // Navigate to teams page

                      // Show success message
                      Get.snackbar(
                        "",
                        "Task added successfully!",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  buttonText: 'Save',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
