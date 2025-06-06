import 'package:team_task_manager/view/index.dart';

class WaitingVerify extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final user;
  const WaitingVerify({super.key, this.user});

  @override
  State<WaitingVerify> createState() => _WaitingVerifyState();
}

class _WaitingVerifyState extends State<WaitingVerify> {
  Timer? _timer;
  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      var user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        timer.cancel();
        Future.delayed(Duration(milliseconds: 500), () {
          Get.offAllNamed('teams');
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secoderyColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("please verify your email")),
          CircularProgressIndicator(color: touchesColor),
        ],
      ),
    );
  }
}
