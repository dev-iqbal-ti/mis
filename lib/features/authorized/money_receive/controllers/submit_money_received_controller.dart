import 'dart:convert';
import 'dart:io';

import 'package:dronees/features/authorized/money_receive/controllers/money_receive_controller.dart';
import 'package:dronees/features/authorized/money_receive/models/payment_received_model.dart';
import 'package:dronees/features/authorized/money_receive/models/projects_model.dart';
import 'package:dronees/utils/helpers/image_picker_helper.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SubmitMoneyReceivedController extends GetxController {
  final paymentFormKey = GlobalKey<FormState>();
  RxList<ProjectsModel> projects = <ProjectsModel>[].obs;
  var selectedProject = Rxn<ProjectsModel>(null);
  var selectedMode = Rxn<String>();
  var selectedImage = Rx<File?>(null);

  final amountController = TextEditingController();
  final remarkController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchProjects();
  }

  @override
  void onClose() {
    super.onClose();
    amountController.dispose();
    remarkController.dispose();
  }

  Future<void> _fetchProjects() async {
    final response = await THttpHelper.getRequest(API.getApis.getProjects);

    if (response == null) {
      return;
    }
    projects.value = projectsModelFromJson(jsonEncode(response["data"]));
  }

  void submitPaymentRecord() async {
    isLoading.value = true;
    final data = <String, dynamic>{
      "project_id": selectedProject.value?.id,
      "amount": amountController.text,
      "method": selectedMode.value,
      "remark": remarkController.text,
    };

    final response = await THttpHelper.formDataRequest(
      API.postApis.submitMoneyReceived,
      selectedImage.value,
      data,
    );
    isLoading.value = false;
    if (response == null) return;
    final dataReceived = PaymentReceivedModel.fromJson(response["data"]);
    MoneyReceiveController.instance.addRecord(dataReceived);
    _resetForm();
    Get.back();
  }

  void _resetForm() {
    selectedProject.value = null;
    selectedMode.value = null;
    selectedImage.value = null;
    amountController.clear();
    remarkController.clear();
  }

  Future<void> pickImage(FormFieldState<File> field) async {
    final image = await ImageUploadService.pickImageFromSource(
      ImageSource.gallery,
    );
    if (image != null) {
      selectedImage.value = image;
      field.didChange(image);
    }
  }
}
