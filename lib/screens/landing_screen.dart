import 'package:flutter/material.dart';
import 'task_home.dart';
import './progress_screen.dart';
import '../providers/google_signin.dart';
import 'package:provider/provider.dart';
import './add_task_screen.dart';
import '../constants.dart';

class LadningScreen extends StatefulWidget {
  const LadningScreen({Key? key}) : super(key: key);

  @override
  _LadningScreenState createState() => _LadningScreenState();
}

class _LadningScreenState extends State<LadningScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions = [HomeScreen(), ProgressScreen()];
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
      backgroundColor: kbackground,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTaskScreen()));
        },
      ),
      appBar: AppBar(
        backgroundColor: kbackground,
        elevation: 0,
        title: _selectedIndex == 0
            ? Text(
                "Home Screen",
                style: kFormText,
              )
            : Text(
                "Track Progress",
                style: kFormText,
              ),
        actions: [
          TextButton(
            onPressed: () async {
              await provider.logout();
            },
            child: Text(
              'SignOut',
              style: kFormText.copyWith(color: Colors.black38),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF03045E),
        unselectedItemColor: Colors.black26,
        iconSize: 40,
        onTap: _onItemTapped,
        elevation: 5,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.track_changes), label: 'Progress'),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
    );
  }
}
