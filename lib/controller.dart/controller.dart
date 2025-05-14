import 'package:team_task_manager/view/index.dart';

class SignInController extends GetxController {
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final userCred = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    final user = userCred.user!;
    final userDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid);
    final docSnapsot = await userDoc.get();
    if (!docSnapsot.exists) {
      await userDoc.set({
        'user_name': user.displayName,
        'user_email': user.email,
        'user_role': 'member',
        'profile_image': user.photoURL,
        'ownerId': user.uid,
        'fcm_token': '',
        'creatdAt': FieldValue.serverTimestamp(),
      });
    }
    await Get.offNamed('/teams');
  }
}
