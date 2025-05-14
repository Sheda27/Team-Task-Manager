import 'package:team_task_manager/view/index.dart';

//drawer
Drawer buildDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: secoderyColor,
    // width: 0.8.sw,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: mainColor),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser!.photoURL!,
                ),
              ),
              SizedBox(width: 5.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${FirebaseAuth.instance.currentUser!.displayName}",
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ListTile(
          tileColor: Color.fromRGBO(222, 166, 122, 0),

          leading: Icon(Icons.home, color: Colors.white),
          title: Text(
            'HOME',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onTap: () {
            // Handle navigation to All Notes
            Get.back();
            log("all notes------------------------------------------");
          },
        ),
        ListTile(
          tileColor: Color.fromRGBO(222, 166, 122, 0),
          leading: Icon(Icons.person, color: Colors.white),
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
          leading: const Icon(Icons.settings, color: Colors.white),
          title: Text(
            'Settings',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onTap: () {
            // Handle navigation to Add Note
            Get.toNamed('/');
            log("add notes------------------------------------------");
          },
        ),

        // ListTile(
        //   tileColor: Color.fromRGBO(222, 166, 122, 0),

        //   leading: const Icon(Icons.list, color: Colors.white),
        //   title: Text(
        //     'completed todo',
        //     style: TextStyle(color: Colors.white, fontSize: 18),
        //   ),
        //   onTap: () {
        //     // Handle navigation to Settings
        //     Get.toNamed('/');
        //     log("completed todo------------------------------------------");
        //   },
        // ),
        ListTile(
          tileColor: Color.fromRGBO(222, 166, 122, 0),

          leading: Icon(Icons.exit_to_app, color: Colors.white),
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
