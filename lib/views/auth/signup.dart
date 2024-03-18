import 'package:get/get.dart';
import 'package:trash_talk/consts/consts.dart';
import 'package:trash_talk/controller/auth_controller.dart';
import 'package:trash_talk/widget_common/bgwidget.dart';

import '../../widget_common/custom_textfield.dart';
import '../../widget_common/logo.dart';
import '../../widget_common/ourbottom.dart';
import '../home.dart';
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool? isCheck = false;
  var contoller =Get.put(AuthController());
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordretypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child:Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Sign up $appname".text.fontFamily(bold).white.size(18).make(),
              10.heightBox,
              Column(
                children: [
                  customTextField(hint: namehint,title: name,controller: nameController),
                  customTextField(hint: emailHint,title: email,controller: emailController),
                  customTextField(hint: passwordHint,title: password,controller: passwordController),
                  customTextField(hint: retypepasswordhint,title: retypepassword,controller: passwordretypeController),

                  5.heightBox,
                  ourButtom(color: backgroundcolor,title: signUp,textColor: whiteColor,onpress: () async{
                    await contoller.SignUpMethod(context: context,email: emailController.text,password: passwordController.text).then((value){
                      return contoller.storeUserData(
                        email: emailController.text,
                        password: passwordController.text,
                        name: nameController.text
                      );
                    }).then((value){
                      Get.offAll(Home());
                    });
                  }).box.width(context.screenWidth-50).make(),
                  5.heightBox,
                  haveAccount.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButtom(color: backgroundcolor,title: login,textColor: whiteColor,onpress: (){

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

