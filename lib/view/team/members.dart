import 'package:team_task_manager/view/index.dart';

class Members extends StatefulWidget {
  final String teamID;
  const Members({super.key, required this.teamID});

  @override
  State<Members> createState() => _MembersState();
}
// final CollectionReference members

class _MembersState extends State<Members> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Members')),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('teams')
                .doc(widget.teamID)
                .collection('members')
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final members = snapshot.data!.docs;
          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return Padding(
                padding: const EdgeInsets.only(top: 3),
                child: ListTile(
                  title: Text(member['members_name'] ?? 'Unknown'),
                  subtitle: Text(member['role'] ?? "no role"),
                  onTap: () {
                    //navigate to member task page
                    Get.to(
                      TasksPage(teamId: widget.teamID, memberId: member.id),
                    );
                  },
                  trailing: IconButton(
                    onPressed: () async {
                      // if (member['role'] == 'member') {
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
                      // } else {
                      Get.defaultDialog(
                        title: 'Sorry',
                        content: Text("Only Leader can Remove Members"),
                      );
                      // }
                    },
                    icon: Icon(Icons.delete),
                  ),
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
