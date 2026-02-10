import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/equipment/models/assign_equipment.dart';
import 'package:dronees/features/authorized/equipment/models/equipment.dart';
import 'package:dronees/features/authorized/equipment/screens/assign_equipment_screen.dart';
import 'package:dronees/utils/helpers/image_picker_helper.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EquipmentController extends GetxController {
  static EquipmentController get instance => Get.find();
  RxList<AssignEquipment> assignEquipmentList = RxList<AssignEquipment>([]);
  RxBool isLoading = RxBool(false);

  final returnImage = Rx<File?>(null);
  final returnFormKey = GlobalKey<FormState>();
  final returnRemarkController = TextEditingController();

  RxInt assignedEquipment = RxInt(0);
  RxInt availableEquipment = RxInt(0);
  RxInt equipmentList = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    _fetchAssignEquipment();
  }

  @override
  void onClose() {
    returnRemarkController.dispose();
    super.onClose();
  }

  void _fetchAssignEquipment() async {
    final response = await THttpHelper.getRequest(
      API.getApis.getAssignedEquipments,
      queryParams: {
        "user_id": AuthController.instance.authUser?.userDetails.id.toString(),
      },
    );
    if (response == null) return;
    assignedEquipment.value = response["data"]["assignedCount"];
    availableEquipment.value = response["data"]["availableCount"];
    equipmentList.value = response["data"]["totalCount"];
    assignEquipmentList.value = assignEquipmentFromJson(
      json.encode(response["data"]["rows"]),
    );
  }

  Future<void> pickReturnImage(FormFieldState<File> field) async {
    final file = await ImageUploadService.pickImageFromSource(
      ImageSource.gallery,
    );

    if (file != null) {
      returnImage.value = file;
      field.didChange(file);
    }
  }

  void finalizeReturn(AssignEquipment equipment) async {
    if (returnFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      final unAssign = <String, dynamic>{
        "equipmentId": equipment.equipmentId,
        "remark": returnRemarkController.text,
      };

      final response = await THttpHelper.formDataRequest(
        API.postApis.unassignEquipment,
        returnImage.value,
        unAssign,
      );
      isLoading.value = false;

      if (response == null) {
        return;
      }
      _fetchAssignEquipment();
      _clearForm();
      Get.back(); // Close Bottom Sheet
    }
  }

  void refreshAssignments() {
    _fetchAssignEquipment();
  }

  void _clearForm() {
    returnRemarkController.clear();
    returnImage.value = null;
  }

  void goToAssignScreen() {
    Get.to(() => const AssignEquipmentScreen());
  }
}
