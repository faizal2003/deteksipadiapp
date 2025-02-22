import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
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
import 'package:padipari/listdetect.dart';




// start home menu
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    print('TabPage1 build');
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true ,
        title: const Text('PadDetect'),
        leading: Image.asset('assets/logo.png'),
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
        actions: <Widget>[
          IconButton(onPressed: (){
            showDialog(context: context, builder: (ctx) => AlertDialog(
              title: const Text("Tata cara identifikasi"),
              content: const Text('*Identifikasi dari galeri untuk mengidentifikasi penyakit tanaman padi melalui galeri pada ponsel '
                  '*Identifikasi dari kamera untuk mengidentifikasi penyakit tanaman padi dari kamera pada ponsel'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    color: Colors.green,
                    padding: const EdgeInsets.all(14),
                    child: const Text("okay", style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ));
          }, icon: Icon(Icons.help_outlined, size: 42, color: Colors.white,))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg-main.png"),
            fit: BoxFit.cover
          ),
        ),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Expanded(child: Container(
              padding: EdgeInsets.fromLTRB(50, 40, 50, 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DigitalClock(
                    datetime: DateTime.now(),
                    textScaleFactor: 2,
                    showSeconds: false,
                    isLive: true,
                    digitalClockTextColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(100, 10, 100, 1),
                    // decoration: const BoxDecoration(color: Colors.cyan, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                  SizedBox(
                    width: 350,
                    height: 100,
                    child: FilledButton.icon(
                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.green)),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const ImagePickGallery()));
                      },
                      label: const Text('Identifikasi Dari Galeri', style: TextStyle(fontSize: 25),),
                      icon: const Icon(Icons.upload_file_rounded, size: 40),
                    ),
                  ),

                  SizedBox(
                    width: 350,
                    height: 100,
                    child: FilledButton.icon(
                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.green)),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const ImagePickCamera()));
                      },
                      label: const Text('Identifikasi Dari Kamera', style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
                      icon: const Icon(Icons.camera_enhance_rounded, size: 40,),
                    ),
                  ),




                ],
              ),
            )),
          ],
        ),
      ),
      )
    );
  }
}
//end home menu


class _ResCard extends StatelessWidget {
  const _ResCard({required this.cardName});
  final String cardName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(child: Text(cardName))
        ],
      ),
    );
  }
}



// start screen ambil gambar dari kamera
class ImagePickCamera extends StatefulWidget {

  const ImagePickCamera({super.key});

  @override

  State<ImagePickCamera> createState() => _ImagePickCameraState();
}

