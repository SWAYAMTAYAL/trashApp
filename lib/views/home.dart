import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:trash_talk/consts/consts.dart';
import 'package:trash_talk/views/profile_screen.dart';
import 'package:trash_talk/views/request_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'map_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _currentIndex = 0;
 
  final picker = ImagePicker();
  File? _image;
  String _address = '';
  String _complain = '';
  bool _loading = true;
  String? _imageUrlFromFirestore;
  void _navigateToPage(int index) {
    switch (index) {
      case 0:
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
  Future<void> _getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      // User canceled the image picking operation
    }
  }
  void _saveToFirestore() async {
    try {
      if (_image != null && _address.isNotEmpty) {
        // Generate a unique filename for the image
        Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              child:  Center(
                child: Image.asset('assets/images/applogo.gif'),
              ), // Loading indicator
            ),
          ),
        );
        setState(() {
          _loading = true;
        });

        String filename = DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();
        // Upload the image to Firebase Storage
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage
            .instance.ref().child('images/$filename.jpg');
        firebase_storage.UploadTask uploadTask = ref.putFile(_image!);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask
            .whenComplete(() => null);

        // Get the download URL of the uploaded image
        String imageUrl = await ref.getDownloadURL();

        // Save the download URL and address to Firestore
        await FirebaseFirestore.instance.collection('requests').add({
          'image_url': imageUrl,
          'address': _address,
          'complain': _complain,
          'timestamp': FieldValue.serverTimestamp(),
          // Optional: include timestamp
        });

        // Show success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Request submitted successfully'),
        ));
        Get.off(() => Request());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please add an image and address'),
        ));
      }
    } catch (error) {
      print('Error saving to Firestore: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit request. Please try again later.'),
      ));
    } finally {
      // Hide loading indicator
      setState(() {
        _loading = false;
      });
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
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_image != null)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Image.file(_image!),
                ),
                
              if (_image == null)
                SizedBox(
                  height: 700.h,
                  child: Center(
                    child: Text('No Request',
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                ),
              //     if (_image != null) const SizedBox(height: 16.0),
              if (_image != null)
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter Address',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                ),
              SizedBox(height:10.h),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter Complain',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _complain = value;
                  });
                },
              ),
              if (_image != null) const SizedBox(height: 16.0),
              if (_image != null)
                ElevatedButton(
                  onPressed: _saveToFirestore,
                  child: const Text('Submit'),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: StylishBottomBar(
        option: BubbleBarOptions(
          barStyle: BubbleBarStyle.horizotnal,
          bubbleFillStyle: BubbleFillStyle.fill,
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
        onPressed: _getImageFromCamera,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
