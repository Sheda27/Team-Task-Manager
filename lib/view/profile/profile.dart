import 'package:team_task_manager/view/index.dart';

class Profile extends StatelessWidget {
  // Get the current user's UID from FirebaseAuth
  final String id = FirebaseAuth.instance.currentUser!.uid;

  // Fetch user data from Firestore
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
        // Fetch user data asynchronously
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while waiting for data
            return Center(
              child: CircularProgressIndicator(backgroundColor: touchesColor),
            );
          }
          if (!snapshot.hasData || snapshot.hasError) {
            // Show error message if data fetch fails
            return Center(child: Text("Error"));
          }
          final userData = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              // Display profile image with loading indicator
              FutureBuilder<String?>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(id)
                    .get()
                    .then((doc) => doc['profile_image'] as String?),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading indicator inside avatar
                    return CircleAvatar(
                      backgroundColor: touchesColor,
                      radius: 50.r,
                      child: CircularProgressIndicator(),
                    );
                  }
                  // Get photo URL from FirebaseAuth
                  final photoUrl = FirebaseAuth.instance.currentUser!.photoURL;
                  return GestureDetector(
                    onTap: () {
                      // Show enlarged profile image in dialog
                      Get.defaultDialog(
                        title: '',
                        content: Image(
                          image: NetworkImage(
                            photoUrl ?? 'https://example.com/default_image.jpg',
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          photoUrl == "" || photoUrl == null
                              ? AssetImage('images/defult_profile.jpg')
                                  as ImageProvider
                              : NetworkImage(photoUrl),
                      backgroundColor: touchesColor,
                      radius: 50.r,
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              // Button to copy user ID to clipboard
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
              // Display user name
              ListTile(title: Text(userData['user_name'])),
              SizedBox(height: 16.h),
              // Display user email
              ListTile(title: Text(userData['user_email'])),
            ],
          );
        },
      ),
    );
  }
}

// The following code is commented out. It shows how to pick and upload a profile image to Firebase Storage,
// then update the user's Firestore document with the image URL.

// Future<void> pickAndUploadImage() async {
//   final picker = ImagePicker();
//   final pickedImage = await picker.pickImage(source: ImageSource.gallery);

//   if (pickedImage == null) return;

//   File imageFile = File(pickedImage.path);
//   String uid = FirebaseAuth.instance.currentUser!.uid;
//   String fileName = 'profile_images/$uid.jpg';

//   // Upload the image to Firebase Storage
//   final ref = FirebaseStorage.instance.ref().child(fileName);
//   await ref.putFile(imageFile);

//   // Get the download URL of the uploaded image
//   final imageUrl = await ref.getDownloadURL();

//   // Save the image URL in Firestore
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
