import 'dart:async';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:trash_talk/consts/consts.dart';
import 'package:trash_talk/views/auth/login.dart';
import 'package:trash_talk/views/profile_screen.dart';
import 'package:trash_talk/views/request_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:trash_talk/widget_common/Line_char2.dart';
import 'package:trash_talk/widget_common/Pie_chart.dart';
import '../utils/indicator.dart';
import '../widget_common/Line_chart.dart';
import 'map_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _currentIndex = 0;
  int touchedIndex = -1;
 
  final picker = ImagePicker();
  File? _image;
  String _address = '';
  String _complain = '';
  bool _loading = true;
  Timer? _timer; // Timer for automatic update
  String? _imageUrlFromFirestore;
  void _navigateToPage (int index) {
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
        setState(() {
          _loading = true; // Show loading indicator
        });

        String filename = DateTime.now().millisecondsSinceEpoch.toString();
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('images/$filename.jpg');
        firebase_storage.UploadTask uploadTask = ref.putFile(_image!);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String imageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('requests').add({
          'image_url': imageUrl,
          'address': _address,
          'complain': _complain,
          'Request': 'No',
          'timestamp': FieldValue.serverTimestamp(),
        });

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
      setState(() {
        _loading = false; // Hide loading indicator
      });
    }
  }
  @override
  void initState() {
    super.initState();
    // Start the timer when the widget initializes
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        // Toggle the touchedIndex between 0 and 1
        touchedIndex = touchedIndex == 0 ? 1 : 0;
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _timer?.cancel();
    super.dispose();
  }
  Widget _buildPieChart(List<DocumentSnapshot> docs) {
    int yesCount = 0;
    int noCount = 0;

    int totalCount = docs.length;

    // Calculate the counts of 'Yes' and 'No' requests
    for (var doc in docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        String request = data['Request'] ?? 'No';
        if (request == 'Yes') {
          yesCount++;
        } else {
          noCount++;
        }
      }
    }

    // Calculate percentage values
    double yesPercentage = (yesCount / totalCount) * 100;
    double noPercentage = (noCount / totalCount) * 100;

    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 18.h,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40.w,
                  sections: showingSections(yesCount, noCount, yesPercentage, noPercentage),
                  //  centerSpaceRadius: 40.w,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                textColor: Colors.white,
                color: Colors.green, // Color for 'Yes' section
                text: 'Approved', // Text for 'Yes' section
                isSquare: true,
              ),
              SizedBox(
                height: 4.h,
              ),
              Indicator(
                textColor: Colors.white,
                color: Colors.red, // Color for 'No' section
                text: 'Pending', // Text for 'No' section
                isSquare: true,
              ),
              SizedBox(
                height: 4.h,
              ),
            ],
          ),
          SizedBox(
            width: 28.w,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(int yesCount, int noCount, double yesPercentage, double noPercentage) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0.sp : 16.0.sp;
      final radius = isTouched ? 70.0.sp : 60.0.sp;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: yesCount.toDouble(),
            title: '${yesPercentage.toStringAsFixed(2)}%',
            radius: radius,
            titleStyle: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: noCount.toDouble(),
            title: '${noPercentage.toStringAsFixed(2)}%',
            radius: radius,
            titleStyle: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(416, 896));
    return Scaffold(backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: topbottomcolor,
        automaticallyImplyLeading: false,
       // backgroundColor: Colors.white,
        title: const Text(
          'Trash Talk',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.off(() => LoginScreen());
          },
          color: Colors.white,
        ),
      ),

      body: Container(
        color: backgroundcolor,
        padding:  EdgeInsets.all(16.sp),
        child: SingleChildScrollView(
          child: Column(
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
                  height: 940.h,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('requests').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 300.h, // Set a fixed height for the PieChart
                              child: _buildPieChart(snapshot.data!.docs),
                           //   child: PieChartSample2(),
                            ),
                            SizedBox(height:20.h),
                            SizedBox(
                              height: 300.h, // Set a fixed height for the PieChart
                              child: LineChartSample1(),
                            ),
                            SizedBox(height:20.h),
                            SizedBox(
                              height: 300.h, // Set a fixed height for the PieChart
                              child: LineChartSample2(),
                            ),
                          ],
                        );
                      } else {
                        return Text(
                          'No Request',
                          style: TextStyle(fontSize: 20.sp, color: Colors.white),
                        );
                      }
                    },
                  ),
                ),
              //     if (_image != null) const SizedBox(height: 16.0),
              if (_image != null)
                TextField(
                  style: TextStyle(color: Colors.white),
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
              if (_image != null)
              SizedBox(height:10.h),
              if (_image != null)
              TextField(style: TextStyle(color: Colors.white),
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
                  onPressed:  _saveToFirestore, // Disable button when loading
                  child:  Text('Submit'), // Show loading indicator or button text
                ),
            ],
          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _getImageFromCamera,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
