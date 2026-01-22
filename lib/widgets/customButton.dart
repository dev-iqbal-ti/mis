import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool filled;
  final double height;
  final double width;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final Gradient? gradient;
  final Gradient? selectedGradient; // New parameter for role button gradient
  final bool isLoading;
  final Widget? loadingWidget;
  final Color? disabledBackgroundColor;

  const CustomButton({
    required this.text,
    this.onPressed,
    this.filled = true,
    this.height = 48,
    this.width = double.infinity,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius = 8,
    this.textStyle,
    this.gradient,
    this.selectedGradient,
    this.isLoading = false,
    this.loadingWidget,
    this.disabledBackgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Gradient button for sign-up or selected role buttons
    if (gradient != null || (filled && selectedGradient != null)) {
      final activeGradient = gradient ?? selectedGradient;

      return SizedBox(
        height: height,
        width: width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: activeGradient,
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              disabledBackgroundColor: Colors.grey,
            ),
            child: isLoading
                ? (loadingWidget ??
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ))
                : Text(
                    text,
                    style:
                        textStyle ??
                        const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
          ),
        ),
      );
    }

    // Regular filled or outlined button
    return SizedBox(
      height: height,
      width: width,
      child: filled
          ? ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? Colors.blueAccent,
                foregroundColor: foregroundColor ?? Colors.white,
                disabledBackgroundColor: disabledBackgroundColor ?? Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: isLoading
                  ? (loadingWidget ??
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ))
                  : Text(
                      text,
                      style:
                          textStyle ??
                          const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
            )
          : OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: backgroundColor ?? Colors.white,
                foregroundColor: foregroundColor ?? Colors.blueAccent,
                disabledBackgroundColor: disabledBackgroundColor ?? Colors.grey,
                side: BorderSide(
                  color: borderColor ?? Colors.blueAccent,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: EdgeInsets.zero,
              ),
              child: isLoading
                  ? (loadingWidget ??
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blueAccent,
                            ),
                          ),
                        ))
                  : Text(
                      text,
                      style:
                          textStyle ??
                          const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
            ),
    );
  }
}