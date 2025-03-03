import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pratyasaa/screens/screen_2.dart';
import 'package:pratyasaa/screens/screen_3.dart';
import 'package:pratyasaa/screens/screen_one.dart';
// import 'package:pratyasaa/screens/OcrScreen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FlutterTts flutterTts;
  late int tapCount;
  late Timer _timer;
  late bool _isListening;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    tapCount = 0;
    _isListening = false;
    _initializeTTS();
  }

  void _initializeTTS() async {
    if (await flutterTts.isLanguageAvailable("en-US")) {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      _speakInitialPrompt();
    } else {
      print("Text-to-Speech (TTS) service not available.");
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _speakInitialPrompt() async {
    await _speak(
        "Welcome to Pratyasha. Tap 1 time for OCR, 2 times for Currency detection, and 3 times for environment captioning.");
    await Future.delayed(Duration(seconds: 8));
    await _speak("Now you can Tap.");
    _startListening();
  }

  void _handleNavigationBack() {
    _speak("Back to homepage. Now you can tap.");
    if (isHomePage()) {
      _speak("Back to homepage.");
    }
    _startListening();
  }

  void _startListening() {
    _isListening = true;
    _timer = Timer(Duration(seconds: 3), () {
      _isListening = false;
      if (tapCount == 1) {
        _speak("Opening OCR");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OCRScreen()));
      } else if (tapCount == 2) {
        _speak("Opening Currency detection");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ApiCallScreen()));
      } else if (tapCount == 3) {
        _speak("Opening environment captioning");

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CaptionCallScreen()));
      }
      tapCount = 0;
      _startListening();
    });
  }

  void _handleTap() {
    if (_isListening) {
      tapCount++;
      _startListening();
    }
  }

  bool isHomePage() {
    return ModalRoute.of(context)?.settings.name == '/';
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: GestureDetector(
  //       onTap: _handleTap,
  //       child: Container(
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //             image: AssetImage('assets/new.png'),
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          print("Opening OCR");
          _speak("Opening OCR");

          // Uncomment the following to navigate to OCRScreen
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => OCRScreen()));
        },
        onDoubleTap: () {
          print("Opening Currency detection");
          _speak("Opening Currency detection");

          // Uncomment the following to navigate to ApiCallScreen
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => ApiCallScreen()));
        },
        onLongPress: () {
          print("Opening environment captioning");
          _speak("Opening environment captioning");

          // Uncomment the following to navigate to CaptionCallScreen
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => CaptionCallScreen()));
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/new.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    _timer.cancel();
    flutterTts.stop();
    super.dispose();
  }
}
