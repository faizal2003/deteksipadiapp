import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
// import 'dart:ui';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:padipari/persistent_bottom_bar_scaffold.dart';
import 'package:one_clock/one_clock.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:random_x/random_x.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';
import 'package:padipari/home_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Homemenu extends StatelessWidget {
  const Homemenu({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('TabPage1 build');
    }
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: (_) {
        return const Center(
          child: SpinKitCircle(
            color: Colors.lightGreenAccent,
            size: 50,
          ),
        );
      },
      child:
      Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,

          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/bg-utama.png"),
                    fit: BoxFit.fill
                )
            ),
            child: Container(
                padding: const EdgeInsets.fromLTRB(50, 10, 50, 50),
                child: SizedBox(
                  width: 350,
                  height: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(100),
                            ),
                            const Text("Aplikasi deteksi penyakit Padi, Cabai, dan Tomat", style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
                          ],
                        ),
                        Image.asset("assets/icon.png", scale: 2,),
                        SizedBox(
                          width: 250,
                          height: 70,
                          child: FilledButton.icon(
                              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.greenAccent[700]),),
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => const HomePage()));
                              },
                              label: const Text('Masuk', style: TextStyle(fontSize: 25),)
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ),
          )
      ),
    );
  }
}