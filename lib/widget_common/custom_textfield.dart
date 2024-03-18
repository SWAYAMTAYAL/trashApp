import 'package:trash_talk/consts/consts.dart';
Widget customTextField({String? title, String? hint,controller}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(backgroundcolor).fontFamily(semibold).size(16).make(),
      5.heightBox,
      TextField(
        controller: controller,
        decoration: InputDecoration(

          hintText: hint,
          helperStyle: TextStyle(
            fontFamily: semibold,
            color: textfieldGrey,

          ),
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: redColor))
        )),
      5.heightBox,



    ],
  );
}