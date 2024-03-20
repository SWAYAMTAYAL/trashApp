import 'package:flutter/material.dart';
import 'package:trash_talk/consts/consts.dart';
Widget ourButtom({onpress, color, textColor,String? title}){
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: EdgeInsets.all(12)
    ),
      onPressed: onpress
      , child: title!.text.color(textColor).fontFamily(bold).make());

}