import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:trash_talk/consts/userLocation.dart';

import 'api_endpoint_constant.dart';
import 'base_consts.dart';
import 'keys.dart';

class UtilityFunctions {
  /// Method to generate the complete image path from [imageTitle]
  static String getImagePath({required String imageTitle}) {
    return 'assets/images$imageTitle';
  }

  /// [SymbolOptions] for user's current location
  static SymbolOptions getCurrentLocationSymbolOptions(
      {required LatLng latLng}) {
    return SymbolOptions(
      geometry: latLng,
      iconImage: 'current_location_pointer.png',
      iconSize: 0.2,
    );
  }

  /// [SymbolOptions] for nearby salon locations
  static SymbolOptions getNearbySalonLocationSymbolOptions(
      {required LatLng latLng}) {
    return SymbolOptions(
      geometry: latLng,
      iconImage: 'salon_location_marker.png',
      iconSize: 2,
    );
  }

  /// Handle current location API timeout, when the API runs for
  /// more than [BaseClient.TIME_OUT_DURATION] seconds
  static LocationData locationApiTimeout(
      BuildContext context, {
        required String message,
      }) {
    return LocationData.fromMap({});
  }

  /// Query parameters for address suggestions from search text
  static Map<String, dynamic> mapSearchQueryParameters() {
    return {
      'proximity': 'ip',
      'limit': '10',
      'language': 'en-gb',
      'autocomplete': 'true',
      'fuzzyMatch': 'true',
      'access_token': Keys.mapbox_public_key,
    };
  }

  /// Query parameters for reverse geo-coding api
  static Map<String, dynamic> reverseGeoLocationQueryParameters() {
    return {
      'types': 'locality,neighborhood,place,district,region',
      'access_token': Keys.mapbox_public_key,
    };
  }

  /// Fetches the complete address for the provided coordinates.
  static Future<UserLocationModel?> getAddressFromCoordinates(
      BuildContext context, {
        required LatLng coordinates,
      }) async {
    Uri uri = Uri.parse(
        "${ApiEndpointConstant.mapboxPlacesApi}${coordinates.longitude},${coordinates.latitude}.json")
        .replace(
        queryParameters:
        UtilityFunctions.reverseGeoLocationQueryParameters());

    try {
      var response = await BaseClient().get(
        baseUrl: '',
        api: uri.toString(),
      );
      return UserLocationModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      Logger().d(e);
      return null;
    }
  }

  /// Formats the address text for the provided location.
  /// The address format is [x, y] where the precedence of x and y is
  /// Neighborhood, Locality, Place, District, Region
  static String formatAddressText(UserLocationModel locationModel) {
    String address = '';
    for (int i = 0; i < (locationModel.features?.length ?? 0); i++) {
      var element = locationModel.features?[i];

      switch (element?.placeType?[0]) {
        case 'neighborhood':
          address += '${element?.text}, ';
          break;
        case 'locality':
          address += '${element?.text}, ';
          break;
        case 'place':
          address += '${element?.text}, ';
          break;
        case 'district':
          address += '${element?.text}, ';
          break;
        case 'region':
          address += '${element?.text}';
          break;
      }
    }
    var addressArray = address.split(',');
    address = '${addressArray.first},${addressArray.last}';
    return address;
  }

  /// Fetch the address from given coordinates and return a formatted address text.
  static Future<String> getAddressCoordinateAndFormatAddress({
    required BuildContext context,
    required LatLng latLng,
  }) async {
    UserLocationModel? _userLocationResult =
    await UtilityFunctions.getAddressFromCoordinates(context,
        coordinates: latLng);

    return _userLocationResult == null
        ? 'unknown'
        : UtilityFunctions.formatAddressText(_userLocationResult);
  }
}