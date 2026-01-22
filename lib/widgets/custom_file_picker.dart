import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/widgets/upload_document.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CustomFilePicker extends StatelessWidget {
  const CustomFilePicker({
    super.key,
    required this.onPick,
    this.initialValue,
    this.validator,
    this.title = "Upload Image",
    this.height = 220,
    this.subTitle,
  });

  final File? initialValue;
  final String? subTitle;
  final String title;
  final double height;

  /// Called when user taps picker
  /// You get FormFieldState so you can call field.didChange(file)
  final Future<void> Function(FormFieldState<File> field) onPick;

  final String? Function(File?)? validator;

  @override
  Widget build(BuildContext context) {
    return FormField<File>(
      initialValue: initialValue,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<File> field) {
        return GestureDetector(
          onTap: () => onPick(field),
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              dashPattern: const [7, 5],
              strokeWidth: 1,
              radius: const Radius.circular(16),
              color: field.hasError
                  ? TColors.error
                  : TColors.primary.withAlpha(200),
            ),
            child: field.value == null
                ? UploadDocument(title: title, subTitle: subTitle, field: field)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.file(
                          field.value!,
                          width: double.infinity,
                          height: height,
                          fit: BoxFit.cover,
                        ),
                        const Positioned(
                          right: 10,
                          top: 10,
                          child: Icon(
                            Iconsax.refresh_circle,
                            color: TColors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
