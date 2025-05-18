import 'package:team_task_manager/view/index.dart';

class AddMember extends StatelessWidget {
  final String teamId;
  AddMember({super.key, required this.teamId});
  final TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Unfocus text fields when tapping outside
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Add Member")),
        body: Padding(
          padding: EdgeInsets.all(16).r,
          child: Form(
            key: GlobalKey(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: myTextField(
                    controller: idController,
                    label: "Enter User ID",
                  ),
                ),
                SizedBox(height: 20.h),
                customButton(
                  onPressed: () async {
                    // Get the entered user ID
                    final userId = idController.text.trim();

                    // Check if the user exists in Firestore
                    final userDoc =
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(userId)
                            .get();
                    if (!userDoc.exists) {
                      // Show dialog if user not found
                      Get.defaultDialog(
                        title: "",
                        content: Text("User Not Found"),
                        onConfirm: Get.back,
                      );
                      return;
                    }

                    // Get current user info
                    final current = FirebaseAuth.instance.currentUser!;

                    // Reference to the team document
                    final memberAdder = FirebaseFirestore.instance
                        .collection('teams')
                        .doc(teamId);

                    // Add user ID to the team's members_list array
                    await memberAdder.update({
                      'members_list': FieldValue.arrayUnion([
                        idController.text,
                      ]),
                    });

                    // Add member details to the team's members subcollection
                    await FirebaseFirestore.instance
                        .collection('teams')
                        .doc(teamId)
                        .collection('members')
                        .doc(userId)
                        .set({
                          'members_name': userDoc['user_name'],
                          'member_email': userDoc['user_email'],
                          'member_profile': current.photoURL,
                          'member_Id': userDoc['ownerId'],
                          'role': 'member',
                        });

                    // Close the current screen
                    Get.back();

                    // Show a snackbar notification
                    Get.snackbar(
                      '${userDoc['user_name']} Added Succesfully',
                      "${userDoc['user_name']} is now A member",
                    );

                    // Log the addition
                    log("${userDoc['user_name']} added succesfully");
                  },
                  buttonText: "Add",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
