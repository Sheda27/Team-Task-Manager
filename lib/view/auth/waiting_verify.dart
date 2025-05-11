import 'package:team_task_manager/view/index.dart';

final _user = FirebaseAuth.instance.currentUser!;

class WaitingVerify extends StatefulWidget {
  const WaitingVerify({super.key});

  @override
  State<WaitingVerify> createState() => _WaitingVerifyState();
}

class _WaitingVerifyState extends State<WaitingVerify> {
  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      await _user.reload();
      if (_user.emailVerified) {
        timer.cancel();
        Get.offNamed('/teams');
      } else {
        Get.defaultDialog(
          title: "please verify your email",
          onConfirm: () async {
            await FirebaseAuth.instance.currentUser!.sendEmailVerification();
            timer;
            Get.back();
          },
        );
      }
    });
    return Scaffold(
      backgroundColor: secoderyColor,
      body: Center(
        child: Column(
          children: [CircularProgressIndicator(), Text("Waiting to verify")],
        ),
      ),
    );
  }
}
