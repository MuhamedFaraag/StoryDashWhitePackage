import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stories_editor/stories_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter stories editor Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoriesEditor(
                                giphyKey: '3OH5bGWoV0Ds16mooM5Qjbny5PzZcglK',
                                galleryThumbnailQuality: 300,
                                isCustomFontList: false,
                                isDrag: false,
                                onDone: (uri) {
                                  debugPrint(uri);
                                  Share.shareFiles([uri]);
                                },
                              )));
                },
                child: const Text('Open Stories Editor'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoriesEditor(
                                giphyKey: '3OH5bGWoV0Ds16mooM5Qjbny5PzZcglK',
                                galleryThumbnailQuality: 300,
                                isDrag: true,
                                onDone: (uri) {
                                  debugPrint(uri);
                                  Share.shareFiles([uri]);
                                },
                              )));
                },
                child: const Text('WhiteBoard'),
              ),
            ),
          ],
        ));
  }
}
