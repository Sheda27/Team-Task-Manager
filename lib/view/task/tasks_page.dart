import 'package:team_task_manager/view/index.dart';

class TasksPage extends StatefulWidget {
  final String teamId;
  final String memberId;
  const TasksPage({super.key, required this.teamId, required this.memberId});

  @override
  State<TasksPage> createState() => _TasksPageState();
}
// final CollectionReference =FirebaseFirestore.instance.collection('tasks').doc()

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task")),
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
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final tasks = snapshot.data!.docs;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Padding(
                padding: const EdgeInsets.only(top: 3),
                child: ListTile(
                  title: Text(task["task_title"]),
                  subtitle: Text("${task['createdAt']}"),
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
