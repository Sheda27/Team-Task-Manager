import 'package:team_task_manager/view/index.dart';

class Profile extends StatelessWidget {
  final String id = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>> getUserData() async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(id).get();
    return documentSnapshot.data() as Map<String, dynamic>;
  }

  Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profiile")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(backgroundColor: touchesColor),
            );
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(child: Text("Error"));
          }
          final userData = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              CircleAvatar(backgroundColor: touchesColor, radius: 50),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: id));
                  Get.snackbar(
                    "Copied",
                    "User ID has been copied to clipboard",
                  );
                },
                child: Text("ID : $id"),
              ),
              SizedBox(height: 16),
              ListTile(title: Text(userData['user_name'])),
              SizedBox(height: 16),
              ListTile(title: Text(userData['user_email'])),
            ],
          );
        },
      ),
    );
  }
}
