// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/pages/MediaMetaData.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../providers/AudioStateProvider.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  // late AudioPlayer _musicAudioPlayer;

  AudioHandler? _audioHandler;

  bool isLoading = false;
  Duration totalDuration = const Duration();

  @override
  void initState() {
    // _musicAudioPlayer = AudioPlayer()
    //   ..setAudioSource(
    //     AudioSource.uri(
    //       Uri.parse('asset:///assets/audio/nature.mp3'),
    //       tag: MediaItem(
    //         id: '0',
    //         title: 'Nature Sounds',
    //         artist: 'Public Domain',
    //         artUri: Uri.parse(
    //             'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/introducing%20guided%20audio%20sessions.jpg'),
    //       ),
    //     ),
    //   );

    _initPlayer();
    super.initState();
  }

  Future<void> _initPlayer() async {
    try {
      MediaItem mediaItem = MediaItem(
        id: 'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/introducing%20guided%20audio%20sessions.mp3',
        album: 'Balancing Track Albam',
        title: 'balancing openness and focus by Henry Shukman',
        artist: 'Dev Art',
        duration: const Duration(milliseconds: 2514820),
        artUri: Uri.parse(
            'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/balancing%20openness%20and%20focus%20by%20Henry%20Shukman.jpg'),
      );

      final player = AudioPlayer();
      if (mediaItem != null) {
        var duration = await player.setUrl(mediaItem.id);
        if (duration != null) {
          totalDuration = duration;
        }
      }

      // var duration = player.setUrl(
      //     'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/introducing%20guided%20audio%20sessions.mp3');
      // totalDuration = duration;

      _audioHandler =
          Provider.of<AudioStateProvider>(context, listen: false).audioHandler;

      print('_audioHandler--> $_audioHandler');
      _audioHandler!.setRepeatMode(AudioServiceRepeatMode.none);
      if (mediaItem != null) {
        _audioHandler!.addQueueItem(mediaItem);
      } else {}
      // _audioHandler!.playMediaItem(mediaItem);
      // _audioHandler!.playFromSearch(queryString);
      // _audioHandler!.playFromUri(uri);
      // _audioHandler!.playFromMediaId(mediaItem.id);

      _audioHandler!.playbackState.listen((event) {
        print('listen--> $event');
        isLoading = event.processingState == AudioProcessingState.loading ||
            event.processingState == AudioProcessingState.buffering;

        if ((event.playing &&
            event.processingState == AudioProcessingState.ready)) {
          setState(() {});
        }
        if (event.processingState == AudioProcessingState.completed) {
          onStop();
        }
      });

      Future.delayed(const Duration(seconds: 1), () => _audioHandler!.play());
    } catch (err) {
      print(err);
    }
  }

  /// current position.
  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          _audioHandler!.mediaItem,
          AudioService.position,
          (mediaItem, position) => MediaState(mediaItem!, position));

  IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
        icon: Icon(iconData),
        iconSize: 64.0,
        onPressed: onPressed,
      );

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
    _audioHandler!.stop();

    super.dispose();
  }

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
            if (_audioHandler != null)
              StreamBuilder<MediaItem?>(
                stream: _audioHandler!.mediaItem,
                builder: (context, snapshot) {
                  final mediaItem = snapshot.data;
                  print('mediaItem--> $mediaItem');
                  if (mediaItem == null) {
                    return const SizedBox();
                  }
                  // return Text(mediaItem.title ?? '');
                  final metadata = mediaItem;
                  return MediaMetaData(
                    imageUrl: metadata.artUri.toString(),
                    title: metadata.title,
                    artist: metadata.artist ?? '',
                  );
                },
              ),
            const SizedBox(height: 20),
            if (_audioHandler != null && _mediaStateStream != null)
              StreamBuilder<MediaState>(
                stream: _mediaStateStream,
                builder: (context, snapshot) {
                  final mediaState = snapshot.data;

                  if (snapshot.hasData) {
                    return ProgressBar(
                      barHeight: 8,
                      baseBarColor: Colors.grey[600],
                      bufferedBarColor: Colors.grey,
                      progressBarColor: Colors.red,
                      thumbColor: Colors.red,
                      timeLabelTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      progress: mediaState?.position ?? Duration.zero,
                      // buffered: mediaState?.mediaItem?.duration ?? Duration.zero,
                      total: totalDuration ?? Duration.zero,
                      onSeek: (newPosition) {
                        _audioHandler!.seek(newPosition);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            const SizedBox(height: 20),
            StreamBuilder<bool>(
              stream: _audioHandler!.playbackState
                  .map((state) => state.playing)
                  .distinct(),
              builder: (context, snapshot) {
                final playing = snapshot.data ?? false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button(Icons.fast_rewind, _audioHandler!.rewind),
                    if (playing)
                      _button(Icons.pause, _audioHandler!.pause)
                    else
                      _button(Icons.play_arrow, _audioHandler!.play),
                    _button(Icons.stop, _audioHandler!.stop),
                    _button(Icons.fast_forward, _audioHandler!.fastForward),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

// class MediaState {
//   final Duration position;
//   final Duration bufferedPosition;
//   final Duration duration;

//   const MediaState(
//     this.position,
//     this.bufferedPosition,
//     this.duration,
//   );
// }
