import 'package:flutter/material.dart';

class OnBoardingData {
  String? title;
  String? description;
  String? path;
  Color? color;
  OnBoardingData({this.color, this.description, this.path, this.title});
}

List<OnBoardingData> onBoardingData = [
  OnBoardingData(
    title: 'Manage!',
    description: "Manage all your tasks effeceintly anf track the progress!",
    color: Color(0xffF9F9F9),
    path: 'assets/animation_1.json',
  ),
  OnBoardingData(
    title: "Work on time",
    description:
        "Sort all the tasks according to the calender, so that you never get late!",
    color: Color(0xffCDF0EA),
    path: 'assets/animation_5.json',
  ),
  OnBoardingData(
    title: "Get Started",
    description: "get started with the avaible and manage your tasks!",
    color: Color(0xffF7DBF0),
    path: 'assets/animation_2.json',
  ),
];
