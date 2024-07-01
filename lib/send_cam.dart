import 'package:dio/dio.dart';
import 'dart:io';

Future<void> uploadFileDio(String url, File file) async {
  var formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(file.path),
  });
  Dio dio = Dio();
  var response = await dio.post(url, data: formData);
  if (response.statusCode == 200) {
    // Upload successful
  } else {
    // Handle error
  }
}