// // Copyright 2019 The FlutterCandies author. All rights reserved.
// // Use of this source code is governed by an Apache license that can be found
// // in the LICENSE file.

// import 'package:flutter/material.dart';
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';
// import 'package:wechat_camera_picker/wechat_camera_picker.dart';

// /// Define a regular pick method.
// class PickMethod {
//   const PickMethod({
//     required this.method,
//   });

//   factory PickMethod.common(BuildContext context, int maxAssetsCount) {
//     return PickMethod(
//       method: (BuildContext context) {
//         return AssetPicker.pickAssets(
//           context,
//           pickerConfig: AssetPickerConfig(
//             maxAssets: maxAssetsCount,
//           ),
//         );
//       },
//     );
//   }

//   factory PickMethod.image(BuildContext context) {
//     return PickMethod(
//       method: (BuildContext context) {
//         return AssetPicker.pickAssets(
//           context,
//           pickerConfig:
//               AssetPickerConfig(requestType: RequestType.image, maxAssets: 200),
//         );
//       },
//     );
//   }

//   // Future<List<AssetEntity>?> handleCameraAndAssets(BuildContext context) async {
//   //   // Open camera and take picture
//   //   final AssetEntity? cameraResult = await _pickFromCamera(context);

//   //   // If we got a result from the camera, convert it to the expected List<AssetEntity>? format
//   //   if (cameraResult != null) {
//   //     return [cameraResult];
//   //   }

//   //   return null;
//   // }

//   // factory PickMethod.cameraOnly(BuildContext context) {
//   //   return PickMethod(
//   //     method: (BuildContext context) async {
//   //       return handleCameraAndAssets(context);
//   //     },
//   //   );
//   // }

//   /// The core function that defines how to use the picker.
//   final Future<List<AssetEntity>?> Function(
//     BuildContext context,
//   ) method;

//   // final GestureLongPressCallback? onLongPress;
// }
