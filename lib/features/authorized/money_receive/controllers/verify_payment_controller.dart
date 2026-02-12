import 'dart:developer';

import 'package:dronees/features/authorized/money_receive/models/payment_received_model.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:dronees/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class VerifyPaymentController extends GetxController {
  static VerifyPaymentController get instance => Get.find();

  // Pagination & Loading States
  RxBool isLoading = false.obs;
  RxBool isVerifying = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  int currentPage = 1;

  // Data Lists
  RxList<PaymentReceivedModel> payments = <PaymentReceivedModel>[].obs;

  // User Search for Dropdown
  RxList<dynamic> userList = <dynamic>[].obs; // Assuming you have a UserModel
  RxBool isUserLoading = false.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchPayments();
    // Setup Scroll Listener for infinite scroll
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (hasMoreData.value && !isLoadingMore.value) {
          fetchMorePayments();
        }
      }
    });
  }

  // --- Payment List Logic ---

  Future<void> fetchPayments() async {
    try {
      isLoading.value = true;
      currentPage = 1;

      final response = await THttpHelper.getRequest(
        API.getApis.moneyReceivedList,
        queryParams: {'page': currentPage.toString()},
      );

      if (response == null) {
        return;
      }

      if (response['success'] == true) {
        final List list = response['data'];
        payments.assignAll(
          list.map((e) => PaymentReceivedModel.fromJson(e)).toList(),
        );

        // Check if there is a next page
        hasMoreData.value =
            payments.length < response["pagination"]["totalPages"];
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMorePayments() async {
    try {
      isLoadingMore.value = true;
      currentPage++;

      final response = await THttpHelper.getRequest(
        API.getApis.moneyReceivedList,
        queryParams: {'page': currentPage.toString()},
      );
      if (response == null) {
        currentPage--;
        return;
      }

      if (response['success'] == true) {
        final List list = response['data']['data'];
        payments.addAll(
          list.map((e) => PaymentReceivedModel.fromJson(e)).toList(),
        );
        hasMoreData.value =
            payments.length < response["pagination"]["totalPages"];
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> verifyPayment(int id) async {
    try {
      isVerifying.value = true;
      final response = await THttpHelper.putRequest(
        API.getApis.verifyPayment(id),
      );
      if (response == null) {
        isLoading.value = false;
        return;
      }
      if (response['success'] == true) {
        final index = payments.indexWhere((payment) => payment.id == id);
        if (index != -1) {
          // remove the payment from the list
          payments.removeAt(index);
        }
        isLoading.value = false;
        Get.back();
        TLoaders.successSnackBar(
          title: "Success",
          message: "Payment Verified Successfully",
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // --- Remote Search for Dropdown ---

  // Future<void> searchUsers(String query) async {
  //   try {
  //     isUserLoading.value = true;
  //     final response = await THttpHelper.getRequest(
  //       API.getApis.searchUsers, // Replace with your actual search API
  //       queryParams: {'q': query},
  //     );

  //     if (response['success'] == true) {
  //       final List list = response['data'];
  //       userList.assignAll(list.map((e) => UserModel.fromJson(e)).toList());
  //     }
  //   } finally {
  //     isUserLoading.value = false;
  //   }
  // }
}
