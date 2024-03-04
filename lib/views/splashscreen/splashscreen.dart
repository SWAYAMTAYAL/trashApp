
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trash_talk/consts/consts.dart';
import 'package:trash_talk/widget_common/logo.dart';

import '../../consts/colors.dart';
import '../auth/login.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key? key}) : super(key: key);

  @override

  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  changeScreen(){
    Future.delayed(Duration(seconds: 3),(){
      Get.to(()=> const LoginScreen());
    });
  }

  @override
  void initState(){
    changeScreen();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: backgroundcolor,
      body: Center(
        child:Column(
          children: [
            Align(
              alignment:Alignment.topLeft,
              child: Image.asset(icSplashBg,width: 300)),
            20.heightBox,
            applogoWidget(),
            Spacer(),
            credits.text.fontFamily(semibold).color(creme).make(),


          ],
        ),

      ),
    );
  }
}
