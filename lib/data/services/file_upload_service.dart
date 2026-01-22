// import 'dart:convert';

// import 'package:dio/dio.dart';


// class FileUploadService {
//   final String uploadUrl =
//       '${API.baseUrl}/${API.apiVersion}/${API.postApis.uploadFile}';
//   final Dio _dio = Dio();

//   Future<Map<String, dynamic>?> uploadFile(XFile file, String authToken) async {
//     try {
//       String fileName = file.name;
//       FormData formData = FormData.fromMap({
//         "image": await MultipartFile.fromFile(file.path, filename: fileName),
//       });

//       Response response = await _dio.post(
//         uploadUrl,
//         data: formData,
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $authToken",
//             "Content-Type": "multipart/form-data",
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         return response.data;
//         // final jsonData = jsonDecode(response.data);
//         // return jsonData;
//       } else {
//         print('upload error: ' + response.data);
//         TLoaders.errorSnackBar(title: "Something went wrong");
//         return null;
//       }
//     } catch (e) {
//       print(e);
//       TLoaders.errorSnackBar(title: "Something went wrong");
//       return null;
//     }
//   }
// }
