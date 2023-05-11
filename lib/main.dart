import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/pages/musicPlayerService/AudioPlayerHandler.dart';
import 'package:flutter_audio_player/providers/AudioStateProvider.dart';
import 'package:provider/provider.dart';

import 'pages/singleaudio/SingleAudioPlayerPage.dart';

late AudioHandler _audioHandler;
Future<void> main() async {
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  //   androidStopForegroundOnPause: true,
  //   fastForwardInterval: const Duration(seconds: 10),
  //   rewindInterval: const Duration(seconds: 10),
  // );

  _audioHandler = await initAudioService();
  runApp(const MyApp());
}

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AudioStateProvider>(
          create: (_) => AudioStateProvider(audioHandler: _audioHandler),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Audio Player',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const MusicPlayerPage(),
        home: const SingleAudioPlayerPage(),
        // home: const AudioPlayerPage(),
      ),
    );
  }
}
