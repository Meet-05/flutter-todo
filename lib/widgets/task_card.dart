import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/add_task_screen.dart';

class TaskCard extends StatelessWidget {
  Function? onTap;
  var snapshot;
  DateTime? createdAt;
  TaskCard({this.onTap, this.snapshot, this.createdAt});
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(snapshot['createdAt']),
        background: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          color: Colors.red,
          child: Icon(
            Icons.delete,
            size: 50.0,
          ),
          alignment: Alignment.centerRight,
        ),
        onDismissed: (direction) {
          print('wola');
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('task')
              .doc(snapshot['createdAt'].toString())
              .delete();
        },
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text('Do you want to permanantely delete this?'),
                    actions: [
                      TextButton(
                          child: Text('Yes'),
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          }),
                      TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          }),
                    ],
                  ));
        },
        child: GestureDetector(
          onLongPress: () {
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('task')
                .doc(snapshot['createdAt'].toString())
                .update({'completed': !snapshot['completed']});
            String message = snapshot['completed']
                ? "Task marked as incoomplete"
                : "Task marked as complete";
            final snackBar = SnackBar(content: Text(message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTaskScreen(
                          snapshot: snapshot,
                          selectedColor: snapshot['color'],
                        )));
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: colorMap[snapshot['color']]),
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            snapshot['title'],
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 90.0,
                        )
                      ]),
                  Text(
                    snapshot['content'],
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
              Positioned(
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Text(
                        '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}'),
                  ))
            ]),
          ),
        ));
  }
}