class _ImagePickCameraState extends State<ImagePickCamera> {
  File ? _SelectedImage;
  Uint8List ? _ResponseAPI;
  int ? _pr;
  int _imgstat = 0;
  //link upload ke server
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
          title: const Text('Kirim Gambar Dari Camera'),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 30),
          actions: <Widget>[
            IconButton(onPressed: (){
              showDialog(context: context, builder: (ctx) => AlertDialog(
                title: const Text("Cara Pengambilan gambar"),
                content: const Text('Tekan tombol Pilih gambar, lalu foto penyakit yang akan di deteksi. Pastikan foto fokus, tidak buram, dan tidak terlalu terang. Setelah ambil gambar, harap tekan tombol upload untuk memulai proses deteksi penyakit padi. Hasil deteksi akan tersimpan otomatis di dalam galeri'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      color: Colors.green,
                      padding: const EdgeInsets.all(14),
                      child: const Text("okay", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ));
            }, icon: Icon(Icons.help_rounded, size: 32,))
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg-main.png"),
                  fit: BoxFit.fill
              )
          ),
          child: Container(
              padding: const EdgeInsets.fromLTRB(50, 70, 50, 50),
              child: SizedBox(
                width: 350,
                height: double.infinity,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _pr == 1 ? LinearProgressIndicator(color: Colors.green,) : Text(''),
                      SizedBox(), _ResponseAPI != null ? Image.memory(_ResponseAPI!) : Text(''),
                      // SizedBox(), _ResponseAPI != null ? FilledButton(onPressed: () {_deleteimg();}, child: Text('Hapus Gambar'),) : Text(''),
                      Expanded(child: Container(
                        padding: EdgeInsets.all(1),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(), _SelectedImage != null ? Image.file(_SelectedImage!) : Text(''),
                                _SelectedImage == null && _imgstat == 0 ? SizedBox(
                                  width: 230,
                                  height: 50,
                                  child:
                                  FilledButton.icon(
                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.green)),
                                    onPressed: () {
                                      _getImageFromCamera();
                                    },
                                    label: const Text('pilih gambar', style: TextStyle(fontSize: 20),),
                                    icon: const Icon(Icons.camera_alt_rounded, size: 30),
                                  ),
                                ):Text(''),
                              const SizedBox(), _ResponseAPI != null ? SizedBox(
                                  width: 230,
                                  height: 50,
                                  child: FilledButton.icon(
                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
                                    onPressed: () {
                                      _deleteimg();
                                    },
                                    label: const Text('Hapus Gambar', style: TextStyle(fontSize: 20),),
                                    icon: const Icon(Icons.delete_forever_rounded, size: 30),
                                  ),
                                ) : Text('')
                            ],
                            )),
                            _SelectedImage != null ? FilledButton(onPressed: () {_upGambar(urlAPI, _SelectedImage!);}, child: Text('Upload Gambar'),) : Text(''),
                            _SelectedImage != null ? FilledButton.icon(
                              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
                              onPressed: () {
                                _deleteimg();
                              },
                              label: const Text('Hapus Gambar', style: TextStyle(fontSize: 20),),
                              icon: const Icon(Icons.delete_forever, size: 30),
                            ) : Text(''),

                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              )
          ),
        )
    );
  }
  //fungsi ambil gambar dari kamera
  Future _getImageFromCamera() async{
    final returnImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnImage == null) return;
    setState((){
      _SelectedImage = File(returnImage.path);
    });
  }
  //fungsi upload gambar
  Future<void> _upGambar(String url, File file) async{

    setState(() {
      _pr = 1;
    });

    context.loaderOverlay.show();

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    //fungsi kirim gambar ke galeri dan simpan gambar terdeeksi
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

      setState(() {
        _pr = 0;
        _imgstat = 1;
      });

      print(response.bodyBytes);

      context.loaderOverlay.hide();

    } else {
      // Handle errorset
    }
  }
  //fungsi simpan gambar ke galeri
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
  //perizinan simpan gambar ke galeri
  Future<void> requestPermission() async {
    final permission = Permission.camera;

    if (await permission.isDenied) {
      await permission.request();
    }
  }
  //fungsi hapus gambar dari screen
  Future<void> _deleteimg() async{
    setState(() {
      _SelectedImage = null;
      _ResponseAPI = null;
      _imgstat = 0;
    });
  }
}
//end screen ambil gambar dari kamera

//start screen ambil gambal dari galeri
class ImagePickGallery extends StatefulWidget {

  const ImagePickGallery({super.key});

  @override

