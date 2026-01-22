import 'package:dronees/features/authorized/attendance/controllers/attendance_controller.dart';
import 'package:flutter/Material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Widget attendanceMap(AttendanceController controller) {
  return Obx(() {
    if (controller.currentPosition.value == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: controller.currentPosition.value!,
        zoom: 16,
      ),
      myLocationEnabled: true,
      // circles: {
      //   Circle(
      //     circleId: const CircleId("office"),
      //     center: controller.officeLocation,
      //     radius: controller.allowedRadius,
      //     fillColor: Colors.purple.withOpacity(0.2),
      //     strokeColor: Colors.purple,
      //     strokeWidth: 2,
      //   ),
      // },
      markers: {
        Marker(
          markerId: const MarkerId("current"),
          position: controller.currentPosition.value!,
        ),
      },
    );
  });
}
