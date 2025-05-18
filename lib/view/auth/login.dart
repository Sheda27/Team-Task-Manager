import 'package:team_task_manager/view/index.dart';

// Initialize controllers for sign-in and text fields
SignInController signInController = Get.put(SignInController());
TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();
bool _showpass = true; // Controls password visibility

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Dismiss keyboard when tapping outside input fields
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
                // Welcome text
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
                // Sign-in image
                SizedBox(
                  height: .3.sh,
                  width: 1.sw,
                  child: Image(image: AssetImage("images/sign-in.png")),
                ),
                SizedBox(height: 30.h),
                // Email input field
                Card(
                  child: myTextField(
                    controller: email,
                    label: 'E-mail',
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
                // Password input field with show/hide toggle
                Card(
                  child: myTextField(
                    controller: pass,
                    label: 'Password',
                    suffix: IconButton(
                      padding: EdgeInsets.all(0).r,
                      iconSize: 20.sp,
                      onPressed: () {
                        setState(() {
                          _showpass = !_showpass; // Toggle password visibility
                        });
                      },
                      icon: Icon(
                        _showpass ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),

                    obscure: _showpass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your Password';
                      }
                      return null;
                    },
                  ),
                ),
                // Forgot password button
                SizedBox(
                  height: 30.h,
                  child: TextButton(
                    onPressed: () {
                      if (email.text != "") {
                        // Show dialog to send password reset email
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
                        // Warn if email is empty
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
                // Email sign-in button
                SignInButton(
                  buttonType: ButtonType.mail,
                  onPressed: () async {
                    // Validate form and attempt sign-in
                    if (_formKey.currentState!.validate()) {
                      try {
                        UserCredential userCredential = await signInController
                            .signIn(email.text, pass.text);
                        if (userCredential.user!.emailVerified) {}
                      } catch (e) {
                        Get.snackbar("", e.toString());
                        log('$e');
                      }
                    }
                  },
                ),
                SizedBox(height: 16.h),
                // Google sign-in button
                SignInButton(
                  buttonType: ButtonType.google,
                  onPressed: () async {
                    await signInController.signInWithGoogle();
                  },
                ),
                SizedBox(height: 16.h),
                // Sign up navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        // Navigate to registration page and clear fields
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
