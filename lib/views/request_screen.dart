import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:trash_talk/consts/consts.dart';
import 'package:trash_talk/views/profile_screen.dart';

import 'home.dart';
import 'map_screen.dart';

class Request extends StatefulWidget {
  const Request({Key? key}) : super(key: key);

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  var _currentIndex = 1;
  void _navigateToPage(int index) {
    switch (index) {
      case 0:
      // Navigate to Home page
      // You can replace `HomeScreen` with the actual name of your home screen class
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home()),
        );
        break;
      case 1:
      // Navigate to Likes page
      // You can replace `LikesScreen` with the actual name of your likes screen class
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Request()),
        );
        break;
      case 2:
      // Navigate to Search page
      // You can replace `SearchScreen` with the actual name of your search screen class
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MapScreen()),
        );
        break;
      case 3:
      // Navigate to Profile page
      // You can replace `ProfileScreen` with the actual name of your profile screen class
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Profile()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(416, 896));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Trash Talk',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), // Use the iOS back arrow icon
          onPressed: () {
            // Handle navigation or any other action
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child:  Center(
          child: Text(
            'Request Screen',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
