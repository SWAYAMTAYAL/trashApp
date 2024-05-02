 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import '../controller/map_controller.dart';

InputDecoration searchBoxInputDecoration(
MapProvider provider, {
      required String hintText,
    }) =>
InputDecoration(
filled: true,
fillColor: Colors.white,
contentPadding: EdgeInsets.symmetric(horizontal: 3.w),
prefixIcon: Padding(
padding: EdgeInsets.only(left: 3.w),
child: SvgPicture.asset(height: 20.h,
'assets/images/current_location_icon.svg',
fit: BoxFit.scaleDown,
),
),
suffixIcon: SizedBox(
width: 40.w,
child: Row(
crossAxisAlignment: CrossAxisAlignment.center,
children: <Widget>[
SvgPicture.asset(
'assets/images/black_location_icon.svg',
fit: BoxFit.scaleDown,
),
SizedBox(
height: 3.h,
width: 20.w,
child: Marquee(
text:
//read<MapProvider>().getHomeAddressText() ??
'No Address Found!',
velocity: 40.0,
pauseAfterRound: const Duration(seconds: 1),
blankSpace: 30.0,
style: TextStyle(
color: Color(0xFF555555),
fontSize: 11.sp,
fontWeight: FontWeight.w600,
),
),
),
],
),
),
suffixIconConstraints: BoxConstraints(minWidth: 11.w),
prefixIconConstraints: BoxConstraints(minWidth: 11.w),
hintText: hintText,
hintStyle: TextStyle(
color: Color(0xFF868686),
fontSize: 13.sp,
fontWeight: FontWeight.w500,
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(5.h),
borderSide: BorderSide.none,
),
);
