import 'package:team_task_manager/view/index.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secoderyColor,
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: secoderyColor,
        elevation: 0,
      ),
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
                  "Your Informaition:",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: touchesColor,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Card(
                child: TextFormField(
                  style: TextStyle(color: touchesColor),
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: 'username',
                    labelStyle: TextStyle(color: touchesColor),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              SizedBox(height: 24),
              Card(
                child: TextFormField(
                  style: TextStyle(color: touchesColor),
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 24),
              Card(
                child: TextFormField(
                  style: TextStyle(color: touchesColor),
                  obscureText: true,
                  obscuringCharacter: '*',
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'password',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              SizedBox(height: 24),
              SignInButton(
                buttonType: ButtonType.mail,
                btnText: 'Sign-up',
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    Get.offNamed('/wait');
                    await FirebaseAuth.instance.currentUser!
                        .sendEmailVerification();
                    // users collection
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc()
                        .set({
                          'user_name': _userNameController.text,
                          'user_email': _emailController.text,
                          'user_role': 'member',
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                    Get.defaultDialog(
                      title: "email verify was sent",
                      content: Text("check your inbox please"),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      log('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      log('Wrong password provided for that user.');
                    }
                  }
                  //
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
                        color: mainColor,
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
