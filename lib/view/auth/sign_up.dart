import 'package:team_task_manager/view/index.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  // SignUpContoller signUpContoller = Get.put(SignUpContoller());

  bool _showpass = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: mainColor,

        body: SizedBox(
          height: 1.sh,
          child: Padding(
            padding: EdgeInsets.all(16.0).r,
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(
                    child: Text(
                      "Your Information:",
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: touchesColor,
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),
                  SizedBox(
                    height: .30.sh,
                    width: 1.sw,
                    child: Image(image: AssetImage("images/add-account.png")),
                  ),

                  SizedBox(height: 20.h),
                  Card(
                    child: myTextField(
                      controller: _userNameController,
                      label: 'Full Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Card(
                    child: myTextField(
                      controller: _emailController,
                      label: 'Email',
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
                  SizedBox(height: 20.h),
                  Card(
                    child: myTextField(
                      obscure: _showpass,
                      controller: _passwordController,
                      label: 'password',
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
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SignInButton(
                    buttonType: ButtonType.mail,
                    btnText: '          Sign-up',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                          User? user = userCredential.user;

                          if (user != null) {
                            await user.sendEmailVerification();
                            // users collection

                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(user.uid)
                                .set({
                                  'user_name': _userNameController.text,
                                  'user_email': _emailController.text,
                                  'user_role': 'member',
                                  'profile_image': user.photoURL,
                                  'ownerId': user.uid,
                                  'fcm_token': '',
                                  'createdAt':
                                      "${DateTime.now().year}- ${DateTime.now().month}- ${DateTime.now().day}",
                                });

                            Get.defaultDialog(
                              title: "email verify was sent",
                              content: Text("check your inbox please"),
                            );
                            Get.offNamed('/wait');
                          } else {
                            Get.defaultDialog(
                              title: 'Sorry😊',
                              content: Text("Something Went Wrong"),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            Get.defaultDialog(
                              title: 'Error',
                              content: Text(
                                "This email is already registered.",
                              ),
                            );
                          } else if (e.code == 'invalid-email') {
                            Get.defaultDialog(
                              title: 'Error',
                              content: Text("The email address is not valid."),
                            );
                          } else if (e.code == 'weak-password') {
                            Get.defaultDialog(
                              title: 'Error',
                              content: Text("The password is too weak."),
                            );
                          } else {
                            Get.defaultDialog(
                              title: 'Error',
                              content: Text("Error: ${e.message}"),
                            );
                          }
                        }
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Have an account?"),
                      TextButton(
                        onPressed: () {
                          // Navigate to registration page
                          Get.offNamed('/login');
                          email.clear();
                          pass.clear();
                        },
                        child: Text(
                          ' Login',
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
      ),
    );
  }
}
