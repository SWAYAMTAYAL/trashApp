import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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
import 'dart:convert';
/*
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
  bool _loading = true;
  String? _imageUrlFromFirestore;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('requests').get();

      if (querySnapshot.docs.isNotEmpty) {
        // If there are documents in the collection, get the first one
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;

        // Cast docSnapshot.data() to Map<String, dynamic>
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          _address = data['address'];

          // Check if 'image_url' field exists in the document
          if (data.containsKey('image_url')) {
            _imageUrlFromFirestore = data['image_url'];
          } else {
            // Set _imageUrlFromFirestore to null or an empty string if 'image_url' field doesn't exist
            _imageUrlFromFirestore = null; // or ''
          }
        }
      } else {
        // If no documents are available, set _address to 'No Request'
        _address = 'No Request';
      }
    } catch (error) {
      print('Error fetching data from Firestore: $error');
    } finally {
      // Set loading to false after fetching data
      setState(() {
        _loading = false;
      });
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

  void _saveToFirestore() async {
    try {
      if (_image != null && _address.isNotEmpty) {
        // Convert image to base64 string
        List<int> imageBytes = await _image!.readAsBytes();
        String base64Image = base64Encode(imageBytes);

        // Save base64 image and address to Firestore
        DocumentReference docRef = await FirebaseFirestore.instance.collection('requests').add({
          'image': base64Image,
          'address': _address,
          'timestamp': FieldValue.serverTimestamp(), // Optional: include timestamp
        });

        String documentId = docRef.id; // Retrieve the document ID
        print('Document ID: $documentId');

        // Show success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Request submitted successfully'),
        ));

        // Navigate back to the request screen to reload it
        Navigator.pop(context); // Go back to the previous screen
        Get.to(Request()); // Reload the request screen
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
*/

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
  String _complain = '';
  bool _loading = true;
  String? _imageUrlFromFirestore;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
          'requests').get();

      if (querySnapshot.docs.isNotEmpty) {
        // If there are documents in the collection, get the first one
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;

        // Cast docSnapshot.data() to Map<String, dynamic>
        Map<String, dynamic>? data = docSnapshot.data() as Map<String,
            dynamic>?;

        if (data != null) {
          _address = data['address'];

          // Check if 'image_url' field exists in the document
          if (data.containsKey('image_url')) {
            _imageUrlFromFirestore = data['image_url'];
          } else {
            // Set _imageUrlFromFirestore to null or an empty string if 'image_url' field doesn't exist
            _imageUrlFromFirestore = null; // or ''
          }
        }
      } else {
        // If no documents are available, set _address to 'No Request'
        _address = 'No Request';
      }
    } catch (error) {
      print('Error fetching data from Firestore: $error');
    } finally {
      // Set loading to false after fetching data
      setState(() {
        _loading = false;
      });
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

  void _saveToFirestore() async {
    try {
      if (_image != null && _address.isNotEmpty) {
        // Generate a unique filename for the image
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

        // Reload the screen after submission
        _fetchData();
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('requests').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
      
            if (snapshot.connectionState == ConnectionState.waiting) {
              return   Center(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    child:  Center(
                      child: Image.asset('assets/images/applogo.gif'),
                    ), // Loading indicator
                  ),
                ),
              );// Or any other loading indicator
            }
      
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No Requests',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
      
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

                  // Check if data is null
                  if (data == null) {
                    return Container(); // Return an empty container
                  }

                  // Extract fields with null check
                  String imageUrl = data['image_url'] ?? Icon(Icons.image_not_supported);
                  String address = data['address'] ?? '';
                  String complaint = data['complain'] ?? '';

                  return Container(
                    margin: EdgeInsets.only(bottom: 16.0.sp),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imageUrl.isNotEmpty ? Image.network(imageUrl) : Icon(Icons.image_not_supported), // Display image if imageUrl is not empty
                        SizedBox(height: 8.0.h),
                        Text('Address: $address'),
                        SizedBox(height: 8.0.h),
                        Text('Complaint: $complaint'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
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
            icon: Icon(Icons.home),
            title: Text('Home'),
            backgroundColor: Colors.red,
          ),
          BottomBarItem(
            icon: Icon(Icons.remove_from_queue),
            title: Text('Request'),
            backgroundColor: Colors.blue,
          ),
          BottomBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
            backgroundColor: Colors.orange,
          ),
          BottomBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
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
}
