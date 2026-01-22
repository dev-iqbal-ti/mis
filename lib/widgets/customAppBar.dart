import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool headerShow; // Show the top title
  final bool backButtonShow; // Show back/hamburger button
  final bool searchBoxShow; // Show search box
  final bool notificationShow; // Show notification icon
  final bool dividerShow; // Show bottom divider
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;
  final TextEditingController? searchController;
  final bool drawerButtonShow;

  CustomAppBar({
    this.title,
    this.headerShow = true,
    this.backButtonShow = true,
    this.searchBoxShow = true,
    this.notificationShow = true,
    this.dividerShow = true,
    this.onBackPressed,
    this.onNotificationPressed,
    this.searchController,
    this.drawerButtonShow = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Only take as much height as needed
      children: [
        // Top Title
        if (headerShow)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: Text(
              title ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        // Bottom Row with back, search, notification
        Row(
          children: [
            // Left button
            if (backButtonShow)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
            else if(drawerButtonShow)
               IconButton(
                icon: const Icon(Icons.menu),
                onPressed: onBackPressed ?? () => print('open menu'),
              )
            else
            const SizedBox(width: 16), // spacing if no back button

            // Center search box
            if (searchBoxShow)
              Expanded(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              )
            else
              const Spacer(), // fill space if no search box

            // Right notification button
            if (notificationShow)
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: onNotificationPressed,
              ),
          ],
        ),
        const SizedBox(height: 3),
        // Divider
        if (dividerShow) const Divider(height: 1, thickness: 1),
      ],
    );
  }

  @override
  Size get preferredSize {
    double height = 0;
    if (headerShow) height += kToolbarHeight; // top title height
    if (backButtonShow || searchBoxShow || notificationShow) height += kToolbarHeight; // bottom row height
    if (dividerShow) height += 1; // divider height
    return Size.fromHeight(height);
  }
}
