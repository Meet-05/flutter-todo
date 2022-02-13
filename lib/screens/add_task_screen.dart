import '../widgets/color_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';

class AddTaskScreen extends StatefulWidget {
  var snapshot;
  int? selectedColor;
  AddTaskScreen({this.snapshot, this.selectedColor});
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _form = GlobalKey<FormState>();
  String? title;
  String? content;
  List<int> ColorList = [0, 1, 2];
  int? selectedColor;

  DateTime date = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedColor = widget.selectedColor != null ? widget.selectedColor! : 0;
      date = widget.snapshot != null
          ? widget.snapshot['scheduledAt'].toDate()
          : DateTime.now();
    });
  }

  void onFormSubmitted() {
    User user = FirebaseAuth.instance.currentUser!;
    print("hye");
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      print(title);
      print(title);
      print(selectedColor);
      print(date.day);
      if (widget.snapshot == null) {
        Timestamp createdAt = Timestamp.now();
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('task')
            .doc(createdAt.toString())
            .set({
          'createdAt': createdAt,
          'content': content,
          'title': title,
          'color': selectedColor,
          'scheduledAt': Timestamp.fromDate(date),
          'completed': false
        });
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('task')
            .doc(widget.snapshot['createdAt'].toString())
            .update({
          'createdAt': widget.snapshot['createdAt'],
          'content': content,
          'title': title,
          'color': selectedColor,
          'scheduledAt': Timestamp.fromDate(date),
          'completed': widget.snapshot['completed']
        });
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackground,
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Title',
                  style: kFormText,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  initialValue:
                      widget.snapshot != null ? widget.snapshot['title'] : null,
                  decoration: kInputDecoration.copyWith(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Title is empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    title = value;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Content',
                  style: kFormText,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  maxLines: 3,
                  initialValue: widget.snapshot != null
                      ? widget.snapshot['content']
                      : null,
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Enter the TaskContent',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Content is empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    content = value;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Select the Date',
                  style: kFormText,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      onPressed: () async {
                        final newDate = await showDatePicker(
                          context: context,
                          initialDate: widget.snapshot != null
                              ? widget.snapshot['scheduledAt'].toDate()
                              : date,
                          firstDate: DateTime(DateTime.now().year - 5),
                          lastDate: DateTime(DateTime.now().year + 5),
                        );

                        if (newDate == null) return;

                        setState(() => date = newDate);
                      },
                      icon: Icon(Icons.date_range),
                    ),
                    Text(
                      "${date.day} / ${date.month} / ${date.year}",
                      style: kFormText,
                    )
                  ]),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Note Color',
                  style: kFormText,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorButton(
                      color: Colors.blue,
                      selectedColor: selectedColor,
                      index: 0,
                      onTap: () {
                        setState(() {
                          selectedColor = 0;
                        });
                      },
                    ),
                    ColorButton(
                      color: Colors.redAccent[100],
                      selectedColor: selectedColor,
                      index: 1,
                      onTap: () {
                        setState(() {
                          selectedColor = 1;
                        });
                      },
                    ),
                    ColorButton(
                      color: Colors.yellow,
                      selectedColor: selectedColor,
                      index: 2,
                      onTap: () {
                        setState(() {
                          selectedColor = 2;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                MaterialButton(
                    padding: EdgeInsets.all(22.0),
                    color: Colors.blueAccent[100],
                    onPressed: () {
                      onFormSubmitted();
                    },
                    child: widget.snapshot != null
                        ? Text(
                            'Edit Task',
                            style: kFormText,
                          )
                        : Text(
                            'Create Task',
                            style: kFormText.copyWith(fontSize: 22),
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
