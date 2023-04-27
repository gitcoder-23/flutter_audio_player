import 'package:flutter/material.dart';
import 'package:flutter_audio_player/pages/AudioController.dart';
import 'package:flutter_audio_player/pages/MediaMetaData.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({super.key});

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late AudioPlayer _audioPlayer;

  final _playlist = ConcatenatingAudioSource(
    children: [
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
      AudioSource.uri(
        Uri.parse(
            'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/balancing+openness+and+focus+by+Henry+Shukman.mp3'),
        tag: MediaItem(
          id: '1',
          title: 'balancing openness and focus by Henry Shukman',
          artist: 'Dev Art',
          artUri: Uri.parse(
              'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/balancing%20openness%20and%20focus%20by%20Henry%20Shukman.jpg'),
        ),
      ),
      AudioSource.uri(
        Uri.parse(
            'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/introducing%20Henry%20Shukman.mp3'),
        tag: MediaItem(
          id: '2',
          title: 'introducing Henry Shukman',
          artist: 'Dev Art',
          artUri: Uri.parse(
              'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/introducing%20Henry%20Shukman.jpg'),
        ),
      ),
      AudioSource.uri(
        Uri.parse(
            'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/simply+being.mp3'),
        tag: MediaItem(
          id: '3',
          title: 'simply being',
          artist: 'Mina Art',
          artUri: Uri.parse(
              'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/simply%20being.jpg'),
        ),
      ),
      AudioSource.uri(
        Uri.parse(
            "https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/posture+and+wellbeing+by+Henry+Shuckman+.mp3"),
        tag: MediaItem(
          id: '4',
          title: 'posture and wellbeing by Henry Shuckman',
          artist: 'Fine Art',
          artUri: Uri.parse(
              'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/posture%20and%20wellbeing%20by%20Henry%20Shuckman.jpg'),
        ),
      ),
    ],
  );

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    // ..setAsset('assets/audio/the-beat-of-nature-122841.mp3');
    // _audioPlayer = AudioPlayer()
    //   ..setUrl(
    //       'https://production-audio-vedio.s3.ap-southeast-1.amazonaws.com/introducing%20guided%20audio%20sessions.mp3');

    _initArreyAudio();

    // _audioPlayer.positionStream;
    // _audioPlayer.bufferedPositionStream;
    // _audioPlayer.durationStream;
  }

  Future<void> _initArreyAudio() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playlist);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Flutter Audio',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.keyboard_arrow_down,
          ),
        ),
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
                stream: _audioPlayer.sequenceStateStream,
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
                }),
            const SizedBox(height: 20),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                print('positionData--> $positionData');
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
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  onSeek: _audioPlayer.seek,
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            AudioController(audioPlayer: _audioPlayer),
          ],
        ),
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
}
