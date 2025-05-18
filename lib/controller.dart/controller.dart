import 'package:team_task_manager/view/index.dart';

// Controller for handling sign-in logic
class SignInController extends GetxController {
  // Sign in with email and password
  Future<UserCredential> signIn(String emailer, String passworder) async {
    final firebaseAuth = FirebaseAuth.instance;
    try {
      // Attempt to sign in with provided credentials
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: emailer, password: passworder);
      if (userCredential.user!.emailVerified) {
        Get.toNamed('teams');
      } else {
        sendEmail() {
          userCredential.user!.sendEmailVerification;
          Get.defaultDialog(
            title: 'We have sent you a verification email.',
            content: Text(" Please check your inbox"),
          );
        }

        Get.defaultDialog(
          title: 'Your E-mail is not verified\n please verify it ',
          content: customButton(
            onPressed: () {
              Get.back();
              sendEmail();
            },
            buttonText: 'send E-mail',
          ),
        );
      }
      return userCredential;
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      throw Exception(e.code);
    }
  }

  // Google sign-in method
  Future signInWithGoogle() async {
    // Trigger the Google authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // User cancelled the sign-in
      return;
    }
    // Obtain authentication details from Google
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a credential for Firebase authentication
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    final userCred = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    final user = userCred.user!;
    // Reference to the user's document in Firestore
    final userDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid);
    final docSnapsot = await userDoc.get();
    // If user document does not exist, create it
    if (!docSnapsot.exists) {
      await userDoc.set({
        'user_name': user.displayName,
        'user_email': user.email,
        'user_role': 'member',
        'profile_image': user.photoURL,
        'ownerId': user.uid,
        // 'fcm_token': '',
        'creatdAt': FieldValue.serverTimestamp(),
      });
    }
    // Navigate to the teams page after successful sign-in
    await Get.offNamed('/teams');
  }
}

// Controller for handling sign-up logic
// class SignUpContoller extends GetxController {
//   // Sign up with email and password
//   Future<UserCredential> signUp(String emailup, String passwordup) async {
//     final firebaseAuth = FirebaseAuth.instance;
//     try {
//       // Attempt to create a new user with provided credentials
//       UserCredential userCredential = await firebaseAuth
//           .createUserWithEmailAndPassword(email: emailup, password: passwordup);
//       // User? user = userCredential.user;

//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       // Handle specific sign-up errors and show dialogs
//       if (e.code == 'email-already-in-use') {
//         Get.defaultDialog(
//           title: 'Error',
//           content: Text("This email is already registered."),
//         );
//       } else if (e.code == 'invalid-email') {
//         Get.defaultDialog(
//           title: 'Error',
//           content: Text("The email address is not valid."),
//         );
//       } else if (e.code == 'weak-password') {
//         Get.defaultDialog(
//           title: 'Error',
//           content: Text("The password is too weak."),
//         );
//       } else {
//         Get.defaultDialog(title: 'Error', content: Text("Error: ${e.message}"));
//       }
//       throw Exception('Sign up failed: ${e.message}');
//     }
//   }
// }
