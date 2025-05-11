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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: AppBar(
        foregroundColor: touchesColor,

        centerTitle: true,
        title: const Text('Teams', style: TextStyle(fontSize: 30)),
      ),

      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, usrSnapshot) {
          if (!usrSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(backgroundColor: thirdColor),
            );
          }
          final user = usrSnapshot.data!;
          return StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('teams')
                    .where('members_list', arrayContains: user.uid)
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(backgroundColor: mainColor),
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
                      child: ListTile(
                        title: Text("${teams[index]['title']}"),
                        subtitle: Text("${teams[index]['createdAt']}"),
                        trailing: IconButton(
                          onPressed: () {
                            // final String currentUser =
                            //     FirebaseAuth.instance.currentUser!.uid;

                            Get.defaultDialog(
                              title: "Alert",
                              content: Text("What you want to do??"),
                              textConfirm: 'Edit',
                              onConfirm: () {
                                // if (teams[index]['createdBy'] == currentUser) {
                                Get.to(
                                  EditTeam(
                                    id: teams[index].id,
                                    title: teams[index]['title'],
                                    describe: teams[index]['description'],
                                  ),
                                );
                                // } else {
                                Get.defaultDialog(
                                  title: "Sorry",
                                  content: Text(
                                    "Only Team Leader can Edit Team",
                                  ),
                                );
                                // }
                              },
                              cancel: ElevatedButton(
                                onPressed: () {
                                  // if (teams[index]['createdBy'] ==
                                  //     currentUser) {
                                  team
                                      .doc(teams[index].id)
                                      .delete()
                                      .then((value) => log("Team deleted"))
                                      .catchError(
                                        (error) =>
                                            log("Failed to add user: $error"),
                                      );
                                  // } else {
                                  Get.defaultDialog(
                                    title: "Sorry",
                                    content: Text(
                                      "Only Team Leader can Delete Team",
                                    ),
                                  );
                                  // }
                                },
                                child: Text("Delete"),
                              ),
                              textCancel: 'Delete',
                              onCancel: () {},
                            );
                          },

                          icon: Icon(Icons.more_vert),
                        ),
                        onTap: () {
                          Get.to(() => Members(teamID: teams[index].id));
                        },
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