  State<ImagePickGallery> createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePickGallery> {
  File ? _SelectedImage;
  Uint8List ? _ResponseAPI;
  String ? _errorst;
  int ? _pr;
  int _imgstat = 0;
  //link upload gambar ke server
  var urlAPI = 'https://detectpadi.my.id/object-to-img';


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          //tombol tata cara ambil gambar
          actions: <Widget>[
            IconButton(onPressed: (){
              showDialog(context: context, builder: (ctx) => AlertDialog(
                title: const Text("Cara Pengambilan gambar"),
                content: const Text('Tekan tombol Pilih gambar, lalu pilih dari galeri handphone, pastikan foto fokus, tidak buram, dan tidak terlalu terang. Setelah pilih gambar, harap tekan tombol upload untuk memulai proses deteksi penyakit padi. Hasil deteksi akan tersimpan otomatis di dalam galeri'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      color: Colors.green,
                      padding: const EdgeInsets.all(14),
                      child: const Text("okay", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ));
            }, icon: Icon(Icons.help_rounded, size: 32,))
          ],
          //end tata cara ambil gambar

          //title screen
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text('Kirim Gambar Dari Galeri'),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
        ),
        //set background
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg-main.png"),
              fit: BoxFit.fill
            )
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(50, 70, 50, 50),
            child: SizedBox(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                //logika tombol upload hapus dan ambil gambar
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _pr == 1 ? LinearProgressIndicator(color: Colors.green,) : Text(''),
                    SizedBox(), _ResponseAPI != null ? Image.memory(_ResponseAPI!) : Text(''),
                    // SizedBox(), _ResponseAPI != null ? FilledButton(onPressed: () {_deleteimg();}, child: Text('Hapus Gambar'),) : Text(''),
                    Expanded(child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.bottomCenter,
                      child: Column(

                        children: [
                          Expanded(child: Column(
                            children: [
                              const SizedBox(), _SelectedImage != null ? Image.file(_SelectedImage!) : Text(''),
                              _SelectedImage == null && _imgstat == 0 ? SizedBox(
                                width: 230,
                                height: 50,
                                child:
                                FilledButton.icon(
                                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.green)),
                                  onPressed: () {
                                    _getImageFromGallery();
                                  },
                                  label: const Text('pilih gambar', style: TextStyle(fontSize: 20),),
                                  icon: const Icon(Icons.camera_alt_rounded, size: 30),
                                ),
                              ):Text(''),
                              _ResponseAPI != null ? SizedBox(
                                width: 230,
                                height: 50,
                                child: FilledButton.icon(
                                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
                                  onPressed: () {
                                    _deleteimg();
                                  },
                                  label: const Text('Hapus Gambar', style: TextStyle(fontSize: 20),),
                                  icon: const Icon(Icons.delete_forever_rounded, size: 30),
                                ),
                              ) : Text('')
                            ],
                          )),
                          _SelectedImage != null ? FilledButton(onPressed: () {_upGambar(urlAPI, _SelectedImage!);}, child: Text('Upload Gambar'),) : Text(''),
                          _SelectedImage != null ? FilledButton.icon(
                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
                            onPressed: () {
                              _deleteimg();
                            },
                            label: const Text('Hapus Gambar', style: TextStyle(fontSize: 20),),
                            icon: const Icon(Icons.delete_forever, size: 30),
                          ) : Text(''),

                        ],
                      ),
                    ))
                  ],
                ),
              ),
            )
          ),
        )
    );
  }
  //fungsi ambil gambar dari galeri
  Future _getImageFromGallery() async{
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnImage == null) return;
    setState((){
      _SelectedImage = File(returnImage.path);
    });
  }
  //end ambil gambar dari galeri

  //fungsi perizinan simpan gambar
  Future<void> requestPermission() async {
    final permission = Permission.storage;


    if (await permission.isDenied) {
      await permission.request();
    }
  }
  //end perizinan simpan gambar

  Future<void> _upGambar(String url, File file) async{
  //fungsi upload gamber ke server
    context.loaderOverlay.show();
    setState(() {
      _pr = 1;
    });
    //kirim gambar ke server
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    // final resBody = await response.stream.bytesToString();
    //end kirim gambar ke server
    if (streamedResponse.statusCode == 200) {
      // Upload successful
      print('success');


      setState(() {
        _ResponseAPI = response.bodyBytes;
        _SelectedImage = null;
        _pr = 0;
        _imgstat = 1;
      });

      //save gambar
      String genName = RndX.randomString(type: RandomCharStringType.alphaNumerical, length: 10);
      // final String savepath = (getApplicationDocumentsDirectory()).path;
      // FileSaver.instance.saveFile(name: genName, ext: 'jpg', file: Image.memory(response.bodyBytes));
      saveImage(response.bodyBytes);
      //end save gambar


      print(response.bodyBytes);

      context.loaderOverlay.hide();

    } else {
      // Handle errorset
      setState(() {
        _errorst = 'error';
      });
    }
  }

  //fungsi hapus gambar dari screen
  Future<void> _deleteimg() async{
    setState(() {
      _SelectedImage = null;
      _ResponseAPI = null;
      _imgstat = 0;
    });
  }
  //end hapus gambar dari screen

  //fungsi simpan gambar ke galeri
  Future<String> saveImage(Uint8List bytes) async {
    String path = "";
    try {

      setState(() {
        _pr = 1;
      });



      Directory? root = await getTemporaryDirectory();
      String directoryPath = '${root.path}/appName';
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
    setState(() {
      _pr = 0;
    });


    print(path);
    return path;
  }

  //end simpan gambar ke galeri

}
//end screen ambil gambar dari galeri
