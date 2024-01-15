import 'package:flutter/material.dart';

class MyStoryWidget extends StatefulWidget {
  const MyStoryWidget();

  @override
  State<MyStoryWidget> createState() => _MyStoryWidgetState();
}

class _MyStoryWidgetState extends State<MyStoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.green, Colors.blueAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Stack(
          children: [
            Center(
              child: Text('Tap to type',
                  style: TextStyle(
                      fontFamily: 'Alegreya',
                      package: 'stories_editor',
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: Colors.white.withOpacity(0.5),
                      shadows: <Shadow>[
                        Shadow(
                            offset: const Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Colors.black45
                                .withOpacity(0.3))
                      ])),
            ),
          ],
        )
      ),
    );
  }
}
