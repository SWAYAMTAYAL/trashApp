import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trash_talk/consts/consts.dart';
import 'package:trash_talk/views/auth/signup.dart';
import 'package:trash_talk/widget_common/bgwidget.dart';
import 'package:trash_talk/widget_common/custom_textfield.dart';
import 'package:trash_talk/widget_common/logo.dart';
import 'package:trash_talk/widget_common/ourbottom.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bgWidget(child:Scaffold(
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
                  customTextField(hint: emailHint,title: email),
                  customTextField(hint: passwordHint,title: password),
                  Align(
                    alignment: Alignment.centerRight,
                      child: TextButton(onPressed: (){}, child: forgetPassword.text.make())),
                  5.heightBox,
                  ourButtom(color: backgroundcolor,title: login,textColor: whiteColor,onpress: (){}).box.width(context.screenWidth-50).make(),
                  5.heightBox,
                  createNewAccount.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButtom(color: backgroundcolor,title: signUp,textColor: whiteColor,onpress: (){
                    Get.to(()=> SignUp());
                  }).box.width(context.screenWidth-50).make(),



                ],
              ).box.white.rounded.padding(const EdgeInsets.all(16)).width(context.screenWidth-70).shadowSm.make()
            ],
          ),

        ),
      ),
    ));
  }
}
