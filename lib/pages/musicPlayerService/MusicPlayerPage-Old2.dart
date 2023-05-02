// ignore_for_file: avoid_print

import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../providers/AudioStateProvider.dart';
import '../MediaMetaData.dart';
import '../constants/app_circular_button.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late AudioPlayer _musicAudioPlayer;
  AudioHandler? _audioHandler;

  bool isLoading = false;
  Duration totalDuration = const Duration();

  @override
  void initState() {
    _musicAudioPlayer = AudioPlayer()
      ..setAudioSource(
        AudioSource.uri(
          Uri.parse('asset:///assets/audio/nature.mp3'),
          tag: MediaItem(
            id: '0',
            title: 'Nature Sounds',
            artist: 'Public Domain',
            artUri: Uri.parse(
                'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/introducing%20guided%20audio%20sessions.jpg'),
          ),
        ),
      );

    _initPlayer();
    super.initState();
  }

  late String audioPath =
      'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/introducing%20guided%20audio%20sessions.mp3';

  Future<void> _initPlayer() async {
    try {
      MediaItem mediaItem = MediaItem(
        id: '1',
        album: 'Balancing Track Albam',
        title: 'balancing openness and focus by Henry Shukman',
        artist: 'Dev Art',
        duration: const Duration(milliseconds: 2514820),
        artUri: Uri.parse(
            'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/balancing%20openness%20and%20focus%20by%20Henry%20Shukman.jpg'),
      );

      final player = AudioPlayer();

      var duration = await player.setUrl(
          'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/introducing%20guided%20audio%20sessions.mp3');
      if (duration != null) {
        totalDuration = duration;
      }

      _audioHandler =
          Provider.of<AudioStateProvider>(context, listen: false).audioHandler;

      print('_audioHandler--> $_audioHandler');
      _audioHandler!.setRepeatMode(AudioServiceRepeatMode.none);
      _audioHandler!.addQueueItem(mediaItem);
      // _audioHandler!.playMediaItem(mediaItem);
      // _audioHandler!.playFromSearch(queryString);
      // _audioHandler!.playFromUri(uri);
      // _audioHandler!.playFromMediaId(mediaItem.id);

      _audioHandler!.playbackState.listen((event) {
        print('listen--> $event');
        // isLoading = event.processingState == AudioProcessingState.loading ||
        //     event.processingState == AudioProcessingState.buffering;

        if ((event.playing &&
            event.processingState == AudioProcessingState.ready)) {
          setState(() {});
        }
        if (event.processingState == AudioProcessingState.completed) {
          onStop();
        }
      });

      Future.delayed(const Duration(seconds: 1), () => _audioHandler!.play());
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  onStop() {
    if (_audioHandler != null) {
      _audioHandler!.stop();
      Future.delayed(
        const Duration(seconds: 2),
        () => _audioHandler!.seek(const Duration(seconds: 0)),
      );
    }
  }

  @override
  void dispose() {
    if (_audioHandler != null) _audioHandler!.stop();

    super.dispose();
  }

  Widget playPause(bool playing) {
    return AppCircularButton(
      icon: playing ? Icons.pause : Icons.play_arrow,
      color: Colors.blue,
      handler: () {
        playing ? _audioHandler!.pause() : _audioHandler!.play();
      },
    );
  }

  Widget renderRewind() {
    return AppCircularButton(
      icon: Icons.replay_10,
      color: Colors.blue,
      handler: () => _audioHandler!.rewind(),
    );
  }

  Widget renderForward() {
    return AppCircularButton(
      icon: Icons.forward_10_rounded,
      color: Colors.blue,
      handler: () => _audioHandler!.fastForward(),
    );
  }

  // Stream<MusicPositionData> get _singlePositionDataStream =>
  //     Rx.combineLatest3<Duration, Duration, Duration?, MusicPositionData>(
  //       _musicAudioPlayer.positionStream,
  //       _musicAudioPlayer.bufferedPositionStream,
  //       _musicAudioPlayer.durationStream,
  //       (position, bufferedPosition, duration) => MusicPositionData(
  //         position,
  //         bufferedPosition,
  //         duration ?? Duration.zero,
  //       ),
  //     );

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
          children: [
            StreamBuilder(
              stream: _musicAudioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                return MediaMetaData(
                  imageUrl: metadata.artUri.toString(),
                  title: metadata.title,
                  artist: metadata.artist ?? '',
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            if (_audioHandler != null)
              StreamBuilder<Duration>(
                stream: AudioService.position,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ProgressBar(
                        progress: snapshot.data ?? Duration.zero,
                        total: totalDuration,
                        barHeight: 8,
                        bufferedBarColor: Colors.grey,
                        progressBarColor: Colors.red,
                        thumbColor: Colors.red,
                        baseBarColor: Colors.grey[600],
                        onSeek: (duration) {
                          _audioHandler!.seek(duration);
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            const SizedBox(
              height: 16,
            ),
            if (_audioHandler != null)
              StreamBuilder<bool>(
                stream: _audioHandler!.playbackState
                    .map((state) => state.playing)
                    .distinct(),
                builder: (context, snapshot) {
                  final playing = snapshot.data ?? false;

                  return isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            renderRewind(),
                            const SizedBox(width: 16),
                            playPause(playing),
                            const SizedBox(width: 16),
                            renderForward(),
                          ],
                        );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class MusicPositionState {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  const MusicPositionState(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
}
