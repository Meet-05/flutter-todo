import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  Color? color;
  Function? onTap;
  int? index;
  int? selectedColor;
  ColorButton(
      {this.color, @required this.onTap, this.index, this.selectedColor});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: CircleBorder(),
      onPressed: () {
        onTap!();
      },
      child: CircleAvatar(
        radius: 20.0,
        backgroundColor: color,
        child: index == selectedColor
            ? Icon(
                Icons.check,
                color: Colors.black,
              )
            : null,
      ),
    );
  }
}
