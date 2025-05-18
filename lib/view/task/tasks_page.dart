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

// Main state class for the TasksPage
class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.taskOwner)),
      body: StreamBuilder(
        // Listen to real-time updates of tasks for a specific team member
        stream:
            FirebaseFirestore.instance
                .collection('teams')
                .doc(widget.teamId)
                .collection('members')
                .doc(widget.memberId)
                .collection('tasks')
                .snapshots(),
        builder: (context, snapshot) {
          // Show loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Show message if there are no tasks
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: SizedBox(
                height: .2.sh,
                width: .8.sw,
                child: ListTile(
                  tileColor: touchesColor.withAlpha(0),
                  title: Text(
                    "No Tasks For ${widget.taskOwner}",
                    style: TextStyle(
                      color: touchesColor.withAlpha(70),
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            );
          }
          final tasks = snapshot.data!.docs;

          // Build a list of tasks
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Padding(
                padding: EdgeInsets.only(top: 3).r,
                child: GestureDetector(
                  // Double tap to change task state
                  onDoubleTap: () {
                    Get.defaultDialog(
                      title: "Choose Task State",
                      content: Column(
                        children: [
                          // Each ListTile allows changing the task state
                          ListTile(
                            title: Text(notStartedYet),
                            onTap: () {
                              // Only the task owner can change the state
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
                    // Display task title and state
                    title: Text(task["task_title"]),
                    subtitle: Text("${task['state']}"),
                    trailing: IconButton(
                      // Show dialog for editing or deleting the task
                      onPressed: () {
                        Get.defaultDialog(
                          title: "",
                          content: Text("What you want to do??"),
                          textConfirm: 'Edit',
                          onConfirm: () {
                            // Navigate to EditTask page
                            Get.back();
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
                            // Delete the task from Firestore
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
                    // Show task description when expanded
                    children: [Text("${task['task_describe']}")],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Button to add a new task
        onPressed: () {
          Get.to(AddTask(teamId: widget.teamId, userId: widget.memberId));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Task state constants
const String notStartedYet = "Not Started Yet";
const String inProgress = "in Progress";
const String done = "Done";
const String pending = "Pending";
const String blocked = "Blocked";

// Current user ID
final current = FirebaseAuth.instance.currentUser!.uid;
