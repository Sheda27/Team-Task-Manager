import 'package:team_task_manager/view/index.dart';

// Builds the navigation drawer for the app
Drawer buildDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: secoderyColor,
    // width: 0.8.sw, // Optional: set drawer width
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        // Drawer header with user info
        DrawerHeader(
          decoration: BoxDecoration(color: mainColor),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User avatar
              CircleAvatar(
                radius: 30.r,
                backgroundImage:
                    FirebaseAuth.instance.currentUser!.photoURL != null
                        ? NetworkImage(
                          FirebaseAuth.instance.currentUser!.photoURL
                              .toString(),
                        )
                        : AssetImage('images/defult_profile.jpg'),
              ),
              SizedBox(width: 5.w),
              // User display name
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
        // Home navigation tile
        ListTile(
          tileColor: Color.fromRGBO(222, 166, 122, 0),
          leading: Icon(Icons.home, color: Colors.white),
          title: Text(
            'HOME',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onTap: () {
            // Close drawer and log action
            Get.back();
            log("all notes------------------------------------------");
          },
        ),
        // Profile navigation tile
        ListTile(
          tileColor: Color.fromRGBO(222, 166, 122, 0),
          leading: Icon(Icons.person, color: Colors.white),
          title: Text(
            'profile',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onTap: () {
            // Navigate to profile page and log action
            Get.toNamed('/profile');
            log("add notes------------------------------------------");
          },
        ),
        // Sign-out tile
        ListTile(
          tileColor: Color.fromRGBO(222, 166, 122, 0),
          leading: Icon(Icons.exit_to_app, color: Colors.white),
          title: Text(
            'Sign-out',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onTap: () async {
            // Sign out from Firebase and Google, then log action
            await FirebaseAuth.instance.signOut();
            GoogleSignIn googleSignIn = GoogleSignIn();
            googleSignIn.disconnect();
            Get.offAllNamed('/login');
            log("Signing out ------------------------------------------");
          },
        ),
      ],
    ),
  );
}
