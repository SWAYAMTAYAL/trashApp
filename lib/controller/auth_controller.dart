



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:trash_talk/consts/consts.dart';
import 'package:trash_talk/views/auth/signup.dart';

import '../consts/firebase_consts.dart';

class AuthController extends GetxController {
  Future<UserCredential?> loginMethod({email, password,context}) async {
    UserCredential? userCredentiale;
    try {
      await auth.signInWithEmailAndPassword(email:email,password:password);

    }
    on FirebaseAuthException catch(e){
      VxToast.show(context, msg: e.toString());
    }
    return userCredentiale;
  }
  Future<UserCredential?> SignUpMethod({email, password,context}) async {
    UserCredential? userCredentiale;
    try {
      await auth.createUserWithEmailAndPassword(email:email,password:password);

    }
    on FirebaseAuthException catch(e){
      VxToast.show(context, msg: e.toString());
    }
    return userCredentiale;
  }
  storeUserData({name,password,email,}) async{
        await firestore.collection(usersCollection).add({
      'name':name,
      'password':password,
      'email':email,
      'imageUrl':"",
    });
  }
}