import 'dart:ui';

import 'package:dronees/features/authorized/equipment/screens/equipment_tracking_screen.dart';
import 'package:dronees/features/authorized/field_task/screens/field_task_screen.dart';
import 'package:dronees/features/authorized/leave/screens/leave_summary_screen.dart';
import 'package:dronees/features/authorized/money_receive/screens/money_receive_screen.dart';
import 'package:dronees/models/quick_action.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

final List<QuickAction> homeScreenQuickActions = [
  // QuickAction(
  //   icon: Iconsax.gallery_add,
  //   title: 'Upload',
  //   subtitle: 'Add images',
  //   color: const Color(0xFF6C5CE7),
  //   onTap: () {},
  // ),
  // QuickAction(
  //   icon: Iconsax.receipt_add,
  //   title: 'Submit TA',
  //   subtitle: 'New claim',
  //   color: const Color(0xFF00D9A5),
  //   onTap: () {},
  // ),
  QuickAction(
    icon: Iconsax.box,
    title: 'Equipment Tracking',
    subtitle: 'View equipment',
    color: const Color(0xFFFF6B6B),
    onTap: () => Get.to(() => EquipmentScreen()),
  ),
  QuickAction(
    icon: Iconsax.calendar_circle,
    title: 'Leave Management',
    subtitle: 'Apply & view status', // Updated text
    color: const Color(0xFF45AAF2),
    onTap: () => Get.to(() => LeaveSummaryScreen()),
  ),
  QuickAction(
    icon: Iconsax.money,
    title: 'Money Receives',
    subtitle: 'Track payments',
    color: const Color(0xFFF1C40F),
    onTap: () => Get.to(() => MoneyReceiveScreen()),
  ),
  QuickAction(
    icon: Iconsax.task,
    title: 'Field Task',
    subtitle: 'Client compliance',
    color: const Color(0xFF2ECC71),
    onTap: () => Get.to(() => FieldTaskScreen()),
  ),
];
