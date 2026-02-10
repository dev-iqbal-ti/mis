import 'dart:ui';
import 'package:flutter/material.dart';

class CustomBlurBottomSheet extends StatelessWidget {
  final Widget widget;

  const CustomBlurBottomSheet({super.key, required this.widget});

  // Updated static show method to accept parameters
  static void show(
    BuildContext context, {
    required Widget widget,
    bool isDismissible = true,
    Function()? onClosed,
  }) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      showDragHandle: false,
      context: context,
      backgroundColor: Colors.transparent,

      isScrollControlled: true,
      builder: (context) => CustomBlurBottomSheet(widget: widget),
    ).then((onValue) {
      onClosed != null ? onClosed() : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: const SizedBox.shrink(),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: widget,
        ),
      ],
    );
  }
}
