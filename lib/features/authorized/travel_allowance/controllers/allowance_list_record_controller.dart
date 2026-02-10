import 'dart:developer';

import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:dronees/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/travel_allowance_model.dart';

class AllowanceListRecordController extends GetxController {
  final scrollController = ScrollController();
  static AllowanceListRecordController get instance => Get.find();

  // Observable lists and states
  final allowances = <TravelAllowance>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isFilterVisible = false.obs;

  // Filter parameters
  final selectedStatus = Rx<String?>('Approved by Department');
  final selectedUserId = Rx<String?>(null);
  DateTime? startDate;
  DateTime? endDate;

  // Pagination
  int currentPage = 1;
  final int limit = 10;
  bool hasMore = true;

  // Status options
  // final List<String> statusOptions = [
  //   'Approved by Department',
  //   'Pending',
  //   'Approved',
  //   'Rejected',
  //   'Draft',
  //   'Submitted',
  // ];

  @override
  void onInit() {
    super.onInit();
    // Get status from arguments (passed from parent screen)
    if (Get.arguments != null && Get.arguments is String) {
      final initialStatus = Get.arguments as String;
      selectedStatus.value = initialStatus;
    } else if (Get.arguments != null && Get.arguments is Map) {
      final initialStatus = Get.arguments['status'] as String?;
      selectedStatus.value = initialStatus;
    } else {
      selectedStatus.value = 'Approved by Department';
    }
    log(selectedStatus.value.toString());
    scrollController.addListener(_onScroll);
    fetchAllowances();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isLoadingMore.value && hasMore) {
        loadMore();
      }
    }
  }

  Future<void> fetchAllowances({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      hasMore = true;
      allowances.clear();
    }

    if (selectedStatus.value == null) {
      // Get.snackbar('Error', 'Please select a status');
      return;
    }

    isLoading.value = true;
    final query = _buildQueryParams();
    log(query.toString());
    try {
      final response = await THttpHelper.getRequest(
        API.getApis.getTravelAllowanceReportList,
        queryParams: _buildQueryParams(),
      );
      if (response == null) {
        isLoading.value = false;
        return;
      }
      log(response.toString());
      final List<dynamic> data = response['data'] ?? [];
      final List<TravelAllowance> newAllowances = data
          .map((json) => TravelAllowance.fromJson(json))
          .toList();

      if (refresh) {
        allowances.value = newAllowances;
      } else {
        allowances.addAll(newAllowances);
      }

      hasMore = currentPage < (response['pagination']['totalPages'] ?? 0);
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error", message: "Something went wrong");

      print('Error fetching allowances: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value) return;

    isLoadingMore.value = true;
    currentPage++;

    try {
      final response = await THttpHelper.getRequest(
        API.getApis.getTravelAllowanceReportList,
        queryParams: _buildQueryParams(),
      );
      if (response == null) {
        isLoading.value = false;
        return;
      }

      final List<dynamic> data = response['data'] ?? [];
      final List<TravelAllowance> newAllowances = data
          .map((json) => TravelAllowance.fromJson(json))
          .toList();

      allowances.addAll(newAllowances);
      hasMore = currentPage < (response['pagination']['totalPages'] ?? 0);
    } catch (e) {
      currentPage--;
      Get.snackbar(
        'Error',
        'Failed to load more',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshAllowances() async {
    await fetchAllowances(refresh: true);
  }

  Map<String, dynamic> _buildQueryParams() {
    final params = <String, dynamic>{};

    if (selectedStatus.value != null) {
      params['status'] = selectedStatus.value;
    }

    if (selectedUserId.value != null) {
      params['userId'] = selectedUserId.value;
    }

    if (startDate != null) {
      params['startDate'] = startDate!.toIso8601String();
    }

    if (endDate != null) {
      params['endDate'] = endDate!.toIso8601String();
    }

    return params;
  }

  void toggleFilter() {
    isFilterVisible.value = !isFilterVisible.value;
  }

  void applyFilters() {
    fetchAllowances(refresh: true);
    isFilterVisible.value = false;
  }

  void clearFilters() {
    selectedUserId.value = null;
    startDate = null;
    endDate = null;
    fetchAllowances(refresh: true);
  }

  Future<void> selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF6C5CE7)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      startDate = picked.start;
      endDate = picked.end;
      update();
    }
  }

  // void navigateToDetail(TravelAllowance allowance) {
  //   Get.toNamed('/travel-allowance-detail', arguments: allowance);
  //   // Or if you're not using named routes:
  //   // Get.to(() => TravelAllowanceDetailScreen(allowance: allowance));
  // }
}
