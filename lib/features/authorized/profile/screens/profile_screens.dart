import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/profile/controllers/profile_controller.dart';
import 'package:dronees/features/authorized/profile/screens/change_password_screen.dart';
import 'package:dronees/utils/constants/sizes.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    final user = AuthController.instance.authUser?.userDetails;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: RefreshIndicator(
        onRefresh: () => ProfileController.instance.refreshProfile(),
        edgeOffset: 120,
        child: CustomScrollView(
          slivers: [
            // --- THE ANIMATED HEADER ---
            SliverPersistentHeader(
              pinned: true,
              delegate: ProfileHeaderDelegate(
                userName: user?.fullName ?? "User Name",
                userRole: user?.rolesDisplayNames ?? "Employee",
                profilePic: user?.profilePic,
              ),
            ),

            // --- THE CONTENT ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultPadding,
                ),
                child: Column(
                  children: [
                    _buildSection("CONTACT", [
                      _buildTile(
                        Icons.alternate_email_rounded,
                        "Email",
                        user?.emailId,
                      ),
                      _buildTile(
                        Icons.phone_iphone_rounded,
                        "Phone",
                        user?.contactNo,
                      ),
                      _buildTile(
                        Icons.location_on_outlined,
                        "Address",
                        user?.currentAddress,
                      ),
                    ]),
                    // _buildSection("PERSONAL", [
                    //   _buildTile(
                    //     Icons.cake_outlined,
                    //     "Birthday",
                    //     user?.dateOfBirth?.toString().split(' ').first,
                    //   ),
                    //   _buildTile(Icons.bloodtype_outlined, "Blood Group", "B+"),
                    //   _buildTile(
                    //     Icons.badge_outlined,
                    //     "Employee ID",
                    //     user?.id != null ? "#${user!.id}" : "N/A",
                    //   ),
                    // ]),
                    _buildSection("SETTINGS", [
                      _buildTile(
                        Icons.lock_reset_rounded,
                        "Change Password",
                        "Security",
                        isAction: true,
                        onTap: () {
                          Get.to(() => const ChangePasswordScreen());
                        },
                      ),
                      _buildTile(
                        Icons.logout_rounded,
                        "Logout",
                        "Sign out of account",
                        isAction: true,
                        color: Colors.red,
                        onTap: () => AuthController.instance.logout(),
                      ),
                    ]),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 20, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTile(
    IconData icon,
    String title,
    String? value, {
    bool isAction = false,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? const Color(0xFF7B61FF)).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color ?? const Color(0xFF7B61FF), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      subtitle: value != null
          ? Text(value, style: const TextStyle(fontSize: 12))
          : null,
      trailing: isAction
          ? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
          : null,
    );
  }
}

// --- ANIMATION DELEGATE ---
class ProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String userName;
  final String userRole;
  final String? profilePic;

  ProfileHeaderDelegate({
    required this.userName,
    required this.userRole,
    this.profilePic,
  });

  @override
  double get maxExtent => 250;
  @override
  double get minExtent => 100;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double percent = (shrinkOffset / (maxExtent - minExtent)).clamp(
      0.0,
      1.0,
    );

    // Smoothly calculate positions
    final double avatarSize = (100 - (percent * 80)).clamp(50.0, 100.0);
    final double avatarLeft =
        (MediaQuery.of(context).size.width / 2 - avatarSize / 2) *
            (1 - percent) +
        (20 * percent);
    final double avatarTop = (70 * (1 - percent)) + (35 * percent);

    final double textLeft =
        (MediaQuery.of(context).size.width / 2 - 100) * (1 - percent) +
        (85 * percent);
    final double textTop = (170 * (1 - percent)) + (45 * percent);

    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          if (percent > 0.9)
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Stack(
        children: [
          // Background Decor
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: const Color(0xFF7B61FF).withOpacity(0.05),
            ),
          ),

          // Logout Button (Header Right)
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.black87),
              onPressed: () => AuthController.instance.logout(),
            ),
          ),

          // Profile Image
          Positioned(
            top: avatarTop,
            left: avatarLeft,
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF7B61FF), width: 2),
                image: DecorationImage(
                  image: NetworkImage(
                    profilePic ??
                        'https://api.dicebear.com/7.x/avataaars/png?seed=employer',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Name and Role
          Positioned(
            top: textTop,
            left: textLeft,
            child: Column(
              crossAxisAlignment: percent > 0.5
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    userName,
                    textAlign: percent > 0.5
                        ? TextAlign.left
                        : TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: (20 - (percent * 4)).clamp(16.0, 20.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                Text(
                  userRole,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant ProfileHeaderDelegate oldDelegate) {
    return oldDelegate.userName != userName ||
        oldDelegate.userRole != userRole ||
        oldDelegate.profilePic != profilePic;
  }
}
