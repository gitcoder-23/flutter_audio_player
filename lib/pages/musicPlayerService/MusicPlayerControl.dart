import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => AudioPlayerTask(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      fastForwardInterval: Duration(seconds: 10),
      rewindInterval: Duration(seconds: 10),
    ),
  );
}

MediaControl playControl = const MediaControl(
  androidIcon: 'drawable/play_arrow',
  label: 'Play',
  action: MediaAction.play,
);

MediaControl pauseControl = const MediaControl(
  androidIcon: 'drawable/pause',
  label: 'Pause',
  action: MediaAction.pause,
);

MediaControl skipToNextControl = const MediaControl(
  androidIcon: 'drawable/skip_to_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);

MediaControl skipToPreviousControl = const MediaControl(
  androidIcon: 'drawable/skip_to_prev',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);

MediaControl stopControl = const MediaControl(
  androidIcon: 'drawable/stop',
  label: 'Stop',
  action: MediaAction.stop,
);

class AudioPlayerTask extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();

  AudioPlayerHandler() {
    _player.setLoopMode(LoopMode.all);
  }

  final _queueAudio = <MediaItem>[
    MediaItem(
      id: '0',
      album: 'Nature Track Albam',
      title: 'Nature Sounds',
      artist: 'Public Domain',
      duration: const Duration(milliseconds: 5739820),
      artUri: Uri.parse(
          'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/introducing%20guided%20audio%20sessions.jpg'),
    ),
    MediaItem(
      id: '1',
      album: 'Balancing Track Albam',
      title: 'balancing openness and focus by Henry Shukman',
      artist: 'Dev Art',
      duration: const Duration(milliseconds: 2514820),
      artUri: Uri.parse(
          'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/balancing%20openness%20and%20focus%20by%20Henry%20Shukman.jpg'),
    ),
    MediaItem(
      id: '2',
      album: 'Introducing Track Albam',
      title: 'introducing Henry Shukman',
      artist: 'Introducing Art',
      duration: const Duration(milliseconds: 3214820),
      artUri: Uri.parse(
          'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/introducing%20Henry%20Shukman.jpg'),
    ),
    MediaItem(
      id: '3',
      album: 'Simply Track Albam',
      title: 'simply being',
      artist: 'Mina Art',
      duration: const Duration(milliseconds: 1214820),
      artUri: Uri.parse(
          'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/simply%20being.jpg'),
    ),
    MediaItem(
      id: '4',
      album: 'Posture Track Albam',
      title: 'posture and wellbeing by Henry Shuckman',
      artist: 'Fine Art',
      duration: const Duration(milliseconds: 3214820),
      artUri: Uri.parse(
          'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/posture%20and%20wellbeing%20by%20Henry%20Shuckman.jpg'),
    ),
  ];

  final int _queueIndex = -1;
  final AudioPlayer _musicAudioPlayer = AudioPlayer();

  late AudioProcessingState _musicAudioProcessingState;

  late bool _playing;

  bool get hasNext => _queueIndex + 1 < _queueAudio.length;
  bool get hasPrevious => _queueIndex > 0;

  // @override
  // MediaItem get mediaItem => _queueAudio[_queueIndex];
  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    // manage Just Audio
    _queueAudio[_queueIndex];
  }

  @override
  void onStart(Map<String, dynamic> params) {
    // super.onStart(params);
  }

  @override
  void onPlay() {
    // super.onPlay();
  }

  @override
  void onPause() {
    // super.onPause();
  }

  @override
  void onSkipToNext() {
    // super.onSkipToNext();
  }

  @override
  void onSkipToPrevious() {
    // super.onSkipToPrevious();
  }

  @override
  void onSeekTo(Duration position) {
    // super.onSeekTo(position);
  }

  @override
  void onClick(MediaButton button) {
    // super.onClick(button);
  }

  @override
  void onFastForward() {
    // super.onFastForward();
  }

  @override
  void onRewind() {
    // super.onRewind();
  }

  // @override
  // Future<void> onPlay() => _musicAudioPlayer.play();

  // @override
  // Future<void> onPause() => _musicAudioPlayer.pause();

  // @override
  // Future<void> onSeek(Duration position) => _musicAudioPlayer.seek(position);

  // @override
  // Future<void> onStop() => _musicAudioPlayer.stop();

  // @override
  // Future<void> onSkipToNext() => _musicAudioPlayer.seekToNext();

  // @override
  // Future<void> onSkipToPrevious() => _musicAudioPlayer.seekToPrevious();

  // @override
  // void onClick(MediaButton button) {}

  // @override
  // void onClick(MediaButton button) {
  //   super.onClick(button);
  // }

  //  @override
  // Future<void> onFastForward() => _musicAudioPlayer.();
}

// class MusicPlayerControl extends StatelessWidget {
//   const MusicPlayerControl({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
