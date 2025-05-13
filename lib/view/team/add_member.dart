import 'package:team_task_manager/view/index.dart';

class AddMember extends StatelessWidget {
  final String teamId;
  AddMember({super.key, required this.teamId});
  final TextEditingController idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Member")),
      body: Padding(
        padding: EdgeInsets.all(16).r,
        child: Form(
          key: GlobalKey(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    label: Text("Enter User ID"),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              customButton(
                onPressed: () async {
                  final userId = idController.text.trim();
                  final userDoc =
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(userId)
                          .get();
                  if (!userDoc.exists) {
                    Get.defaultDialog(
                      title: "",
                      content: Text("User Not Found"),
                      onConfirm: Get.back,
                    );
                    return;
                  }
                  final current = FirebaseAuth.instance.currentUser!;
                  final memberAdder = FirebaseFirestore.instance
                      .collection('teams')
                      .doc(teamId);
                  await memberAdder.update({
                    'members_list': FieldValue.arrayUnion([idController.text]),
                  });
                  await FirebaseFirestore.instance
                      .collection('teams')
                      .doc(teamId)
                      .collection('members')
                      .doc(userId)
                      .set({
                        'members_name': userDoc['user_name'],
                        'member_email': userDoc['user_email'],
                        'member_profile': current.photoURL,
                        'role': 'member',
                      });
                  Get.back();
                },
                buttonText: "Add",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
