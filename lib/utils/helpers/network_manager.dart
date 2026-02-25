import 'dart:async';
import 'package:dronees/utils/constants/image_strings.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/logging/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../popups/loaders.dart';

/// Manages the network connectivity status and provides methods to check and handle connectivity changes.
class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();
  bool _wasOffline = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final RxList<ConnectivityResult> _connectionStatus =
      RxList<ConnectivityResult>([ConnectivityResult.none]);

  /// Initialize the network manager and set up a stream to continually check the connection status.
  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  /// Update the connection status based on changes in connectivity and show a relevant popup for no internet connection.
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    final isOffline = result.contains(ConnectivityResult.none);

    if (isOffline && !_wasOffline) {
      _showNoInternetDialog();
    }

    if (!isOffline && _wasOffline) {
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close dialog automatically when internet returns
      }
    }

    _wasOffline = isOffline;
  }

  /// Check the internet connection status.
  /// Returns `true` if connected, `false` otherwise.
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      TLoggerHelper.customPrint(
        result.map((element) => element.name).toList().toString(),
      );
      return !result.contains(ConnectivityResult.none);
    } on PlatformException catch (_) {
      return false;
    }
  }

  void _showNoInternetDialog() {
    Get.dialog(
      Dialog(
        elevation: 5,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Animation Section
              // You can get free Lottie JSON files from lottiefiles.com
              SizedBox(
                height: 150,
                child: Lottie.asset(
                  TImages.noInternet, // Sample "No Internet" animation
                  repeat: true,
                ),
              ),

              const SizedBox(height: 16),

              // 2. Text Section
              const Text(
                'Whoops!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'No internet connection found. Check your connection or try again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),

              const SizedBox(height: 24),

              // 3. Action Section
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    // Show a quick snackbar or simple loader logic here
                    bool connected = await isConnected();
                    if (connected) {
                      Get.back();
                    } else {
                      // Quick shake animation or feedback
                      Get.snackbar(
                        "Still Offline",
                        "Please check your Wi-Fi or Data",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.black87,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      transitionCurve: Curves.easeInOutBack, // Built-in GetX entrance animation
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  /// Dispose or close the active connectivity stream.
  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }
}
