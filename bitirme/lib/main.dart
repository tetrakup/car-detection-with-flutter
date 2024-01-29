import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Camera App'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // Tara ve fotoğraf çek işlevi
              xrayScan(context, controller);
            },
            child: const Text('Sayfada Tara ve Fotoğraf Çek'),
          ),
        ),
      ),
    );
  }
}

Future<void> xrayScan(BuildContext context, CameraController controller) async {
  try {
    await controller.startImageStream((image) {
      // İşlenecek fotoğrafı buraya alabilirsiniz
      // Örneğin, 'image' değişkenini kullanarak fotoğrafı işleyebilirsiniz.
    });
  } on CameraException catch (e) {
    // Hata durumunda yapılacak işlemler
    print('Error: $e');
  }

  // Fotoğraf çekme işlevi
  takePicture(context, controller);
}

void takePicture(BuildContext context, CameraController controller) async {
  try {
    final XFile file = await controller.takePicture();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Fotoğraf Çekildi'),
          ),
          body: Center(
            child: Image.file(File(file.path)),
          ),
        ),
      ),
    );
  } on CameraException catch (e) {
    // Hata durumunda yapılacak işlemler
    print('Error: $e');
  }
}
