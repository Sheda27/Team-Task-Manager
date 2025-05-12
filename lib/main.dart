import 'package:team_task_manager/view/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.offNamed('/login');
        log('User is currently signed out!');
      } else {
        Get.offNamed('/teams');

        log('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' app demo',
      themeMode: ThemeMode.light,
      theme:
          AppTheme()
              .lightTheme, // Replace with your desired ThemeData configuration
      initialRoute:
          FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.emailVerified
              ? '/teams'
              : '/login',
      getPages: [
        GetPage(name: '/teams', page: () => AllTeamsPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/sign-up', page: () => SignUpPage()),
        GetPage(name: '/profile', page: () => Profile()),
        GetPage(name: '/add_team', page: () => AddTaskPage()),
        GetPage(name: '/wait', page: () => WaitingVerify()),
      ],
    );
  }
}
