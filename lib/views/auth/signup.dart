import 'package:trash_talk/consts/consts.dart';
import 'package:trash_talk/widget_common/bgwidget.dart';

import '../../widget_common/custom_textfield.dart';
import '../../widget_common/logo.dart';
import '../../widget_common/ourbottom.dart';
class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

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
                  customTextField(hint: namehint,title: name),
                  customTextField(hint: emailHint,title: email),
                  customTextField(hint: passwordHint,title: password),
                  customTextField(hint: retypepasswordhint,title: retypepassword),
        
                  5.heightBox,
                  ourButtom(color: backgroundcolor,title: signUp,textColor: whiteColor,onpress: (){}).box.width(context.screenWidth-50).make(),
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

