import 'package:team_task_manager/view/index.dart';

Future signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) {
    return;
  }
  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  Get.offNamed('/teams');
  // Once signed in, return the UserCredential
  final userCred = await FirebaseAuth.instance.signInWithCredential(credential);
  final user = userCred.user!;
  final userDoc = FirebaseFirestore.instance.collection('Users').doc(user.uid);
  final docSnapsot = await userDoc.get();
  if (!docSnapsot.exists) {
    await userDoc.set({
      'user_name': user.displayName,
      'user_email': user.email,
      'user_role': 'member',
      'ownerId': user.uid,
      'creatdAt': FieldValue.serverTimestamp(),
    });
  }
}

TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      // appBar: AppBar(
      //   title: Text('Login'),
      //   backgroundColor: mai,
      //   elevation: 0,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                child: Text(
                  "Welcome...",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: touchesColor,
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                width: 200,
                child: Image(image: AssetImage("images/sign-in.png")),
              ),

              SizedBox(height: 30),
              Card(
                child: TextField(
                  style: TextStyle(color: touchesColor),
                  controller: email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: TextField(
                  style: TextStyle(color: touchesColor),
                  controller: pass,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 24),
              Flexible(
                child: SignInButton(
                  buttonType: ButtonType.mail,
                  onPressed: () async {
                    // Handle login logic here
                    if (FirebaseAuth.instance.currentUser!.emailVerified) {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email.text,
                          password: pass.text,
                        );
                        Get.offNamed('/teams');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          log('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          log('Wrong password provided for that user.');
                        }
                      }
                    }
                  },
                ),
              ),
              Flexible(
                child: SignInButton(
                  buttonType: ButtonType.google,
                  onPressed: () async {
                    signInWithGoogle();
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      // Navigate to registration page
                      Get.offNamed('/sign-up');
                      email.clear();
                      pass.clear();
                    },
                    child: Text(
                      ' Sign up',
                      style: TextStyle(
                        color: Colors.grey[50],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
