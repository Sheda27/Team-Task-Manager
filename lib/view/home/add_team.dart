import 'package:team_task_manager/view/index.dart';

class AddTaskPage extends StatelessWidget {
  AddTaskPage({super.key});

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Function to create a new team in Firestore
  Future<void> createTeam() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final teamRef = FirebaseFirestore.instance.collection('teams').doc();

      // Set team data in Firestore
      await teamRef.set({
        'title': _nameController.text,
        'description': _descriptionController.text,
        'createdBy': user.uid,
        'members_list': FieldValue.arrayUnion([user.uid]),
        'members_name': user.displayName,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Add the creator as a member with leader role
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
    return GestureDetector(
      // Dismiss keyboard when tapping outside
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Add Team')),
        body: Padding(
          padding: EdgeInsets.all(16.0).r,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Team Name input
                Card(
                  child: myTextField(
                    controller: _nameController,
                    label: 'Team Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                // Team Description input
                Card(
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
                SizedBox(height: 16.h),
                // Add button
                customButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If form is valid, create the team
                      final title = _nameController.text;
                      final description = _descriptionController.text;

                      createTeam();
                      log('Task Added: $title, $description');

                      // Clear fields after submission
                      _nameController.clear();
                      _descriptionController.clear();
                      Get.offNamed('/teams');
                      // Show success message
                      Get.snackbar("", "Team added successfully!");
                    }
                  },
                  buttonText: 'Add',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
