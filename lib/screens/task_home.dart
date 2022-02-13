import 'package:flutter/material.dart';
import '../providers/google_signin.dart';
import 'package:provider/provider.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:todo_app/constants.dart';

import './progress_screen.dart';
import '../widgets/tasklist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  DateTime _selectedValue = DateTime.now();
  User? user = FirebaseAuth.instance.currentUser;
  DatePickerController _controller = DatePickerController();
  TabController? _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // Do Something here
      _controller.animateToDate(DateTime.now());
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GoogleSignInProvider>(context);
    List<Widget> _widgetOptions = [HomeScreen(), ProgressScreen()];
    return Container(
      color: kbackground,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 88,
            child: DatePicker(
              DateTime(2022, 1, 1),
              width: 60.0,
              controller: _controller,
              initialSelectedDate: DateTime.now(),
              selectionColor: Color(0xFF03045E),
              selectedTextColor: Colors.white,
              onDateChange: (date) {
                // New date selected
                setState(() {
                  _selectedValue = date;
                  print("selected date is ${_selectedValue.day}");
                });
              },
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: ktabColor,
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              tabs: [
                Tab(
                  child: Text(
                    'Completed',
                    // style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                    child: Text(
                  'InCompleted',
                  // style: TextStyle(color: Colors.black)
                )),
              ]),
          Expanded(
              child: TabBarView(
            children: [
              TaskList(
                  user: user, selectedValue: _selectedValue, completed: true),
              TaskList(
                  user: user, selectedValue: _selectedValue, completed: false)
            ],
            controller: _tabController,
          )
              // TaskList(user: user, selectedValue: _selectedValue),
              )
        ],
      ),
    );
  }
}
