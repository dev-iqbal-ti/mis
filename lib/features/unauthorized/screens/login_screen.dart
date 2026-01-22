import 'dart:ui';

import 'package:dronees/features/authorized/attendance/widgets/input_field.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscure = true;
  bool remember = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 99, 37, 255),
              Color.fromARGB(255, 166, 145, 250),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -20,
                    left: -15,
                    right: -20,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // perspective
                        ..rotateZ(-0.15) // 30 degree tilt
                        ..rotateX(0.1) // vertical depth
                        ..rotateY(-0.2),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        width: 320,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _cardContainer(),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              const _declaration(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TSizes.defaultPadding),
      padding: const EdgeInsets.all(TSizes.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              TTexts.signInBtn,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              TTexts.signInToAccount,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          _label("Email"),
          inputField(hint: "joedoe75@gmail.com", icon: Icons.mail_outline),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          _label("Password"),
          inputField(
            hint: "********",
            icon: Icons.lock_outline,
            obscure: obscure,
            suffix: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () {
                setState(() => obscure = !obscure);
              },
            ),
          ),

          // const SizedBox(height: TSizes.minSpaceBtw - 4),
          Row(
            children: [
              Checkbox(
                value: remember,
                onChanged: (v) {
                  setState(() => remember = v!);
                },
                activeColor: const Color(0xFF2F6DF6),
              ),
              const Text("Remember me"),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Forget password?",
                  style: TextStyle(color: TColors.buttonPrimary),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.minSpaceBtw),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () {},
              child: const Text("Login", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _declaration extends StatelessWidget {
  const _declaration({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultPadding),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(fontSize: 12, color: Colors.grey),
            children: [
              TextSpan(text: "By logging in, you agree to our "),
              TextSpan(
                text: "Terms & Conditions",
                style: TextStyle(
                  color: Color(0xFF2F6DF6),
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(text: " and "),
              TextSpan(
                text: "Privacy Policy",
                style: TextStyle(
                  color: Color(0xFF2F6DF6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
