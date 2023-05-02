import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => AudioPlayerHandler(),
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

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  // static final _item = MediaItem(
  //   id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
  //   album: "Science Friday",
  //   title: "A Salute To Head-Scratching Science",
  //   artist: "Science Friday and WNYC Studios",
  //   duration: const Duration(milliseconds: 5739820),
  //   artUri: Uri.parse(
  //       'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
  // );

  final _player = AudioPlayer();

  /// Initialise our audio handler.
  // AudioPlayerHandler() {
  //   _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

  //   _player.setLoopMode(LoopMode.all);
  // }

  AudioPlayerHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    // mediaItem.add(_item);

    // _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> addQueueItem(MediaItem mediaItemData) async {
    // manage Just Audio
    mediaItem.add(mediaItemData);
    final audioSource = _createAudioSource(mediaItemData);
    _player.setAudioSource(audioSource);
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.id),
      tag: mediaItem,
    );
  }

  @override
  Future<void> fastForward() {
    int newPos = _player.position.inMilliseconds +
        AudioService.config.fastForwardInterval.inMilliseconds;
    _player.seek(Duration(milliseconds: newPos));
    return Future.value();
  }

  @override
  Future<void> rewind() {
    int newPos = _player.position.inMilliseconds -
        AudioService.config.rewindInterval.inMilliseconds;
    _player.seek(Duration(milliseconds: newPos));
    return Future.value();
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        // MediaControl.skipToPrevious,
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
        // MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
