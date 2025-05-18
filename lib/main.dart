import 'package:team_task_manager/view/index.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized before using plugins
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Start the app
  runApp(MyApp());
}

// Root widget of the application
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // Listen for authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // If user is signed out, navigate to login page
        Get.offNamed('/login');
        log('User is currently signed out!');
      } else {
        // If user`s email is verified, navigate to teams page
        if (user.emailVerified) {
          Get.offNamed('/teams');
        } else {
          Get.offNamed('/login');
          log("Your email dosen`t verified , please verify it");
        }

        log('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Design size for responsive UI
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder to wrap app with GetMaterialApp
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false, // Hide debug banner
          title: 'TTM',
          themeMode: ThemeMode.light,
          theme: AppTheme().lightTheme, // Custom light theme
          // Set initial route based on authentication and email verification
          initialRoute:
              FirebaseAuth.instance.currentUser == null ||
                      !FirebaseAuth.instance.currentUser!.emailVerified
                  ? '/login'
                  : '/teams',
          // Define app routes
          getPages: [
            GetPage(name: '/teams', page: () => AllTeamsPage()),
            GetPage(name: '/login', page: () => LoginPage()),
            GetPage(name: '/sign-up', page: () => SignUpPage()),
            GetPage(name: '/profile', page: () => Profile()),
            GetPage(name: '/add_team', page: () => AddTaskPage()),
            GetPage(name: '/wait', page: () => WaitingVerify()),
          ],
        );
      },
    );
  }
}
