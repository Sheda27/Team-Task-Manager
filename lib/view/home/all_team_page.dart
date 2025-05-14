import 'package:team_task_manager/view/index.dart';

class AllTeamsPage extends StatefulWidget {
  const AllTeamsPage({super.key});

  @override
  State<AllTeamsPage> createState() => _AllTeamsPageState();
}

class _AllTeamsPageState extends State<AllTeamsPage> {
  final CollectionReference team = FirebaseFirestore.instance.collection(
    'teams',
  );
  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'fcm_token': token});
    log('$token');
  }

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      getToken();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Teams', style: TextStyle(fontSize: 30)),
      ),

      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(backgroundColor: thirdColor),
            );
          }
          final user = userSnapshot.data!;
          return StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('teams')
                    .where('members_list', arrayContains: user.uid)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: touchesColor,
                  ),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "Start Point",
                    style: TextStyle(
                      color: touchesColor.withAlpha(70),
                      fontSize: 30,
                    ),
                  ),
                );
              }
              final teams = snapshot.data!.docs;
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

                              Get.defaultDialog(
                                title: "Alert",
                                content: Text("What you want to do??"),
                                textConfirm: 'Edit',
                                onConfirm: () {
                                  if (teams[index]['createdBy'] ==
                                      currentUser) {
                                    Get.to(
                                      EditTeam(
                                        id: teams[index].id,
                                        title: teams[index]['title'],
                                        describe: teams[index]['description'],
                                      ),
                                    );
                                  } else {
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/add_team');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
