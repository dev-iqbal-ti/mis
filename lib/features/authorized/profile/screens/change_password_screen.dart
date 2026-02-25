import 'package:dronees/features/authorized/profile/controllers/change_password_controller.dart';
import 'package:dronees/utils/constants/sizes.dart';
import 'package:dronees/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        title: const Text("Security", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultPadding),
        child: Form(
          key: controller.formKey,
          child: AnimatedBuilder(
            animation: controller.shakeController,
            builder: (context, child) {
              // Shake Logic calculation
              final sineValue = (controller.shakeController.value < 0.1)
                  ? 0.0
                  : (5 *
                        (1.0 - controller.shakeController.value) *
                        (controller.shakeController.value * 10).remainder(1.0));

              return Transform.translate(
                offset: Offset(sineValue * 5, 0),
                child: child,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Your new password must be different from previously used passwords.",
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // CURRENT PASSWORD
                _buildModernField(
                  label: "Current Password",
                  controller: controller.oldPasswordController,
                  isObscure: controller.isOldPasswordVisible,
                  validator: (value) =>
                      TValidator.emptyValidator(value, "Current Password"),
                ),

                const SizedBox(height: 20),

                // NEW PASSWORD + STRENGTH METER
                _buildModernField(
                  label: "New Password",
                  controller: controller.newPasswordController,
                  isObscure: controller.isNewPasswordVisible,
                  validator: TValidator.passwordValidator,
                ),

                // Strength Meter
                Obx(
                  () => Column(
                    children: [
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: controller.passwordStrength.value,
                          backgroundColor: Colors.grey[200],
                          color: controller.strengthColor.value,
                          minHeight: 6,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          controller.strengthText.value,
                          style: TextStyle(
                            color: controller.strengthColor.value,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // CONFIRM PASSWORD
                _buildModernField(
                  label: "Confirm New Password",
                  controller: controller.confirmPasswordController,
                  isObscure: controller.isConfirmPasswordVisible,
                  validator: (value) => TValidator.confirmPasswordValidator(
                    value,
                    controller.newPasswordController.text,
                  ),
                ),

                const SizedBox(height: 40),

                // SUBMIT
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.validateAndSave,
                      child: controller.isLoading.value
                          ? const CupertinoActivityIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Save Changes",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernField({
    required String label,
    required TextEditingController controller,
    required RxBool isObscure,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            obscureText: !isObscure.value,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              errorStyle: const TextStyle(color: Colors.redAccent),
              suffixIcon: IconButton(
                icon: Icon(
                  isObscure.value ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                ),
                onPressed: () => isObscure.toggle(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
