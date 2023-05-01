import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class MusicPlayerServicePage extends StatefulWidget {
  final AudioHandler? audioHandler;
  const MusicPlayerServicePage({this.audioHandler, super.key});

  @override
  State<MusicPlayerServicePage> createState() => _MusicPlayerServicePageState();
}

class _MusicPlayerServicePageState extends State<MusicPlayerServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF144771), Color(0xFF071a2c)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
