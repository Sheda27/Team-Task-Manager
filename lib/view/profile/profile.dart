// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// void getUserData() {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     // Name, email address, and profile photo URL
//     final name = user.displayName;
//     final email = user.email;
//     // final photoUrl = user.photoURL;

//     // Check if user's email is verified
//     // final emailVerified = user.emailVerified;

//     // The user's ID, unique to the Firebase project. Do NOT use this value to
//     // authenticate with your backend server, if you have one. Use
//     // User.getIdToken() instead.
//     final uid = user.uid;
//   }
// }

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                // backgroundImage: AssetImage(
                //   'assets/images/profile_placeholder.png',
                // ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("name", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              'Email:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('johndoe@example.com', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              'Phone:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('+123 456 7890', style: TextStyle(fontSize: 16)),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add logout functionality here
                },
                child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
