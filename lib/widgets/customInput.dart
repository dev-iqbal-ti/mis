// import 'package:flutter/material.dart';

// class CustomInput extends StatefulWidget {
//   final String label;
//   final TextEditingController controller;
//   final TextInputType keyboardType;
//   final bool obscureText;
//   final FormFieldValidator<String>? validator;

//   const CustomInput({
//     required this.label,
//     required this.controller,
//     this.keyboardType = TextInputType.text,
//     this.obscureText = false,
//     this.validator,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<CustomInput> createState() => _CustomInputState();
// }

// class _CustomInputState extends State<CustomInput> {
//   late bool _obscurePassword;

//   @override
//   void initState() {
//     super.initState();
//     _obscurePassword = widget.obscureText; // Initialize with passed value
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: widget.controller,
//       keyboardType: widget.keyboardType,
//       obscureText: _obscurePassword,
//       decoration: InputDecoration(
//         labelText: widget.label,
//         border: const UnderlineInputBorder(),
//         // Show suffix icon only for password fields
//         suffixIcon: widget.obscureText
//             ? IconButton(
//                 icon: Icon(
//                   _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _obscurePassword = !_obscurePassword;
//                   });
//                 },
//               )
//             : null, // No icon for non-password fields
//       ),
//       validator: widget.validator,
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final bool isdisable;

  const CustomInput({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.isdisable = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late bool _obscurePassword;

  @override
  void initState() {
    super.initState();
    _obscurePassword = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.blue, // Label color when focused or typed
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.8,
          ),
        ),
        // Password visibility toggle
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[700],
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
      enabled: !widget.isdisable,
    );
  }
}
