import 'package:team_task_manager/view/index.dart';

class TasksPage extends StatefulWidget {
  final String teamId;
  final String memberId;
  final String taskOwner;
  const TasksPage({
    super.key,
    required this.teamId,
    required this.memberId,
    required this.taskOwner,
  });

  @override
  State<TasksPage> createState() => _TasksPageState();
}
// final CollectionReference =FirebaseFirestore.instance.collection('tasks').doc()

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.taskOwner)),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('teams')
                .doc(widget.teamId)
                .collection('members')
                .doc(widget.memberId)
                .collection('tasks')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Padding(
                padding: EdgeInsets.only(top: 3).r,
                child: GestureDetector(
                  onDoubleTap: () {
                    Get.defaultDialog(
                      title: "Choose Task State",
                      content: Column(
                        children: [
                          ListTile(
                            title: Text(notStartedYet),
                            onTap: () {
                              if (current == widget.memberId) {
                                FirebaseFirestore.instance
                                    .collection('teams')
                                    .doc(widget.teamId)
                                    .collection('members')
                                    .doc(widget.memberId)
                                    .collection('tasks')
                                    .doc(task.id)
                                    .update({'state': notStartedYet});
                                Get.back();
                              } else {
                                Get.defaultDialog(
                                  title: "Sorry",
                                  content: Text(
                                    "Only ${widget.taskOwner} can set the tasks state",
                                  ),
                                );
                              }
                            },
                          ),
                          ListTile(
                            title: Text(inProgress),
                            onTap: () {
                              if (current == widget.memberId) {
                                FirebaseFirestore.instance
                                    .collection('teams')
                                    .doc(widget.teamId)
                                    .collection('members')
                                    .doc(widget.memberId)
                                    .collection('tasks')
                                    .doc(task.id)
                                    .update({'state': inProgress});
                                Get.back();
                              } else {
                                Get.defaultDialog(
                                  title: "Sorry",
                                  content: Text(
                                    "Only ${widget.taskOwner} can set the tasks state",
                                  ),
                                );
                              }
                            },
                          ),
                          ListTile(
                            title: Text(done),
                            onTap: () {
                              if (current == widget.memberId) {
                                FirebaseFirestore.instance
                                    .collection('teams')
                                    .doc(widget.teamId)
                                    .collection('members')
                                    .doc(widget.memberId)
                                    .collection('tasks')
                                    .doc(task.id)
                                    .update({'state': done});
                                Get.back();
                              } else {
                                Get.defaultDialog(
                                  title: "Sorry",
                                  content: Text(
                                    "Only ${widget.taskOwner} can set the tasks state",
                                  ),
                                );
                              }
                            },
                          ),
                          ListTile(
                            title: Text(pending),
                            onTap: () {
                              if (current == widget.memberId) {
                                FirebaseFirestore.instance
                                    .collection('teams')
                                    .doc(widget.teamId)
                                    .collection('members')
                                    .doc(widget.memberId)
                                    .collection('tasks')
                                    .doc(task.id)
                                    .update({'state': pending});
                                Get.back();
                              } else {
                                Get.defaultDialog(
                                  title: "Sorry",
                                  content: Text(
                                    "Only ${widget.taskOwner} can set the tasks state",
                                  ),
                                );
                              }
                            },
                          ),
                          ListTile(
                            title: Text(blocked),
                            onTap: () {
                              if (current == widget.memberId) {
                                FirebaseFirestore.instance
                                    .collection('teams')
                                    .doc(widget.teamId)
                                    .collection('members')
                                    .doc(widget.memberId)
                                    .collection('tasks')
                                    .doc(task.id)
                                    .update({'state': blocked});
                                Get.back();
                              } else {
                                Get.defaultDialog(
                                  title: "Sorry",
                                  content: Text(
                                    "Only ${widget.taskOwner} can set the tasks state",
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: ExpansionTile(
                    title: Text(task["task_title"]),
                    subtitle: Text("${task['state']}"),
                    trailing: IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Alert",
                          content: Text("What you want to do??"),
                          textConfirm: 'Edit',
                          onConfirm: () {
                            Get.to(
                              EditTask(
                                teamId: widget.teamId,
                                userId: widget.memberId,
                                edtaskTitle: task["task_title"],
                                edtaskDescription: task["task_describe"],
                                taskId: tasks[index].id,
                              ),
                            );
                          },
                          textCancel: 'Delete',
                          onCancel: () {
                            FirebaseFirestore.instance
                                .collection('teams')
                                .doc(widget.teamId)
                                .collection('members')
                                .doc(widget.memberId)
                                .collection('tasks')
                                .doc(task.id)
                                .delete()
                                .then((value) => log("Team deleted"))
                                .catchError(
                                  (error) => log("Failed to add user: $error"),
                                );
                          },
                        );
                      },
                      icon: Icon(Icons.more_vert),
                    ),

                    children: [Text("${task['task_describe']}")],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddTask(teamId: widget.teamId, userId: widget.memberId));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

const String notStartedYet = "Not Started Yet";
const String inProgress = "in Progress";
const String done = "Done";
const String pending = "Pending";
const String blocked = "Blocked";
final current = FirebaseAuth.instance.currentUser!.uid;
