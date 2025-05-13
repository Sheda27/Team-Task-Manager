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
      appBar: AppBar(title: Text("Profile")),
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
              SizedBox(height: 16.h),
              FutureBuilder<String?>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(id)
                    .get()
                    .then((doc) => doc['profile_image'] as String?),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircleAvatar(
                      backgroundColor: touchesColor,
                      radius: 50.r,
                      child: CircularProgressIndicator(),
                    );
                  }
                  final photoUrl = snapshot.data;
                  return GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                        title: '',
                        content:
                            photoUrl == null || photoUrl.isEmpty
                                ? Image.asset('images/defult_profile.jpg')
                                : Image.network(photoUrl),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          photoUrl != "" || photoUrl != null
                              ? NetworkImage(photoUrl ?? '')
                              : AssetImage('images/defult_profile.jpg')
                                  as ImageProvider,
                      backgroundColor: touchesColor,
                      radius: 50.r,
                    ),
                  );
                },
              ),
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
              SizedBox(height: 16.h),
              ListTile(title: Text(userData['user_name'])),
              SizedBox(height: 16.h),
              ListTile(title: Text(userData['user_email'])),
            ],
          );
        },
      ),
    );
  }
}

// Future<void> pickAndUploadImage() async {
//   final picker = ImagePicker();
//   final pickedImage = await picker.pickImage(source: ImageSource.gallery);

//   if (pickedImage == null) return;

//   File imageFile = File(pickedImage.path);
//   String uid = FirebaseAuth.instance.currentUser!.uid;
//   String fileName = 'profile_images/$uid.jpg';

//   // رفع الصورة
//   final ref = FirebaseStorage.instance.ref().child(fileName);
//   await ref.putFile(imageFile);

//   // جلب رابط الصورة
//   final imageUrl = await ref.getDownloadURL();

//   // حفظ الرابط في Firestore
//   await FirebaseFirestore.instance.collection('Users').doc(uid).update({
//     'profile_image': imageUrl,
//   });
// }

// Widget profileImage(String? photoUrl) {
//   return CircleAvatar(
//     radius: 40,
//     backgroundImage:
//         photoUrl != null
//             ? NetworkImage(photoUrl)
//             : AssetImage('images/default_profile.jpg') as ImageProvider,
//   );
// }
