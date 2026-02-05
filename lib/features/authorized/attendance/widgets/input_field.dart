import 'package:dronees/utils/constants/colors.dart';
import 'package:flutter/Material.dart';

Widget inputField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool obscure = false,
  String? Function(String?)? validator,
  Widget? suffix,
}) {
  return TextFormField(
    controller: controller,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: validator,
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
