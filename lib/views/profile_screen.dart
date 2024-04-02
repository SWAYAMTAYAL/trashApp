import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:trash_talk/consts/consts.dart';
import 'package:trash_talk/views/request_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget_common/bgwidget.dart';
import 'auth/login.dart';
import 'home.dart';
import 'map_screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var _currentIndex = 3;
  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Get.off(() => Home());
      // Already on the Home page
        break;
      case 1:
        Get.off(() => Request());
        // Navigate to Request page
        break;
      case 2:
      // Navigate to Map page
        Get.off(() => MapScreen());
        break;
      case 3:
      // Navigate to Profile page
        Get.off(() => Profile());
        break;
      default:
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a blurred profile screen background while waiting
            return Stack(
              children: [
                appScreenCommonBackground(context),
                CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    transparentFlexibleSpace(context),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Profile",
                                      // "Hey ",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 26,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding:
                                        EdgeInsets.only(
                                            top: 2.h, right: 5.w, left: 5.w),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Stack(
                                                  alignment: Alignment
                                                      .bottomRight,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Colors.black45,
                                                          // Border color
                                                          width: 1, // Border width
                                                        ),
                                                      ),
                                                      child: CircleAvatar(
                                                          radius: 70.h,
                                                          backgroundColor: Colors
                                                              .transparent,
                                                          child: SvgPicture
                                                              .asset(
                                                            'assets/images/artist_icon.svg',
                                                            height: 150.h,
                                                          )
                                                        // backgroundImage: AssetImage('assets/images/artist_icon.png'),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        // context.read<ProfileProvider>().uploadProfileImage(context);
                                                      },
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 4.w),
                                              ],
                                            ),
                                            SizedBox(height: 30.h),
                                            Column(
                                              children: [
                                                profileOptions(
                                                  onTap: () {
                                                    Get.off(() => Request());
                                                  },
                                                  imagePath: 'assets/images/reviews_icon.svg',
                                                  optionTitle: 'Request',
                                                ),
                                                SizedBox(height: 20.h),
                                                profileOptions(
                                                  onTap: () {
                                                    Get.off(() => MapScreen());
                                                  },
                                                  imagePath: 'assets/images/black_location_icon.svg',
                                                  optionTitle: 'Map',
                                                ),
                                                SizedBox(height: 40.h),
                                                profileOptions(
                                                  onTap: () =>
                                                      launchUrl(
                                                        Uri.parse(
                                                            'https://www.instagram.com/___anujsharma__16/'),
                                                      ),
                                                  imagePath: 'assets/images/information_icon.svg',
                                                  optionTitle: 'more',
                                                ),
                                                SizedBox(height: 40.h),
                                                profileOptions(
                                                  onTap: () =>
                                                      launchUrl(
                                                        Uri.parse(
                                                            'https://www.instagram.com/___anujsharma__16/'),
                                                      ),
                                                  imagePath: 'assets/images/save_icon.svg',
                                                  optionTitle: 'About Us',
                                                ),
                                                SizedBox(height: 40.h),
                                                profileOptions(
                                                  onTap: () {
                                                    FirebaseAuth.instance
                                                        .signOut();
                                                    // Navigate to login screen
                                                    Get.off(() =>
                                                        LoginScreen());
                                                  },
                                                  imagePath: 'assets/images/logout_icon.svg',
                                                  optionTitle: 'Logout',
                                                ),
                                                SizedBox(height: 50.h),
                                              ],
                                            )
                                          ],

                                        ),
                                      ),


                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),// Background image or color
                Center(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      child:  Center(
                        child: Image.asset('assets/images/applogo.gif'),
                      ), // Loading indicator
                    ),
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Text('No user data found');
          }

          // Access user data from snapshot
          print('User UID: ${FirebaseAuth.instance.currentUser!.email}'); // Print UID for debugging

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var userName = userData['name'];
          var userEmail = userData['email'];
          print('user name is :- $userName');
          print('user email is :- $userEmail');


          ScreenUtil.init(context, designSize: Size(416, 896));
          return Scaffold(
            body: Stack(
              children: <Widget>[
                appScreenCommonBackground(context),
                CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    transparentFlexibleSpace(context),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Profile",
                                      // "Hey ",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 26,
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding:
                                        EdgeInsets.only(
                                            top: 2.h, right: 5.w, left: 5.w),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Stack(
                                                  alignment: Alignment
                                                      .bottomRight,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Colors.black45,
                                                          // Border color
                                                          width: 1, // Border width
                                                        ),
                                                      ),
                                                      child: CircleAvatar(
                                                          radius: 70.h,
                                                          backgroundColor: Colors
                                                              .transparent,
                                                          child: SvgPicture
                                                              .asset(
                                                            'assets/images/artist_icon.svg',
                                                            height: 150.h,
                                                          )
                                                        // backgroundImage: AssetImage('assets/images/artist_icon.png'),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: _pickAndSaveImage,
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 4.w),
                                                userDetailsWithEditButton(
                                                  userName: userName,
                                                  userEmail: userEmail,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 30.h),
                                            Column(
                                              children: [
                                                profileOptions(
                                                  onTap: () {
                                                    Get.off(() => Request());
                                                  },
                                                  imagePath: 'assets/images/reviews_icon.svg',
                                                  optionTitle: 'Request',
                                                ),
                                                SizedBox(height: 20.h),
                                                profileOptions(
                                                  onTap: () {
                                                    Get.off(() => MapScreen());
                                                  },
                                                  imagePath: 'assets/images/black_location_icon.svg',
                                                  optionTitle: 'Map',
                                                ),
                                                SizedBox(height: 20.h),
                                                profileOptions(
                                                  onTap: () =>
                                                      launchUrl(
                                                        Uri.parse(
                                                            'https://www.instagram.com/___anujsharma__16/'),
                                                      ),
                                                  imagePath: 'assets/images/information_icon.svg',
                                                  optionTitle: 'More',
                                                ),
                                                SizedBox(height: 20.h),
                                                profileOptions(
                                                  onTap: () =>
                                                      launchUrl(
                                                        Uri.parse(
                                                            'https://www.instagram.com/___anujsharma__16/'),
                                                      ),
                                                  imagePath: 'assets/images/save_icon.svg',
                                                  optionTitle: 'About Us',
                                                ),
                                                SizedBox(height: 20.h),
                                                profileOptions(
                                                  onTap: () {
                                                    FirebaseAuth.instance
                                                        .signOut();
                                                    // Navigate to login screen
                                                    Get.off(() =>
                                                        LoginScreen());
                                                  },
                                                  imagePath: 'assets/images/logout_icon.svg',
                                                  optionTitle: 'Logout',
                                                ),
                                                SizedBox(height: 20.h),
                                              ],
                                            )
                                          ],

                                        ),
                                      ),


                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ],
            ),
            bottomNavigationBar: StylishBottomBar(
//  option: AnimatedBarOptions(
//    iconSize: 32,
//    barAnimation: BarAnimation.liquid,
//    iconStyle: IconStyle.animated,
//    opacity: 0.3,
//  ),
              option: BubbleBarOptions(
                barStyle: BubbleBarStyle.horizotnal,
                // barStyle: BubbleBarStyle.vertical,
                bubbleFillStyle: BubbleFillStyle.fill,
                // bubbleFillStyle: BubbleFillStyle.outlined,
                opacity: 0.3,
              ),
              items: [
                BottomBarItem(
                  icon: const Icon(Icons.home),
                  title: const Text('Home'),
                  backgroundColor: Colors.red,

                ),
                BottomBarItem(
                  icon: const Icon(Icons.remove_from_queue),
                  title: const Text('Request'),
                  backgroundColor: Colors.blue,
                ),
                BottomBarItem(
                  icon: const Icon(Icons.map),
                  title: const Text('Map'),
                  backgroundColor: Colors.orange,
                ),
                BottomBarItem(
                  icon: const Icon(Icons.person),
                  title: const Text('Profile'),
                  backgroundColor: Colors.green,
                ),
              ],
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  _navigateToPage(index);
                });
              },
            ),
          );
        }
    );
  }
  Widget profileOptions({
    required Function() onTap,
    required String imagePath,
    required String optionTitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: optionTitle == 'Logout'
                  ? Colors.white
                  : graphicFillDark,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  imagePath,
                ),
                SizedBox(width: 13.w),
                Text(
                  optionTitle,
                  style: TextStyle(
                    color: textDark,
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
             'assets/images/right_arrow_icon.svg',
              color: textDark,
              height: 2.5.h,
            ),
          ],
        ),
      ),
    );
  }
  Widget userDetailsWithEditButton({
    required String userName,
    required String userEmail,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: graphicFillDark,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  color: textDark,
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                userEmail,
                style: TextStyle(
                  color: textDark,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndSaveImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final File imageFile = File(pickedImage.path);
      // Upload image to Firestore and save the URL
      final imageUrl = await uploadImageToFirestore(imageFile);
      // Update the user's document with the new image URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({'imageUrl': imageUrl});
    } else {
      // User canceled image picking
      // Handle accordingly, like showing a snackbar or toast
    }
  }

  Future<String> uploadImageToFirestore(File imageFile) async {
    try {
      // Get a reference to the Firebase storage bucket
      var storageRef = firebase_storage.FirebaseStorage.instance.ref();

      // Create a unique filename for the image
      var imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload the image file to Firebase Cloud Storage
      var uploadTask = storageRef.child('images/$imageName').putFile(imageFile);

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL of the uploaded image
      var downloadURL = await storageRef.child('images/$imageName').getDownloadURL();

      // Return the download URL as a string
      return downloadURL;
    } catch (error) {
      // Handle any errors that occur during image uploading
      print('Error uploading image: $error');
      return ''; // Return an empty string if an error occurs
    }
  }


}
