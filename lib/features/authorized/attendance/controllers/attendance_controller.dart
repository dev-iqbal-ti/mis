import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dronees/utils/helpers/add_water_mark.dart';
import 'package:dronees/utils/helpers/image_picker_helper.dart';
import 'package:dronees/utils/logging/logger.dart';

import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:latlong_to_place/latlong_to_place.dart';
import 'package:path_provider/path_provider.dart';

class AttendanceController extends GetxController {
  var currentPosition = Rxn<gmaps.LatLng>();
  RxString locationName = "".obs;
  RxString currentDate = "".obs;
  var isReady = false.obs;
  final service = GeocodingService();
  PlaceInfo? place;
  var selfieFile = Rxn<File>();

  // final LatLng officeLocation = const LatLng(28.6139, 77.2090);
  final double allowedRadius = 200; // meters

  @override
  void onInit() {
    super.onInit();
    getLocation();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    currentDate.value = formatter.format(now);
  }

  Future<void> getLocation() async {
    final info = await service.getCurrentPlaceInfo();
    TLoggerHelper.customPrint("info", "${info.latitude} ${info.longitude}");
    final place = await service.getPlaceInfo(info.latitude, info.longitude);
    TLoggerHelper.customPrint("place", place.formattedAddress);
    locationName.value = place.formattedAddress;
    currentPosition.value = gmaps.LatLng(info.latitude, info.longitude);
    isReady.value = true;
  }

  Future<void> takeSelfieAndTag() async {
    final pickImage = await ImageUploadService.takePhoto(xFile: true);
    if (pickImage == null || pickImage is! XFile) return;
    final picture = pickImage;

    final raw = File(picture.path);

    final stamped = await addWatermark(
      originalImage: raw,
      address: locationName.value,
      latLng:
          "Lat: ${currentPosition.value!.latitude} long: ${currentPosition.value!.longitude}",
      dateTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    );
    selfieFile.value = stamped;
  }

  Future<void> clockIn() async {
    try {
      // !  upload code will go here ........................................................
    } catch (e) {
      log(e.toString());
    }
  }

  // Future<void> getLocation() async {
  //   // LocationPermission permission = await Geolocator.requestPermission();
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // TLoaders.errorSnackBar(
  //     //   title: "Error",
  //     //   message:
  //     //       "Location services are turned off. Please enable GPS/Location services.",
  //     // );
  //     await Geolocator.openLocationSettings();
  //     return;
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     TLoaders.errorSnackBar(
  //       title: "Error",
  //       message: "Location permissions are denied.",
  //     );
  //     permission = await Geolocator.requestPermission();
  //   }
  //   final pos = await Geolocator.getCurrentPosition();
  //   locationName.value = await getLocationName(pos.latitude, pos.longitude);
  //   final user = LatLng(pos.latitude, pos.longitude);
  //   currentPosition.value = user;

  //   isReady.value = true;
  // }

  // Future<String> getLocationName(double latitude, double longitude) async {
  //   try {
  //     final uri = Uri.parse(
  //       'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latitude},${longitude}&key=${'AIzaSyDeeQ8QgpzoVTW5yVOdOu3kfn_00JxM1ms'}',
  //     );
  //     final response = await http.get(uri);
  //     if (response.statusCode != 200) {
  //       return "unknown location";
  //     }
  //     final location = jsonDecode(
  //       response.body,
  //     )["results"][0]["formatted_address"];
  //     log(location);

  //     return location;
  //   } catch (e) {
  //     log(e.toString());
  //     return "unKnown location";
  //   }
  // }
}
