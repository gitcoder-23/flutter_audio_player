import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';

class AudioStateProvider with ChangeNotifier {
  AudioHandler audioHandler;

  AudioStateProvider({
    required this.audioHandler,
  });
}
