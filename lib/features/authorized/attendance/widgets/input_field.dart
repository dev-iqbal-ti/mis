import 'package:dronees/utils/constants/colors.dart';
import 'package:flutter/Material.dart';

Widget inputField({
  required String hint,
  required IconData icon,
  bool obscure = false,
  Widget? suffix,
}) {
  return TextFormField(
    obscureText: obscure,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      iconColor: TColors.primary,
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF2F4F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
