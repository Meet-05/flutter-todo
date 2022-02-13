import 'package:flutter/material.dart';
import '../models/on_boarding_model.dart';
import 'package:lottie/lottie.dart';
import '../providers/google_signin.dart';
import './google_sign_in.dart';
import 'package:provider/provider.dart';

class OnBoardWidget extends StatelessWidget {
  OnBoardingData? data;
  int? index;
  OnBoardWidget({this.data, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: data!.color,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: LottieBuilder.asset(
              data!.path!,
              height: index == 2 ? 400.0 : null,
            )),
            SizedBox(
              height: 22.0,
            ),
            Text(
              data!.title!,
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  wordSpacing: 1.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(data!.description!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                )),
            SizedBox(
              height: 20.0,
            ),
            if (index == 2)
              Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(10.0),
                child: SignupButton(
                  iconToShow: Icon(Icons.ac_unit),
                  text: 'Sign in With Google',
                ),
              ),
          ],
        ),
        Positioned(
          bottom: 20.0,
          child: Container(
              height: 6.0,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: onBoardingData.length,
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      width: index == i ? 40 : 20,
                      color: index == i ? Colors.black : Colors.black12);
                },
              )),
        )
      ]),
    );
  }
}
