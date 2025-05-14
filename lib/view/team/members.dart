import 'package:team_task_manager/view/index.dart';

class Members extends StatefulWidget {
  final String teamID;
  final String teamName;
  final String leader;
  const Members({
    super.key,
    required this.teamID,
    required this.teamName,
    required this.leader,
  });

  @override
  State<Members> createState() => _MembersState();
}
// final CollectionReference members

class _MembersState extends State<Members> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.teamName)),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('teams')
                .doc(widget.teamID)
                .collection('members')
                .snapshots(),
        builder: (context, streamshot) {
          if (streamshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: touchesColor),
            );
          }

          final members = streamshot.data!.docs;
          // final photoUrl = FirebaseAuth.instance.currentUser!.photoURL;

          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              // final photo= FirebaseAuth.instance.currentUser!.photoURL;
              final userPhotoRef =
                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(member['member_Id'])
                      .get();

              return Padding(
                padding: EdgeInsets.only(top: 3.r),
                child: FutureBuilder<DocumentSnapshot>(
                  future: userPhotoRef,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("");
                    }
                    // if there is no Photo
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 30.r,
                          backgroundColor: mainColor,
                          backgroundImage: AssetImage(
                            'images/defult_profile.jpg',
                          ),
                        ),
                        title: member['members_name'],
                        subtitle: member['role'],
                      );
                    }
                    final userPhoto =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: mainColor,
                        radius: 30.r,
                        backgroundImage: NetworkImage(
                          userPhoto['profile_image'] ?? '',
                        ),
                      ),
                      title: Text(member['members_name'] ?? 'Unknown'),
                      subtitle: Text(member['role'] ?? "no role"),
                      onTap: () {
                        //navigate to member task page
                        Get.to(
                          TasksPage(
                            teamId: widget.teamID,
                            memberId: member.id,
                            taskOwner: member['members_name'],
                          ),
                        );
                      },
                      trailing: IconButton(
                        onPressed: () async {
                          if (FirebaseAuth.instance.currentUser!.uid ==
                              widget.leader) {
                            final memberAdder = FirebaseFirestore.instance
                                .collection('teams')
                                .doc(widget.teamID);
                            await memberAdder.update({
                              'members_list': FieldValue.arrayRemove([
                                members[index].id,
                              ]),
                            });
                            await FirebaseFirestore.instance
                                .collection('teams')
                                .doc(widget.teamID)
                                .collection('members')
                                .doc(members[index].id)
                                .delete()
                                .then((value) => log("Team deleted"))
                                .catchError(
                                  (error) => log("Failed to add user: $error"),
                                );
                          } else {
                            Get.defaultDialog(
                              title: 'Sorry',
                              content: Text("Only Leader can Remove Members"),
                            );
                          }
                        },
                        icon: Icon(Icons.delete),
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
          Get.to(AddMember(teamId: widget.teamID));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
