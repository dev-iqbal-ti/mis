import 'dart:developer';
import 'dart:io';

import 'package:dronees/features/authorized/equipment/models/equipment.dart';
import 'package:dronees/features/authorized/equipment/screens/assign_equipment_screen.dart';
import 'package:dronees/utils/helpers/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EquipmentController extends GetxController {
  final equipmentList = <Equipment>[].obs;
  final selectedEquipment = Rx<Equipment?>(null);
  final projectNameController = TextEditingController();
  final remarkController = TextEditingController();
  final selectedImage = Rx<File?>(null);
  final returnImage = Rx<File?>(null);
  final returnFormKey = GlobalKey<FormState>();
  final returnRemarkController = TextEditingController();
  // final selectedFile = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  // *Global key for equipment form....
  GlobalKey<FormState> equipmentFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _loadEquipment();
  }

  void _loadEquipment() {
    equipmentList.value = [
      Equipment(id: '1', name: 'DJI Air 3 UAV & Accessories'),
      Equipment(id: '2', name: 'DJI Mavic 4 Pro UAV & Accessories'),
      Equipment(id: '3', name: 'South Galaxy G1 Pro DGPS'),
      Equipment(id: '4', name: 'Spectra SP85 DGPS (Unit 1)'),
      Equipment(id: '5', name: 'Spectra SP85 DGPS (Unit II)'),
      Equipment(id: '6', name: 'ideaForge Q6 UAV & Accessories'),
      Equipment(id: '7', name: 'ideaForge Q6 V2 UAV & Accessories'),
      Equipment(id: '8', name: 'ideaForge RYNO UAV & Accessories'),
    ];
  }

  List<Equipment> get assignedEquipment =>
      equipmentList.where((e) => e.isAssigned).toList();

  List<Equipment> get availableEquipment =>
      equipmentList.where((e) => !e.isAssigned).toList();

  Future<void> pickImage(FormFieldState<File> field) async {
    final file = await ImageUploadService.pickImageFromSource(
      ImageSource.gallery,
    );

    if (file != null) {
      selectedImage.value = file;
      field.didChange(file);
    }
  }

  Future<void> pickReturnImage(FormFieldState<File> field) async {
    final file = await ImageUploadService.pickImageFromSource(
      ImageSource.camera,
    );

    if (file != null) {
      returnImage.value = file;
      field.didChange(file);
    }
  }

  void finalizeReturn(Equipment equipment) {
    if (returnFormKey.currentState?.validate() ?? false) {
      log(returnImage.value.toString());
      if (returnImage.value == null) {
        Get.snackbar(
          "Photo Required",
          "Please take a photo of the equipment state.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final index = equipmentList.indexWhere((e) => e.id == equipment.id);
      if (index != -1) {
        equipmentList[index] = equipment.copyWith(
          isAssigned: false,
          assignedTo: null,
          assignedDate: null,
          projectName: null,
          remark: null, // Clear old remarks
          photoUrl: null, // Clear old photo
        );

        // Reset return form
        returnRemarkController.clear();
        returnImage.value = null;

        Get.back(); // Close Bottom Sheet
        Get.snackbar(
          "Success",
          "${equipment.name} returned to office.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    }
  }

  void submitEquipment(Equipment equipment) {
    final index = equipmentList.indexWhere((e) => e.id == equipment.id);
    if (index != -1) {
      equipmentList[index] = equipment.copyWith(
        isAssigned: false,
        assignedTo: null,
        assignedDate: null,
        projectName: null,
        remark: null,
        photoUrl: null,
      );
      Get.snackbar(
        'Success',
        'Equipment submitted to office',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _clearForm() {
    equipmentFormKey.currentState?.reset();
    projectNameController.clear();
    remarkController.clear();
    selectedImage.value = null;
    selectedEquipment.value = null;
  }

  void assignEquipment(Equipment equipment) {
    if (projectNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Project name is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedEquipment.value == null) {
      Get.snackbar(
        'Error',
        'Please select an equipment',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final index = equipmentList.indexWhere((e) => e.id == equipment.id);
    if (index != -1) {
      equipmentList[index] = equipment.copyWith(
        isAssigned: true,
        assignedTo: 'Current User', // Replace with real user data
        assignedDate: DateTime.now().toString().split(' ')[0],
        projectName: projectNameController.text,
        remark: remarkController.text,
        photoUrl: selectedImage.value?.path,
      );

      _clearForm();
      Get.back();
    }
  }

  // Ensure you clear the form before navigating to the Assign screen
  void goToAssignScreen() {
    _clearForm();
    Get.to(() => const AssignEquipmentScreen());
  }

  @override
  void onClose() {
    projectNameController.dispose();
    remarkController.dispose();
    super.onClose();
  }
}
