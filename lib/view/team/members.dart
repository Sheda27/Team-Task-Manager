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

class _MembersState extends State<Members> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.teamName)),
      body: StreamBuilder(
        // Listen to real-time updates of team members
        stream:
            FirebaseFirestore.instance
                .collection('teams')
                .doc(widget.teamID)
                .collection('members')
                .snapshots(),
        builder: (context, streamshot) {
          if (streamshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while waiting for data
            return Center(
              child: CircularProgressIndicator(color: touchesColor),
            );
          }

          final members = streamshot.data!.docs;

          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              // Fetch user profile photo from Users collection
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
                      // Show empty text while loading user photo
                      return Text("");
                    }
                    // If user photo does not exist, show default avatar
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 30.r,
                          backgroundColor: mainColor,
                          backgroundImage: AssetImage(
                            'images/defult_profile.jpg',
                          ),
                        ),
                        title: Text(member['members_name'] ?? 'Unknown'),
                        subtitle: Text(member['role'] ?? 'no role'),
                        onTap: () {
                          // Navigate to member's task page
                          Get.to(
                            TasksPage(
                              teamId: widget.teamID,
                              memberId: member.id,
                              taskOwner:
                                  '${(member['members_name']) ?? 'Unknown'}',
                            ),
                          );
                        },
                        trailing: IconButton(
                          onPressed: () async {
                            // Only leader can remove members
                            if (FirebaseAuth.instance.currentUser!.uid ==
                                widget.leader) {
                              final memberAdder = FirebaseFirestore.instance
                                  .collection('teams')
                                  .doc(widget.teamID);
                              // Remove member from members_list array
                              await memberAdder.update({
                                'members_list': FieldValue.arrayRemove([
                                  members[index].id,
                                ]),
                              });
                              // Delete member document from members subcollection
                              await FirebaseFirestore.instance
                                  .collection('teams')
                                  .doc(widget.teamID)
                                  .collection('members')
                                  .doc(members[index].id)
                                  .delete()
                                  .then((value) => log("Team deleted"))
                                  .catchError(
                                    (error) =>
                                        log("Failed to add user: $error"),
                                  );
                            } else {
                              // Show dialog if not leader
                              Get.defaultDialog(
                                title: 'Sorry',
                                content: Text("Only Leader can Remove Members"),
                              );
                            }
                          },
                          icon: Icon(Icons.delete),
                        ),
                      );
                    }
                    // If user photo exists, display it
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
                        // Navigate to member's task page
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
                          // Only leader can remove members
                          if (FirebaseAuth.instance.currentUser!.uid ==
                              widget.leader) {
                            final memberAdder = FirebaseFirestore.instance
                                .collection('teams')
                                .doc(widget.teamID);
                            // Remove member from members_list array
                            await memberAdder.update({
                              'members_list': FieldValue.arrayRemove([
                                members[index].id,
                              ]),
                            });
                            // Delete member document from members subcollection
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
                            // Show dialog if not leader
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
          // Navigate to AddMember page
          Get.to(AddMember(teamId: widget.teamID));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
