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
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(416, 896));
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: topbottomcolor,
        title: const Text(
          'Trash Talk',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton( color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: backgroundcolor,
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

                  if (data == null) {
                    return Container();
                  }

                  String imageUrl = data['image_url'] ?? ''; // Get imageUrl, default to empty string if not available
                  String address = data['address'] ?? '';
                  String complaint = data['complain'] ?? '';
                  String request = data['Request'] ?? 'No'; // Get request value, default to 'No' if not available
                  Color addressColor = request == 'Yes' ? Colors.green : Colors.red;
                  Color complaintColor = request == 'Yes' ? Colors.green : Colors.red;

                  return Container(
                    margin: EdgeInsets.only(bottom: 16.0.sp),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      children:[
                      Stack(
                        children: [
                          // Show loading indicator or default image if imageUrl is empty
                          if (imageUrl.isEmpty)
                            Container(
                              height: 200.h, // Set height for default image placeholder
                              color: Colors.grey, // Placeholder color
                              child: Center(
                                child: CircularProgressIndicator(), // Loading indicator
                              ),
                            )
                          else
                          // Show image if available
                            Image.network(
                              imageUrl,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null)
                                  return child;
                                else
                                  return Container(
                                    height: 200.h, // Set height for default image placeholder
                                    color: Colors.grey, // Placeholder color
                                    child: Center(
                                      child: CircularProgressIndicator(), // Loading indicator
                                    ),
                                  );
                              },
                            ),
                          Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: Icon(
                              request == 'Yes' ? Icons.check_circle : Icons.cancel, // Green check or red cross icon based on request value
                              color: request == 'Yes' ? Colors.green : Colors.red, // Green or red color based on request value
                            ),
                          ),
                        ],
                      ),

                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('  Address: ',
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        Text('$address',
                          style: TextStyle(color: addressColor),
                        ),
                        ],
                    ),
                    SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('  Complaint: ',
                              style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white),
                            ),
                            Text('$complaint',
                              style: TextStyle(color: complaintColor),
                            ),
                          ],
                        ),
                 ],
                    ));
                }).toList(),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: StylishBottomBar(backgroundColor: topbottomcolor,
        option: BubbleBarOptions(
          barStyle: BubbleBarStyle.horizotnal,
          bubbleFillStyle: BubbleFillStyle.fill,
          opacity: 0.3,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home',style: TextStyle(fontWeight: FontWeight.bold),),
            backgroundColor:  Colors.green,
          ),
          BottomBarItem(
            icon: const Icon(Icons.remove_from_queue),
            title: const Text('Request',style: TextStyle(fontWeight: FontWeight.bold),),
            backgroundColor:  Colors.green,
          ),
          BottomBarItem(
            icon: const Icon(Icons.map),
            title: const Text('Map',style: TextStyle(fontWeight: FontWeight.bold),),
            backgroundColor:  Colors.green,
          ),
          BottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile',style: TextStyle(fontWeight: FontWeight.bold),),
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
