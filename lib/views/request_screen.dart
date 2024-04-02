import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
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
  final picker = ImagePicker();
  File? _image;
  String _address = '';

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

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Get.off(() => Home());
        break;
      case 1:
      // Already on the Request page
        break;
      case 2:
        Get.off(() => MapScreen());
        break;
      case 3:
        Get.off(() => Profile());
        break;
      default:
        break;
    }
  }

  void _saveToFirestore() {
    // Implement your logic to save the entered address to Cloud Firestore
    // Here you should use the _address variable
    // After saving, you can show a success message or navigate to another screen
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
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
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
                Center(child: Text('No request')),
              if (_image != null) const SizedBox(height: 16.0),
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
              if (_image != null) const SizedBox(height: 16.0),
              if (_image != null)
                ElevatedButton(
                  onPressed: _saveToFirestore,
                  child: const Text('Submit'),
                ),
              if (_image != null && _address.isNotEmpty) const SizedBox(height: 16.0),
              if (_image != null && _address.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address: $_address'),
                      const SizedBox(height: 8.0),
                      Text('Image:'),
                      const SizedBox(height: 8.0),
                      Image.file(_image!),
                    ],
                  ),
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

