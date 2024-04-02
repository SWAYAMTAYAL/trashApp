
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:trash_talk/consts/consts.dart';
import 'package:trash_talk/views/auth/signup.dart';

import '../consts/base_consts.dart';
import '../consts/firebase_auth_const.dart';
import '../views/home.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  Future<UserCredential?> loginMethod({email, password,context}) async {
    UserCredential? userCredentiale;
    try {
      isLoading(true);

      await auth.signInWithEmailAndPassword(email:email,password:password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blueAccent,
          content: Text('Sign in Successfully',
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
        ),
      );

      Get.offAll(Home());
    }
    on FirebaseAuthException catch(e){
      VxToast.show(context, msg: e.toString());
      isLoading (false);
    }finally {
      isLoading(false); // Set loading state to false regardless of success or failure
    }
    return userCredentiale;
  }
  Future<UserCredential?> SignUpMethod({email, password,context}) async {
    UserCredential? userCredentiale;
    try {
      isLoading(true);
      await auth.createUserWithEmailAndPassword(email:email,password:password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blueAccent,
          content: Text('Sign in Successfully',
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
        ),
      );
      Get.offAll(Home());
    }
    on FirebaseAuthException catch(e){
      VxToast.show(context, msg: e.toString());
    }finally {
      isLoading(false); // Set loading state to false regardless of success or failure
    }
    return userCredentiale;
  }
  Future<void> storeUserData({
    required String name,
    required String password,
    required String email,
  }) async {
    try {
      await FirebaseFirestore.instance.collection(usersCollection).doc(email).set({
        'name': name,
        'password': password,
        'email': email,
        'imageUrl': "",
      });
      print('User data stored successfully for email: $email');
    } catch (error) {
      print('Error storing user data: $error');
      // Handle error appropriately
    }
  }
}