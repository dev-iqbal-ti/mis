import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/equipment/controllers/equipment_controller.dart';
import 'package:dronees/features/authorized/equipment/models/equipment.dart';
import 'package:dronees/features/authorized/equipment/screens/assign_equipment_screen.dart';
import 'package:dronees/utils/helpers/image_picker_helper.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:dronees/widgets/custom_alert_sheet.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AssignEquipmentController extends GetxController {
  final equipmentList = <EquipmentModel>[].obs;
  final selectedEquipment = Rx<EquipmentModel?>(null);
  final projectNameController = TextEditingController();
  final remarkController = TextEditingController();
  final selectedImage = Rx<File?>(null);

  // *Global key for equipment form....
  GlobalKey<FormState> equipmentFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _fetchEquipment();
  }

  @override
  void onClose() {
    projectNameController.dispose();
    remarkController.dispose();
    super.onClose();
  }

  void _fetchEquipment() async {
    final response = await THttpHelper.getRequest(API.getApis.getEquipments);
    if (response == null) return;
    final data = equipmentModelFromJson(json.encode(response["data"]));
    if (data.isEmpty) {
      CustomBlurBottomSheet.show(
        Get.context!,
        widget: CustomAlertSheet(
          title: "No equipments found",
          message:
              "No equipments found. Please Contact Admin to add an equipment.",
          buttonText: "Go Back",
          onAction: () {
            Get.back();
            Get.back();
          },
        ),
        isDismissible: false,
        enaleDrag: false,
      );
    }
    equipmentList.value = data;
  }

  Future<void> pickImage(FormFieldState<File> field) async {
    final file = await ImageUploadService.pickImageFromSource(
      ImageSource.camera,
    );

    if (file != null) {
      selectedImage.value = file;
      field.didChange(file);
    }
  }

  void _clearForm() {
    equipmentFormKey.currentState?.reset();
    projectNameController.clear();
    remarkController.clear();
    selectedImage.value = null;
    selectedEquipment.value = null;
  }

  void assignEquipment(EquipmentModel equipment) async {
    final assignment = <String, dynamic>{
      "equipmentId": equipment.id,
      "userId": AuthController.instance.authUser?.userDetails.id,
      "remark": remarkController.text,
      "projectOrLocation": projectNameController.text,
    };

    final response = await THttpHelper.formDataRequest(
      API.postApis.assignEquipment,
      selectedImage.value,
      assignment,
    );

    if (response == null) {
      return;
    }
    EquipmentController.instance.refreshAssignments();
    _clearForm();
    Get.back();
  }
}
