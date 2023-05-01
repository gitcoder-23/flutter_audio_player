import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'pages/singleaudio/SingleAudioPlayerPage.dart';

late AudioHandler _audioHandler;
Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
    fastForwardInterval: const Duration(seconds: 10),
    rewindInterval: const Duration(seconds: 10),
  );

  // _audioHandler = await initAudioService();
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
      // home: MusicPlayerServicePage(audioHandler: _audioHandler),
      home: const SingleAudioPlayerPage(),
      // home: const AudioPlayerPage(),
    );
  }
}
