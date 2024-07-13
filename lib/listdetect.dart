import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:padipari/persistent_bottom_bar_scaffold.dart';
import 'package:one_clock/one_clock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:random_x/random_x.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';

class Listdetect extends StatefulWidget {

  const Listdetect({super.key});

  @override

  State<Listdetect> createState() => _ListDetectState();
}

class _ListDetectState extends State<Listdetect> {
  File ? _SelectedImage;
  Uint8List ? _ResponseAPI;
  var urlAPI = 'https://detectpadi.my.id/object-to-img';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text('History Deteksi'),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 30),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg-main.png"),
                  fit: BoxFit.fill
              )
          ),
          child: Container(
              padding: const EdgeInsets.fromLTRB(50, 100, 50, 50),
              child: SizedBox(
                width: 350,
                height: double.infinity,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                  ),

                ),
              )
          ),
        )
    );
  }
  Future _getImageFromCamera() async{
    final returnImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnImage == null) return;
    setState((){
      _SelectedImage = File(returnImage.path);
    });
  }
  Future<void> _upGambar(String url, File file) async{

    context.loaderOverlay.show();

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    // final resBody = await response.stream.bytesToString();
    if (streamedResponse.statusCode == 200) {
      // Upload successful
      print('success');

      setState(() {
        _ResponseAPI = response.bodyBytes;
        _SelectedImage = null;
      });

      String genName = RndX.randomString(type: RandomCharStringType.alphaNumerical, length: 10);
      // final String savepath = (getApplicationDocumentsDirectory()).path;
      // FileSaver.instance.saveFile(name: genName, ext: 'jpg', file: Image.memory(response.bodyBytes));
      saveImage(response.bodyBytes);



      print(response.bodyBytes);

      context.loaderOverlay.hide();

    } else {
      // Handle errorset
    }
  }

  Future<String> saveImage(Uint8List bytes) async {
    String path = "";
    try {
      Directory? root = await getDownloadsDirectory();
      String directoryPath = '${root?.path}/appName';
      // Create the directory if it doesn't exist
      String genName = RndX.randomString(type: RandomCharStringType.alphaNumerical, length: 10);
      await Directory(directoryPath).create(recursive: true);
      String filePath = '$directoryPath/$genName.jpg';
      final file = await File(filePath).writeAsBytes(bytes);
      path = file.path;
      await Gal.putImage(path);
    } catch (e) {
      debugPrint(e.toString());
    }
    print(path);
    return path;
  }

  Future<void> requestPermission() async {
    final permission = Permission.camera;

    if (await permission.isDenied) {
      await permission.request();
    }
  }
}
