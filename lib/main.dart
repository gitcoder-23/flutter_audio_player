import 'package:flutter/material.dart';
import 'package:flutter_audio_player/pages/singleaudio/SingleAudioPlayerPage.dart';

Future<void> main() async {
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );
  runApp(const MyApp());
}

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Audio Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SingleAudioPlayerPage(),
    );
  }
}
