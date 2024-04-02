import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:trash_talk/consts/consts.dart';
import 'package:trash_talk/views/profile_screen.dart';
import 'package:trash_talk/views/request_screen.dart';
import '../consts/keys.dart';
import 'package:provider/provider.dart';
import '../consts/string_constant.dart';
import '../consts/userLocation.dart';
import '../controller/map_controller.dart';
import 'home.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var _currentIndex = 2;
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
  void initState() {
    super.initState();
    context.read<MapProvider>().initializeSymbol();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(416, 896));
    return Consumer<MapProvider>(builder: (context, provider, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            mapBox(),
               Positioned(
                 top: 0,
                 left: 0,
                 right: 0,
                 child: _buildSearchBar(provider),
          ),
        ],
        ),
        bottomNavigationBar: StylishBottomBar(
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
    });
  }
  }

  Widget mapBox() {
       return Consumer<MapProvider>(builder: (context, provider, child) {
        return MapboxMap(
          accessToken: Keys.mapbox_public_key,
          initialCameraPosition: const CameraPosition(
              target: LatLng(28.6304, 77.2177), zoom: 15.0),
          onMapCreated: (MapboxMapController mapController) async {
            await provider.onMapCreated(mapController, context);
           // provider.onMapCreated(mapController, context);
          },
          // onMapClick: (Point<double> point, LatLng coordinates) {
          //   FocusManager.instance.primaryFocus?.unfocus();
          //   provider.onMapClick(coordinates: coordinates, context: context);
          // },
        );
       });
  }

Widget _buildSearchBar(MapProvider provider) {
  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
      child: Positioned(
        top: 8.h,
        bottom: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(3.h),
            topRight: Radius.circular(3.h),
          ),
          child: Container(
            width: 100.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                         padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: TypeAheadField(
                        debounceDuration: Duration(milliseconds: 300),
                        hideSuggestionsOnKeyboardHide: false,
                        suggestionsCallback: (pattern) async {
                          return await provider.getPlaceSuggestions();
                        },
                        minCharsForSuggestions: 1,
                        noItemsFoundBuilder: (context) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  onTap: () async {
                                    provider.clearMapSearchController();
                                    FocusManager.instance.primaryFocus!
                                        .unfocus();
                                    LatLng latLng = await provider
                                        .fetchCurrentLocation(context);
                                    await provider.animateToPosition(latLng);
                                  },
                                  tileColor: Colors.red,
                                  title: Row(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        'assets/images/current_location_icon.svg',
                                        height: 2.5.h,
                                      ),
                                      SizedBox(width: 3.w),
                                      Text(
                                        'Your current location',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  tileColor: Colors.white,
                                  title: Text(
                                    'Can"t find any location',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        itemBuilder: (context, Feature suggestion) {
                          if (suggestion.id == ' Your current location') {
                            return ListTile(
                              onTap: () async {
                                provider.clearMapSearchController();
                                FocusManager.instance.primaryFocus!.unfocus();
                                LatLng latLng = await provider
                                    .fetchCurrentLocation(context);
                                await provider.animateToPosition(latLng);
                              },
                              tileColor: Colors.red,
                              title: Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/images/current_location_icon.svg',
                                    height: 2.5.h,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    'Your Current Location',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListTile(
                            tileColor: Colors.white,
                            title: Text(
                              suggestion.placeName ?? "",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.deepOrange,
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (Feature suggestion) async {
                          provider.handlePlaceSelectionEvent(suggestion);
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        textFieldConfiguration: TextFieldConfiguration(
                          textInputAction: TextInputAction.done,
                          cursorColor: Colors.deepOrange,
                          controller: provider.mapSearchController,
                          decoration: searchBoxInputDecoration(
                              hintText: 'Search Location', provider
                          ),
                        ),
                      ),
                    ),
                 ],
                    ),
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


Widget recenterWidget(
    BuildContext context, {
      required dynamic provider,
    }) {
  return Positioned(
    top: 2.h,
    right: 2.h,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        LatLng latLng = await provider.fetchCurrentLocation(context);
        await provider.animateToPosition(latLng);
      },
      child: Container(
        height: 5.h,
        width: 5.h,
        padding: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Image.asset('assets/images/current_location_pointer.png'),
      ),
    ),
  );
}