import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../constants.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  User? user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            // .collection('users/' + user.uid + '/notes/')
            .collection('users')
            .doc(user!.uid)
            .collection('task')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>?> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final tasks = snapshot.data!.docs;
          int completed = 0;
          tasks.forEach((element) {
            if (element['completed'] == true) {
              completed++;
            }
          });

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                percent: ((completed / tasks.length) * 100) / 1000,
                radius: 130.0,
                progressColor: ktabColor,
                animationDuration: 1200,
                lineWidth: 18,
                center: new Text(
                    "${((completed / tasks.length) * 100).toStringAsFixed(2)}",
                    style: kFormText.copyWith(fontSize: 32.0)),
              ),
              SizedBox(
                height: 40.0,
              ),
              TaskDetail(
                  text: "${completed} tasks completed", color: ktabColor),
              SizedBox(
                height: 20.0,
              ),
              TaskDetail(
                text: "${tasks.length - completed} tasks pending",
                color: Color(0xFFB8C7CB),
              )
            ],
          );
        },
      ),
    );
  }
}

class TaskDetail extends StatelessWidget {
  final String? text;
  final Color? color;
  TaskDetail({this.color, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(height: 20, width: 20, color: color!),
        SizedBox(
          width: 15.0,
        ),
        Text(text!, style: kFormText)
      ],
    );
  }
}
