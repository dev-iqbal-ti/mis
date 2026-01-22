import 'package:dronees/features/unauthorized/screens/login_screen.dart';
import 'package:dronees/utils/constants/colors.dart';
import 'package:dronees/utils/constants/image_strings.dart';
import 'package:dronees/utils/constants/text_strings.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slide_to_act/slide_to_act.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
              Color.fromARGB(255, 236, 232, 255),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Spacer(),
              buildFloatingCards(),
              _buildText(),
              const SizedBox(height: 25),
              _buildSlideButton(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlideButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        height: 60,
        child: SlideAction(
          borderRadius: 30,
          sliderRotate: false,
          elevation: 5,
          outerColor: TColors.darkBlack,
          innerColor: Colors.white,

          sliderButtonIcon: const Icon(
            Iconsax.play,
            color: TColors.darkBlack,
            size: 20,
          ),
          child: Container(
            height: 60,
            width: double.infinity,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(""),
                  Text(
                    "Slide to Sign in",
                    style: TextStyle(
                      color: TColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  // Icon(Iconsax.forward, color: TColors.white),
                  SvgPicture.asset(
                    TImages.forwardSvg,
                    semanticsLabel: 'Dart Logo',
                  ),
                ],
              ),
            ),
          ),
          onSubmit: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
            return null;
          },
        ),
      ),
    );
  }

  // Floating cards section
  Widget buildFloatingCards() {
    return SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 80, child: buildAnalyticsCard()),
          Positioned(top: 20, child: buildTaskCard()),
        ],
      ),
    );
  }
  // child: Image.asset(TImages.onboardImage, fit: BoxFit.cover),

  Widget buildTaskCard() {
    return Transform.rotate(
      angle: -0.08,
      child: cardContainer(
        width: 280,
        height: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today Task",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("The tasks assigned to you for today"),
            const SizedBox(height: 12),
            Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.flash_on, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Expanded(child: Text("Wiring Dashboard Analytics")),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "High",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnalyticsCard() {
    return Transform.rotate(
      angle: 0.06,
      child: cardContainer(
        width: 300,
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Working Period",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text("Average your working period"),
            const SizedBox(height: 15),
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.show_chart, color: Colors.purple, size: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardContainer({
    required double width,
    required double height,
    required Widget child,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: child,
    );
  }

  // Bottom text
  Widget _buildText() {
    return Column(
      children: const [
        Text(
          "Navigate Your Work\nJourney Efficient & Easy",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Increase your work management & career development radically",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  // Buttons
  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7F4DFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: const Text("Sign In", style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF7F4DFF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Sign Up",
                style: TextStyle(fontSize: 18, color: Color(0xFF7F4DFF)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
