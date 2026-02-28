import 'package:get/get.dart';

class GlobalDataRepository extends GetxController {
  static GlobalDataRepository get to => Get.find();

  // final RxList<GalleryItem> galleryImages = <GalleryItem>[].obs;

  // Future<bool> deleteImages(int id) async {
  //   final response = await THttpHelper.deleteRequest(
  //     API.deleteApis.deleteImage(id),
  //   );

  //   if (response == null) {
  //     return false;
  //   }

  //   if (response["success"] != true) {
  //     return false;
  //   }

  //   return false;
  // }
}
