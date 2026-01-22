import 'package:dronees/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color lightGrey = Color(0xFFF5F5F5);
    const primaryColor = Color(0xFF7B61FF);
    const secondaryBgColor = Color(0xFFF7F8FA);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  // Header Buttons and Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "My Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      _buildHeaderButton(Icons.logout),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Profile Image with Edit Icon
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4), // Border effect
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            'https://api.dicebear.com/7.x/avataaars/png?seed=Masud', // Placeholder
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: lightGrey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Name and Email
                  const Text(
                    "Masud Rana",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "palash997739@gmail.com",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("CONTACT"),
                  _buildCard(secondaryBgColor, [
                    _buildListTile(Icons.email, "Tonald@gmail.com"),
                  ]),

                  _buildSectionTitle("ACCOUNT"),
                  _buildCard(secondaryBgColor, [
                    _buildListTile(
                      Icons.person,
                      "Personal Data",
                      hasNavigation: true,
                    ),
                  ]),

                  _buildSectionTitle("SETTINGS"),
                  _buildCard(secondaryBgColor, [
                    _buildListTile(
                      Icons.settings,
                      "Change Password",
                      hasNavigation: true,
                    ),
                    _buildListTile(
                      Icons.logout,
                      "Logout",
                      hasNavigation: true,
                      iconColor: Colors.red,
                    ),
                  ]),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F8F8),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.black, size: 20),
    );
  }

  // Helper widget to build the section headers (CONTACT, ACCOUNT, etc.)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          fontSize: 12,
        ),
      ),
    );
  }

  // Helper widget to build the grey container card
  Widget _buildCard(Color bgColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(children: children),
    );
  }

  // Helper widget to build individual rows
  Widget _buildListTile(
    IconData icon,
    String title, {
    bool hasNavigation = false,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: (iconColor ?? const Color(0xFF7B61FF)).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor ?? const Color(0xFF7B61FF),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: hasNavigation
          ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
          : null,
      dense: true,
      onTap: () {},
    );
  }
}
