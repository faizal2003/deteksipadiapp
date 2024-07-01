import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:padipari/persistent_bottom_bar_scaffold.dart';
import 'package:one_clock/one_clock.dart';

class HomePage extends StatelessWidget {
  final _tab1navigatorKey = GlobalKey<NavigatorState>();
  final _tab2navigatorKey = GlobalKey<NavigatorState>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      items: [
        PersistentTabItem(
          tab: TabPage1(),
          icon: Icons.home,
          title: 'Home',
          navigatorkey: _tab1navigatorKey,
        ),
        PersistentTabItem(
          tab: TabPage2(),
          icon: Icons.info_outline_rounded,
          title: 'Info',
          navigatorkey: _tab2navigatorKey,
        ),

      ],
    );
  }
}

class TabPage1 extends StatelessWidget {
  const TabPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('TabPage1 build');
    return Scaffold(
      appBar: AppBar(centerTitle: true ,title: Text('Deteksi Padi'), leading: Image.asset('assets/padi_icon.png')),
      body: SizedBox(
        width: double.infinity,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    DigitalClock(
                      datetime: DateTime.now(),
                      textScaleFactor: 1,
                      showSeconds: false,
                      isLive: true,
                      // decoration: const BoxDecoration(color: Colors.cyan, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(15))),
                    ),

                  ],
                )),

              ],
            )),
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ImagePickGallery()));
                  },
                  label: const Text('Ambil Gambar'),
                  icon: const Icon(Icons.upload_file_rounded),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ImagePickCamera()));
                  },
                  label: const Text('Kirim Gambar'),
                  icon: const Icon(Icons.camera_alt_rounded),
                ),
              ],
            )),
            Card(child: _ResCard(cardName: 'Hasil Gambar')),
          ],
        ),
      ),
    );
  }
}



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


class TabPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('TabPage2 build');
    return Scaffold(
      appBar: AppBar(title: Text('Tab 2')),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tab 2'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Page2('tab2')));
                },
                child: Text('Go to page2'))
          ],
        ),
      ),
    );
  }
}

class ImagePickCamera extends StatefulWidget {

  const ImagePickCamera({super.key});

  @override

  State<ImagePickCamera> createState() => _ImagePickCameraState();
}

class _ImagePickCameraState extends State<ImagePickCamera> {
  File ? _SelectedImage;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Kirim Gambar Dari Kamera'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 350,
              height: double.infinity,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tata cara Pengambilan gambar :', textAlign: TextAlign.left, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Text('1. Pastikan foto tidak terlalu terang / gelap', textAlign: TextAlign.left, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), ),
                    Text('2. Pastikan foto tegak lurus', textAlign: TextAlign.left, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Text('3. Pastikan cukup dekat dengan jarak 10 - 20 cm', textAlign: TextAlign.left, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Text('4. Pastikan foto fokus / tidak blur', textAlign: TextAlign.left, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Expanded(child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: () {_getImageFromCamera();}, child: Text('ambil Gambar')),
                          Expanded(child: Column(children: [const SizedBox(), _SelectedImage != null ? Image.file(_SelectedImage!) : const Text("Tambahkan gambar")],))
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            )
          ],
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
}

class ImagePickGallery extends StatefulWidget {

  const ImagePickGallery({super.key});

  @override

  State<ImagePickGallery> createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePickGallery> {
  File ? _SelectedImage;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Kirim Gambar Dari Galeri'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 350,
              height: double.infinity,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tata cara Pengambilan gambar :', textAlign: TextAlign.left, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Text('1. Pastikan foto tidak terlalu terang / gelap', textAlign: TextAlign.left, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), ),
                    Text('2. Pastikan foto tegak lurus', textAlign: TextAlign.left, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Text('3. Pastikan cukup dekat dengan jarak 10 - 20 cm', textAlign: TextAlign.left, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Text('4. Pastikan foto fokus / tidak blur', textAlign: TextAlign.left, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Expanded(child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: () {_getImageFromCamera();}, child: Text('ambil Gambar')),
                          Expanded(child: Column(children: [const SizedBox(), _SelectedImage != null ? Image.file(_SelectedImage!) : const Text("Tambahkan gambar")],))
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
  Future _getImageFromCamera() async{
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnImage == null) return;
    setState((){
      _SelectedImage = File(returnImage.path);
    });
  }
}



class TabPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('TabPage3 build');
    return Scaffold(
      appBar: AppBar(title: Text('Tab 3')),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tab 3'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Page2('tab3')));
                },
                child: Text('Go to page2'))
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  final String inTab;

  const Page1(this.inTab);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page 1')),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('in $inTab Page 1'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Page2(inTab)));
                },
                child: Text('Go to page2'))
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  final String inTab;

  const Page2(this.inTab);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page 2')),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('in $inTab Page 2'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Page3(inTab)));
                },
                child: Text('Go to page3'))
          ],
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  final String inTab;

  const Page3(this.inTab);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page 3')),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('in $inTab Page 3'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Go back'))
          ],
        ),
      ),
    );
  }
}