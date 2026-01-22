// import 'package:dronees/modules/registerScreen/controllers/registerFormController.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class StepIndicator extends StatelessWidget {
//   final RegisterFormController controller = Get.find();

//   StepIndicator({super.key});

//   final List<String> stepLabels = const [
//     'Personal\nInformation',
//     'Licenses &\nCertification',
//     'Skill &\nModels Operated',
//   ];

//   //  @override
//   // Widget build(BuildContext context) {
//   //   return Obx(
//   //     () => Row(
//   //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //       children: List.generate(3, (index) {
//   //         bool isCompleted = controller.currentStep.value > index;
//   //         bool isActive = controller.currentStep.value == index;

//   //         return Stack(
//   //           children: [
//   //             // Circle (Step)
//   //             Column(
//   //               mainAxisSize: MainAxisSize.min,
//   //               children: [
//   //                 Container(
//   //                   width: 30,
//   //                   height: 30,
//   //                   decoration: BoxDecoration(
//   //                     shape: BoxShape.circle,
//   //                     color: isCompleted || isActive
//   //                         ? Colors.blue
//   //                         : Colors.grey[300],
//   //                     border: Border.all(
//   //                       color: Colors.blue,
//   //                       width: 2,
//   //                     ),
//   //                   ),
//   //                   child: Center(
//   //                     child: Text(
//   //                       '${index + 1}',
//   //                       style: TextStyle(
//   //                         color: isCompleted || isActive
//   //                             ? Colors.white
//   //                             : Colors.grey,
//   //                         fontWeight: FontWeight.bold,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 8),
//   //                 // Step label text under the circle (split into two lines)
//   //                 Text(
//   //                   ['Personal\nInformation', 'Licenses\n& Certification', 'Skill & Models \nOperated'][index],
//   //                   textAlign: TextAlign.center,
//   //                   style: TextStyle(
//   //                     color: isActive ? Colors.blue : Colors.grey,
//   //                     fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //             // Add a line between circles, but not after the last one
//   //             if (index < 2)
//   //               Positioned(
//   //                 left: 60,
//   //                 child: Container(
//   //                   width: 80, // The width of the line to span between circles
//   //                   height: 2,
//   //                   color: controller.currentStep.value > index
//   //                       ? Colors.blue
//   //                       : Colors.red,
//   //                 ),
//   //               ),
//   //           ],
//   //         );
//   //       }),
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () =>Container(
//           // decoration: BoxDecoration(color: Colors.green),
//           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           // height: 100,
//           child: Stack(
//             alignment: AlignmentGeometry.center,
//             children: [
//               Positioned(
//                 top: 12,
//                 child: Container(
//                   width:260, // Adjust the width of the line
//                   height: 2,
//                   color: Colors.grey[300],
//                 ),
//               ),

//         Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: List.generate(3, (index) {
//         bool isCompleted = controller.currentStep.value > index;
//         bool isActive = controller.currentStep.value == index;

//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Circle
//             Container(
//               width: 28,
//               height: 28,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: isCompleted || isActive
//                     ? (isActive ? Colors.blue : Colors.green)
//                     : Colors.grey[400],
//               ),
//               child: Center(
//                 child: Text(
//                   '${index + 1}', // Show step number
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//             ),
//             // Step label (for demonstration, adjust as needed)
//             Text(
//               stepLabels[index],
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: isActive ? Colors.black : Colors.grey[600],
//                 fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
//               ),
//             ),

//           ],
//         );
//       }),
//     )
//         ],
//       ),
//     )
//     );
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Obx(
//   //     () => Row(
//   //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //       children: List.generate(3, (index) {
//   //         bool isCompleted = controller.currentStep.value > index;
//   //         bool isActive = controller.currentStep.value == index;

//   //         return Expanded(
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             crossAxisAlignment: CrossAxisAlignment.center,
//   //             children: [
//   //               // Stack to overlap the circle and line, ensuring alignment
//   //               Stack(
//   //                 alignment: Alignment.center,
//   //                 children: [
//   //                   // Circle
//   //                   Container(
//   //                     width: 30,
//   //                     height: 30,
//   //                     decoration: BoxDecoration(
//   //                       shape: BoxShape.circle,
//   //                       color: isCompleted || isActive ? Colors.blue : Colors.grey[300],
//   //                       border: Border.all(
//   //                         color: Colors.blue,
//   //                         width: 2,
//   //                       ),
//   //                     ),
//   //                     child: Center(
//   //                       child: Text(
//   //                         '${index + 1}',
//   //                         style: TextStyle(
//   //                           color: isCompleted || isActive ? Colors.white : Colors.grey,
//   //                           fontWeight: FontWeight.bold,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ),

//   //                   // Line only for first 2 steps
//   //                    if (index == 0)
//   //                     Positioned(
//   //                       // right: 0,
//   //                       // left: 30,
//   //                       // top: 0, // Move the line lower so it's below the circle and not overlapping
//   //                       child: Container(
//   //                         height: 2,
//   //                         color: controller.currentStep.value > index
//   //                             ? Colors.blue
//   //                             : Colors.red,
//   //                       ),
//   //                     ),
//   //                 ],
//   //               ),

//   //               const SizedBox(height: 8),

//   //               // Step label aligned with circle
//   //               Text(
//   //                 ['Profile', 'Contact', 'Account'][index],
//   //                 textAlign: TextAlign.center,
//   //                 style: TextStyle(
//   //                   color: isActive ? Colors.blue : Colors.grey,
//   //                   fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //         );
//   //       }),
//   //     ),
//   //   );
//   // }
// }
