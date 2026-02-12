import 'dart:convert';
import 'dart:io';

import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/money_receive/models/payment_received_model.dart';
import 'package:dronees/utils/helpers/image_picker_helper.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MoneyReceiveController extends GetxController {
  static MoneyReceiveController get instance => Get.find();

  final ScrollController scrollController = ScrollController();

  Rx<double> collection = Rx<double>(0.0);
  RxList<PaymentReceivedModel> moneyRecord = RxList<PaymentReceivedModel>();

  var isLoading = false.obs;
  var isMoreLoading = false.obs; // For the bottom loader
  int currentPage = 1;
  bool canLoadMore = true;

  @override
  void onInit() {
    super.onInit();
    _fetchTotalCollection();
    _fetchMoneyRecord(); // Initial load

    // Listen to scroll events
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        _fetchMoreMoneyRecord();
      }
    });
  }

  Future<void> onRefresh() async {
    currentPage = 1;
    canLoadMore = true;
    await _fetchTotalCollection();
    await _fetchMoneyRecord(isRefresh: true);
  }

  void addRecord(PaymentReceivedModel record) {
    moneyRecord.insert(0, record); // Insert at the beginning(record);
  }

  // Modified to handle initial load and refresh
  Future<void> _fetchMoneyRecord({bool isRefresh = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final response = await THttpHelper.getRequest(
        API.getApis.moneyReceivedList,
        queryParams: {
          'page': currentPage.toString(),
          "userId": AuthController.instance.authUser?.userDetails.id.toString(),
        },
      );

      if (response != null) {
        List<PaymentReceivedModel> newData = paymentReceivedModelFromJson(
          jsonEncode(response["data"]),
        );

        if (isRefresh) {
          moneyRecord.assignAll(newData);
        } else {
          moneyRecord.addAll(newData);
        }

        // Check if we should stop pagination (e.g., if less than 15 items returned)
        if (newData.length < 15) {
          canLoadMore = false;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Method for pagination
  Future<void> _fetchMoreMoneyRecord() async {
    if (isMoreLoading.value || !canLoadMore || isLoading.value) return;

    isMoreLoading.value = true;
    currentPage++;

    try {
      final response = await THttpHelper.getRequest(
        "${API.getApis.moneyReceivedList}?page=$currentPage",
      );

      if (response != null) {
        List<PaymentReceivedModel> newData = paymentReceivedModelFromJson(
          jsonEncode(response["data"]),
        );

        if (newData.isEmpty) {
          canLoadMore = false;
        } else {
          moneyRecord.addAll(newData);
        }
      }
    } finally {
      isMoreLoading.value = false;
    }
  }

  Future<void> _fetchTotalCollection() async {
    final response = await THttpHelper.getRequest(API.getApis.modenyCollection);
    if (response != null) {
      collection.value = response["data"]["total_received"] != null
          ? double.parse(response["data"]["total_received"].toString())
          : 0.0;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
