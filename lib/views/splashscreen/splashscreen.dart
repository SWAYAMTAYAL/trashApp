import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trash_talk/consts/consts.dart';
import 'package:trash_talk/widget_common/logo.dart';

import '../../consts/colors.dart';
import '../auth/login.dart';
import '../home.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key? key}) : super(key: key);

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  void changeScreen() {
    Future.delayed(Duration(seconds: 3), () {
      Get.to(() => const LoginScreen());
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for this widget
    ScreenUtil.init(context, designSize: Size(416, 896));

    return Scaffold(
      backgroundColor: backgroundcolor,
      body: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                icSplashBg,
                width: 300.w, // Use ScreenUtil to make width responsive
              ),
            ),
            applogoWidget(),
            Spacer(),
            credits.text
                .fontFamily(semibold)
                .color(whiteColor)
                .make(), // No need to adjust text size with ScreenUtil
          ],
        ),
      ),
    );
  }
}
