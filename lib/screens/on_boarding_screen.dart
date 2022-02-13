import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../providers/google_signin.dart';
import '../widgets/google_sign_in.dart';
import '../widgets/on_boarding_widget.dart';
import '../models/on_boarding_model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
        body: PageView.builder(
      itemCount: onBoardingData.length,
      itemBuilder: (BuildContext context, int index) {
        OnBoardingData currentSlide = onBoardingData[index];
        return OnBoardWidget(
          index: index,
          data: onBoardingData[index],
        );
      },
    ));
  }
}
