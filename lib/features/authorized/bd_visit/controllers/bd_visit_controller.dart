import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/bd_visit_model.dart';

class BDVisitController extends GetxController {
  static BDVisitController get instance => Get.find();
  RxList<BDVisit> visits = <BDVisit>[].obs;
  RxBool isLoading = false.obs;

  RxInt currentPage = 1.obs;
  final int pageSize = 10;

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  final clientNameController = TextEditingController();
  final purposeController = TextEditingController();
  final discussionSummaryController = TextEditingController();

  // Client dropdown (Optional)
  final RxList<String> clients = <String>[].obs;
  final Rxn<String> selectedClient = Rxn<String>(null);

  // Visit Type dropdown
  final RxList<String> visitTypes = <String>[
    'new_lead',
    'existing_client',
    'follow_up',
    'renewal',
  ].obs;
  final Rxn<String> selectedVisitType = Rxn<String>(null);

  // Visit Mode dropdown
  final RxList<String> visitModes = <String>['physical', 'virtual'].obs;
  final Rxn<String> selectedVisitMode = Rxn<String>(null);

  // Deal Stage dropdown
  final RxList<String> dealStages = <String>[
    'prospect',
    'proposal_sent',
    'negotiation',
    'closed_won',
    'closed_lost',
  ].obs;
  final Rxn<String> selectedDealStage = Rxn<String>(null);

  // Date dropdowns
  final RxList<DateTime> availableDates = <DateTime>[].obs;
  final Rx<DateTime?> selectedDepartureDate = Rx<DateTime?>(null);
  final Rx<DateTime?> selectedArrivalDate = Rx<DateTime?>(null);

  final departureDate = Rx<DateTime?>(null);
  final returnDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    fetchVisits();
    super.onInit();
    _initializeData();
  }

  @override
  void onClose() {
    // Dispose controllers
    clientNameController.dispose();
    purposeController.dispose();
    discussionSummaryController.dispose();
    super.onClose();
  }

  // Initialize data
  void _initializeData() {
    // Load clients from API or database
    _loadClients();

    // Generate available dates (next 30 days)
    _generateAvailableDates();
  }

  // Load clients (Replace with actual API call)
  void _loadClients() {
    // Example client data
    clients.value = [
      'ABC Corporation',
      'XYZ Industries',
      'Tech Solutions Ltd',
      'Global Services Inc',
      'Innovation Hub',
    ];
  }

  // Generate available dates for the next 30 days
  void _generateAvailableDates() {
    final now = DateTime.now();
    for (int i = 0; i < 30; i++) {
      availableDates.add(now.add(Duration(days: i)));
    }
  }

  /* ---------------- FETCH LIST ---------------- */
  Future<void> fetchVisits() async {
    isLoading.value = true;

    final response = await THttpHelper.getRequest(
      API.getApis.getBDVisits,
      queryParams: {
        'page': currentPage.value.toString(),
        'limit': pageSize.toString(),
      },
    );

    if (response == null) {
      isLoading.value = false;
      return;
    }

    final List data = response['data'];
    visits.value = data.map((e) => BDVisit.fromJson(e)).toList();

    isLoading.value = false;
  }

  /* ---------------- CREATE VISIT ---------------- */

  Future<void> createVisit() async {
    isLoading.value = true;

    final Map<String, dynamic> data = {
      "client_name": clientNameController.text,
      "visit_type": "1",
      "visit_mode": "1",
      "departure_date": departureDate.value?.toIso8601String(),
      "arrival_date": returnDate.value?.toIso8601String(),
      "purpose": purposeController.text,
    };

    final response = await THttpHelper.postRequest(
      API.postApis.createBDVisit,
      data,
    );

    if (response == null) {
      isLoading.value = false;
      return;
    }

    Get.back();
    fetchVisits();

    isLoading.value = false;
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final data = {
      'client_name': clientNameController.text.trim(),
      'visit_type': selectedVisitType.value,
      'visit_mode': selectedVisitMode.value,
      'departure_date': departureDate.value?.toIso8601String(),
      'arrival_date': returnDate.value?.toIso8601String(),
      'purpose': purposeController.text.trim(),
      'discussion_summary': discussionSummaryController.text.trim().isEmpty
          ? null
          : discussionSummaryController.text.trim(),
    };
    final response = await THttpHelper.postRequest(
      API.postApis.createBDVisit,
      data,
    );

    if (response == null) {
      isLoading.value = false;
      return;
    }

    Get.back();
    fetchVisits();
  }
}
