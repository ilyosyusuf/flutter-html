import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

const htmData = """
  <h1>HTML code Title</h1>
  <p>html code text</p>
""";

class _HomePageState extends State<HomePage> {
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? image1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Html(data: htmData),
            ),
            image1 != null
                ? Image.memory(image1 as Uint8List)
                : Container(
                    width: double.infinity,
                    height: 100,
                    color: Colors.yellow,
                  ),
            ElevatedButton(
              child: Icon(Icons.share),
              onPressed: () async {
                // final temp = await getTemporaryDirectory();
                // final path = '${temp.path}/$image';
                // await Share.shareFiles([path],text: "shared");
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          // await screenshotController
          //     .capture(delay: Duration(milliseconds: 10))
          //     .then((capturedImage) async {
          //   image1 = capturedImage;
          //   setState(() {});
          //   print("screenshot oldi");
          // }).catchError((onError) {
          //   print(onError);
          // });

          await screenshotController
              .capture(delay: const Duration(seconds: 2))
              .then((capturedImage) async {
            if (capturedImage != null) {
              final directory = await getApplicationDocumentsDirectory();
              print(directory.path);
              final imagePath =
                  await File('${directory.path}/rasm.jpg').create();
              print(imagePath.path);
              await imagePath.writeAsBytes(capturedImage);
              setState(() {});
              print(capturedImage.toString());
              print(imagePath.path);

              /// Share Plugin
              await Share.shareFiles([imagePath.path]);
            }
          });
        },
      ),
    );
  }
}