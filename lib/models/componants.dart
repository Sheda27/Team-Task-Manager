import 'package:team_task_manager/view/index.dart';

//drawer
Drawer buildDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: Colors.grey[900],
    // width: 0.8.sw,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.grey[700]),
          child: const Text(
            '------------',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        ListTile(
          tileColor: Color.fromRGBO(222, 166, 122, 0),

          leading: const Icon(Icons.note, color: Colors.white),
          title: Text(
            'HOME',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onTap: () {
            // Handle navigation to All Notes
            Get.toNamed('/');
            log("all notes------------------------------------------");
          },
        ),
        ListTile(
          tileColor: Color.fromRGBO(222, 166, 122, 0),
          leading: const Icon(Icons.category, color: Colors.white),
          title: Text(
            'profile',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onTap: () {
            // Handle navigation to Add Note
            Get.toNamed('/profile');
            log("add notes------------------------------------------");
          },
        ),
        ListTile(
          tileColor: Color.fromRGBO(222, 166, 122, 0),
          leading: const Icon(Icons.task_alt, color: Colors.white),
          title: Text(
            'To Do List',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onTap: () {
            // Handle navigation to Add Note
            Get.toNamed('/');
            log("add notes------------------------------------------");
          },
        ),

        ListTile(
          tileColor: Color.fromRGBO(222, 166, 122, 0),

          leading: const Icon(Icons.list, color: Colors.white),
          title: Text(
            'completed todo',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onTap: () {
            // Handle navigation to Settings
            Get.toNamed('/');
            log("completed todo------------------------------------------");
          },
        ),
        ListTile(
          tileColor: Color.fromRGBO(222, 166, 122, 0),

          leading: const Icon(Icons.exit_to_app, color: Colors.white),
          title: Text(
            'Sign-out',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onTap: () async {
            // Handle navigation to Settings
            await FirebaseAuth.instance.signOut();
            GoogleSignIn googleSignIn = GoogleSignIn();
            googleSignIn.disconnect();
            log("Signing out ------------------------------------------");
          },
        ),
      ],
    ),
  );
}
