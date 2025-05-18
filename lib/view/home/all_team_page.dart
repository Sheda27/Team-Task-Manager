import 'package:team_task_manager/view/index.dart';

// Main page widget for displaying all teams
class AllTeamsPage extends StatefulWidget {
  const AllTeamsPage({super.key});

  @override
  State<AllTeamsPage> createState() => _AllTeamsPageState();
}

class _AllTeamsPageState extends State<AllTeamsPage> {
  // Reference to the 'teams' collection in Firestore
  final CollectionReference team = FirebaseFirestore.instance.collection(
    'teams',
  );

  // Uncomment and use this function to get and update FCM token for the user
  // getToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   await FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .update({'fcm_token': token});
  //   log('$token');
  // }

  @override
  // Uncomment to initialize token fetching on widget init
  // void initState() {
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     getToken();
  //   }
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context), // App drawer
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Teams', style: TextStyle(fontSize: 30)),
      ),

      // Listen to authentication state changes
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while waiting for auth state
            return Center(
              child: CircularProgressIndicator(backgroundColor: thirdColor),
            );
          }
          // Listen to teams where the current user is a member
          return StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('teams')
                    .where(
                      'members_list',
                      arrayContains: userSnapshot.data?.uid,
                    )
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading indicator while waiting for teams data
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: touchesColor,
                  ),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                // Show message if no teams are found
                return Center(
                  child: SizedBox(
                    height: .2.sh,
                    width: .8.sw,
                    child: ListTile(
                      tileColor: touchesColor.withAlpha(0),
                      title: Text(
                        " Create a Team or more ",
                        style: TextStyle(
                          color: touchesColor.withAlpha(70),
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                );
              }
              final teams = snapshot.data!.docs;
              // Display list of teams
              return Padding(
                padding: const EdgeInsets.only(top: 3),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3).r,
                        child: ListTile(
                          title: Text("${teams[index]['title']}"),
                          subtitle: Text("${teams[index]['description']}"),
                          trailing: IconButton(
                            onPressed: () {
                              final String currentUser =
                                  FirebaseAuth.instance.currentUser!.uid;

                              // Show dialog for Edit/Delete options
                              Get.defaultDialog(
                                title: "",
                                content: Text("What you want to do??"),
                                textConfirm: 'Edit',
                                onConfirm: () {
                                  // Only team leader can edit
                                  if (teams[index]['createdBy'] ==
                                      currentUser) {
                                    Get.back();
                                    Get.to(
                                      EditTeam(
                                        id: teams[index].id,
                                        title: teams[index]['title'],
                                        describe: teams[index]['description'],
                                      ),
                                    );
                                  } else {
                                    Get.back();
                                    Get.defaultDialog(
                                      title: "Sorry",
                                      content: Text(
                                        "Only Team Leader can Edit Team",
                                      ),
                                    );
                                  }
                                },
                                cancel: ElevatedButton(
                                  onPressed: () {
                                    // Only team leader can delete
                                    if (teams[index]['createdBy'] ==
                                        currentUser) {
                                      Get.back();
                                      team
                                          .doc(teams[index].id)
                                          .delete()
                                          .then((value) => log("Team deleted"))
                                          .catchError(
                                            (error) => log(
                                              "Failed to add user: $error",
                                            ),
                                          );
                                    } else {
                                      Get.back();
                                      Get.defaultDialog(
                                        title: "Sorry",
                                        content: Text(
                                          "Only Team Leader can Delete Team",
                                        ),
                                      );
                                    }
                                  },
                                  child: Text("Delete"),
                                ),
                              );
                            },
                            icon: Icon(Icons.more_vert),
                          ),
                          // Navigate to Members page on tap
                          onTap: () {
                            Get.to(
                              () => Members(
                                teamID: teams[index].id,
                                teamName: teams[index]['title'],
                                leader: teams[index]['createdBy'],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),

      // Button to add a new team
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/add_team');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
