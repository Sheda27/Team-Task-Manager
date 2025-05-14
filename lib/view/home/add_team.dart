import 'package:team_task_manager/view/index.dart';

class AddTaskPage extends StatelessWidget {
  AddTaskPage({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> createTeam() async {
    // Call the user's CollectionReference to add a new user
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final teamRef = FirebaseFirestore.instance.collection('teams').doc();

      await teamRef.set({
        'title': _nameController.text,
        'description': _descriptionController.text, // John Doe
        'createdBy': user.uid, // Stokes and Sons
        'members_list': FieldValue.arrayUnion([user.uid]),
        'members_name': user.displayName,

        'createdAt': FieldValue.serverTimestamp(), // Stokes and Sons
      });

      await teamRef
          .collection("members")
          .doc(user.uid)
          .set({
            'role': 'leader',
            'joinedAt': FieldValue.serverTimestamp(),
            'member_Id': user.uid,
            'member_profile': user.photoURL,
            'members_name': user.displayName,
          })
          .then((value) => log("team Added"));
    } catch (error) {
      log("Failed to add user: $error");
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Team')),
      body: Padding(
        padding: EdgeInsets.all(16.0).r,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: TextFormField(
                  style: TextStyle(color: touchesColor),
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Team Name',
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
              SizedBox(height: 16.h),
              Card(
                child: TextFormField(
                  style: TextStyle(color: touchesColor),
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Team Description',
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
              SizedBox(height: 16.h),
              customButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle task submission logic here
                    final title = _nameController.text;
                    final description = _descriptionController.text;

                    // Example: Print to console

                    createTeam();
                    log('Task Added: $title, $description');

                    // Clear fields after submission
                    _nameController.clear();
                    _descriptionController.clear();
                    Get.offNamed('/teams');
                    // Optionally, navigate back or show a success message
                    Get.snackbar("", "Team added successfully!");
                  }
                },
                buttonText: 'Add',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
