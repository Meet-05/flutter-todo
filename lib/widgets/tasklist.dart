import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './task_card.dart';
import '../screens/loading_screen.dart';
import '../constants.dart';

class TaskList extends StatelessWidget {
  const TaskList(
      {Key? key,
      required this.user,
      required DateTime selectedValue,
      required bool completed})
      : _selectedValue = selectedValue,
        _completed = completed,
        super(key: key);

  final User? user;
  final DateTime _selectedValue;
  final bool _completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
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
            return LoadingScreen();
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>?> tasks =
              snapshot.data!.docs;
          List<dynamic> filtered = [];
          tasks.forEach((element) {
            DateTime schdeuledDate = element!['scheduledAt'].toDate();
            if (schdeuledDate.day == _selectedValue.day &&
                schdeuledDate.month == _selectedValue.month &&
                schdeuledDate.year == _selectedValue.year) {
              if (_completed) {
                if (element['completed']) {
                  filtered.add(element);
                }
              } else {
                if (!element['completed']) {
                  filtered.add(element);
                }
              }
            }
          });

          if (filtered.isNotEmpty) {
            return ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  snapshot: filtered[index],
                  createdAt: filtered[index]['createdAt'].toDate(),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                  'No tasks Schdeuled ,Add one by clicking on the + button',
                  textAlign: TextAlign.center,
                  style: kFormText),
            );
          }
        },
      ),
    );
  }
}
