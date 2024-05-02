import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:location/location.dart' as location;
import 'package:trash_talk/consts/api_endpoint_constant.dart';

import '../consts/base_consts.dart';
import '../consts/userLocation.dart';
import '../consts/utility_function.dart';
import '../models/user.dart';


class MapProvider with ChangeNotifier {

  late MapboxMapController _controller;

  late Symbol _symbol;

  final _mapLocation = location.Location();

  late LatLng _userCurrentLatLng;

  TextEditingController _mapSearchController = TextEditingController();

  //============= GETTERS =============//
  LatLng get userCurrentLatLng => _userCurrentLatLng;
 // UserModel _userData = UserModel();
 // UserModel get userData => _userData;
  TextEditingController get mapSearchController => _mapSearchController;

  /// Initialising [_symbol]
  void initializeSymbol() {
    _symbol = Symbol(
      'marker',
      SymbolOptions(),
    );
  }/*
  String? getHomeAddressText() {
    return userData.homeLocation?.addressString;
  }
*/
  Future<void> onMapCreated(
      MapboxMapController mapController,
      BuildContext context,
      ) async {
    _controller = mapController;

    var _serviceEnabled = await _mapLocation.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
    }
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _mapLocation.requestPermission();
    }

    var _locationData = await _mapLocation.getLocation();

    _userCurrentLatLng =
        LatLng(_locationData.latitude!, _locationData.longitude!);

    print('User current location: $_userCurrentLatLng'); // Print user's current latitude and longitude

    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _userCurrentLatLng,
          zoom: 16,
        ),
      ),
    );
    await mapController.addSymbol(
      SymbolOptions(
        geometry: _userCurrentLatLng,
        iconImage: 'assets/images/current_location_icon.png', // Replace with your icon image
        iconSize: 100.0.sp,
      ),
    );
  }


  Future<List<Feature>> getPlaceSuggestions() async {
    List<Feature> _data = [];

    Uri uri = Uri.parse(
        "${ApiEndpointConstant.mapboxPlacesApi}${_mapSearchController.text}.json")
        .replace(queryParameters: UtilityFunctions.mapSearchQueryParameters());

    try {
      var response = await BaseClient()
          .get(baseUrl: '', api: uri.toString())
          .onError((error, stackTrace) => throw Exception(error));

      UserLocationModel responseData =
      UserLocationModel.fromJson(jsonDecode(response.body));

      _data = responseData.features ?? [];
      _data = [
        Feature(id: 'Your current location'),
        ..._data,
      ];
    } catch (e) {
      Logger().d(e);
    }

    return _data;
  }
  Future<void> handlePlaceSelectionEvent(
      Feature place,
      ) async {
    _mapSearchController.text = place.placeName ?? "";

    LatLng selectedLatLng =
    LatLng(place.center?[1] ?? 0.0, place.center?[0] ?? 0.0);

    await _controller.removeSymbol(_symbol);

    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: selectedLatLng, zoom: 16),
      ),
    );

    clearMapSearchController();

    notifyListeners();
  }

  Future<LatLng> fetchCurrentLocation(BuildContext context) async {
    var _serviceEnabled = await _mapLocation.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
    }
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _mapLocation.requestPermission();
    }

    var _locationData = await _mapLocation.getLocation();

    return LatLng(_locationData.latitude!, _locationData.longitude!);
  }

  void clearMapSearchController() {
    _mapSearchController.clear();
    notifyListeners();
  }
  Future<void> animateToPosition(LatLng latLng) async {
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 16),
      ),
    );
  }
}