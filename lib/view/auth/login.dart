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
      'profile_image': user.photoURL,
      'ownerId': user.uid,
      'fcm_token': '',
      'creatdAt': FieldValue.serverTimestamp(),
    });
  }
  await Get.offNamed('/teams');
}

TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();
bool _showpass = true;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: mainColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  child: Text(
                    "Welcome...",
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: touchesColor,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  height: .3.sh,
                  width: 1.sw,
                  child: Image(image: AssetImage("images/sign-in.png")),
                ),

                SizedBox(height: 30.h),
                Card(
                  child: TextFormField(
                    style: TextStyle(color: touchesColor),
                    controller: email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your E-mail';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                Card(
                  child: TextFormField(
                    style: TextStyle(color: touchesColor),

                    controller: pass,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      labelText: 'Password',
                      contentPadding: EdgeInsets.fromLTRB(8, 5, 5, 5).r,
                      border: OutlineInputBorder(),
                      suffix: IconButton(
                        padding: EdgeInsets.all(0).r,
                        iconSize: 20.sp,
                        onPressed: () {
                          setState(() {
                            _showpass = !_showpass;
                          });
                        },
                        icon: Icon(
                          _showpass ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: _showpass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your Password';
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 30.h,
                  child: TextButton(
                    onPressed: () {
                      if (email.text != "") {
                        Get.defaultDialog(
                          title: 'Press The Button to Get Reset E-mail',
                          content: customButton(
                            onPressed: () async {
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: email.text);
                                Get.snackbar(
                                  "Reset E-mail was sent.. ",
                                  "Please Check Your Inbox",
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  Get.snackbar(
                                    "User Not Found",

                                    "No user found for that email.",
                                  );
                                  log(
                                    '===============================No user found for that email.',
                                  );
                                }
                              }
                            },

                            buttonText: 'Send ',
                          ),
                        );
                      } else {
                        Get.defaultDialog(
                          title: "Warning",
                          content: Text("Please Enter your E-mail First"),
                        );
                      }
                    },

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forget Your Password?",
                          style: TextStyle(color: touchesColor),
                        ),
                      ],
                    ),
                  ),
                ),
                SignInButton(
                  buttonType: ButtonType.mail,
                  onPressed: () async {
                    // Handle login logic here

                    if (_formKey.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email.text,
                          password: pass.text,
                        );
                        Get.offNamed('/teams');
                        email.clear();
                        pass.clear();
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          Get.snackbar(
                            "User Not Found ",
                            "Please Register Try to Register",
                          );
                          log('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          Get.snackbar(
                            "User Not Found ",
                            "Please Try to Register",
                          );
                          log('Wrong password provided for that user.');
                        }
                      }
                    }
                  },
                ),
                SizedBox(height: 16.h),

                SignInButton(
                  buttonType: ButtonType.google,
                  onPressed: () async {
                    signInWithGoogle();
                  },
                ),
                SizedBox(height: 16.h),
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
      ),
    );
  }
}
