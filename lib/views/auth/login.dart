import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trash_talk/consts/consts.dart';
import 'package:trash_talk/views/auth/signup.dart';
import 'package:trash_talk/widget_common/bgwidget.dart';
import 'package:trash_talk/widget_common/custom_textfield.dart';
import 'package:trash_talk/widget_common/logo.dart';
import 'package:trash_talk/widget_common/ourbottom.dart';

import '../../controller/auth_controller.dart';
import '../home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool? isCheck = false;
  final AuthController _controller = Get.put(AuthController()); // Get reference to AuthController

  var contoller =Get.put(AuthController());
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordretypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(416, 896));

    return Obx(() => _controller.isLoading.value
        ? Center(child: Image.asset('assets/images/logo.gif')) // Show loading GIF
        :
      bgWidget(
          child:Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
              10.heightBox,
              Column(
                children: [
                  customTextField(hint: emailHint,title: email,controller: emailController),
                  customTextField(hint: passwordHint,title: password,controller: passwordController),
                  Align(
                    alignment: Alignment.centerRight,
                      child: TextButton(onPressed: (){}, child: forgetPassword.text.make())),
                  5.heightBox,
                  ourButtom(color: backgroundcolor,title: login,textColor: whiteColor,
                    onpress: () async {
                      await contoller.loginMethod(
                        context: context,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    },
                  ).box.width(context.screenWidth - 50).make(),
                  5.heightBox,
                  createNewAccount.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButtom(color: backgroundcolor,title: signUp,textColor: whiteColor,onpress: (){
                    Get.to(()=> SignUp());
                  }).box.width(context.screenWidth-50).make(),



                ],
              ).box.white.rounded.padding( EdgeInsets.all(16.sp)).width(context.screenWidth-70).shadowSm.make()
            ],
          ),

        ),
      ),
    ),
      ),
    );
  }
}
