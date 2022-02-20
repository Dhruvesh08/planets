import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:planets/app/bloc/audio_control_bloc.dart';
import 'package:planets/helpers/audio_player.dart';
import 'package:planets/resource/app_assets.dart';
import 'package:planets/utils/app_logger.dart';

part 'audio_player_state.dart';

const _maxThemeVolume = 0.15;
const _clickVolume = 0.80;
const _countDownVolume = 0.50;
const _tapVolume = 0.40;

const _maxTiles = 25;

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final AudioControlBloc _audioBloc;

  // audioplayers
  // theme music player
  final AudioPlayer _themeMusicPlayer = getAudioPlayer();

  // button click player
  final AudioPlayer _buttonClickPlayer = getAudioPlayer();

  // count down begin
  final AudioPlayer _countDownBeginPlayer = getAudioPlayer();

  // tile tap player
  final Map<int, AudioPlayer> _tileTapSuccess = {};
  final Map<int, AudioPlayer> _tileTapError = {};
  // final AudioPlayer _tileTapPlayerSuccess = getAudioPlayer();
  // final AudioPlayer _tileTapPlayerError = getAudioPlayer();

  Timer? _timer;

  AudioPlayerCubit(this._audioBloc) : super(const AudioPlayerLoading()) {
    _init();
  }

  void _init() {
    // do audio initializations after showing loading screen
    // to avoid freeze screen
    _timer = Timer(const Duration(milliseconds: 500), () async {
      // theme music setup
      await _themeMusicPlayer.setAsset(AppAssets.planetThemeMusic);
      await _themeMusicPlayer.setLoopMode(LoopMode.one);
      await _themeMusicPlayer.setVolume(_maxThemeVolume);

      // button click
      await _buttonClickPlayer.setAsset(AppAssets.buttonClick);
      await _buttonClickPlayer.setVolume(_clickVolume);

      // count down begin
      await _countDownBeginPlayer.setAsset(AppAssets.countDownBegin);
      await _countDownBeginPlayer.setVolume(_countDownVolume);

      // tile tap
      for (int i = 0; i < _maxTiles; i++) {
        // tile tap success
        final tileTapSuccess = getAudioPlayer();
        await tileTapSuccess.setAsset(AppAssets.tileTapSuccess);
        await tileTapSuccess.setVolume(_tapVolume);
        _tileTapSuccess[i] = tileTapSuccess;

        // tile tap error
        final tileTapError = getAudioPlayer();
        await tileTapError.setAsset(AppAssets.tileTapError);
        await tileTapError.setVolume(_tapVolume);
        _tileTapError[i] = tileTapError;
      }

      emit(const AudioPlayerReady());
    });

    _audioBloc.stream.listen(_onAudioControlStateChanged);
  }

  bool _themeMusicInitialized = false;

  void _onAudioControlStateChanged(AudioControlState audioControlState) {
    if (audioControlState.isMusicEnabled) {
      if (_themeMusicInitialized == false) {
        unawaited(_themeMusicPlayer.play());
        _themeMusicInitialized = true;
      } else {
        _themeMusicPlayer.setVolume(_maxThemeVolume);
      }
    } else {
      _themeMusicPlayer.setVolume(0.0);
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _themeMusicPlayer.dispose();
    _buttonClickPlayer.dispose();
    _tileTapSuccess.forEach((_, audioPlayer) => audioPlayer.dispose());
    _tileTapError.forEach((_, audioPlayer) => audioPlayer.dispose());
    return super.close();
  }

  bool get _isSoundEffectEnabled => _audioBloc.state.isSoundEffectEnabled;

  // public methods

  void tileTappedAudio(int tileValue, {isError = false}) {
    AppLogger.log('AudioPlayerCubit :: tileTappedAudio');
    if (!_isSoundEffectEnabled) return;
    if (isError) {
      unawaited(_tileTapError[tileValue]!.replay());
    } else {
      unawaited(_tileTapSuccess[tileValue]!.replay());
    }
  }

  void buttonClickAudio() {
    if (_isSoundEffectEnabled) unawaited(_buttonClickPlayer.replay());
  }

  void beginCountDown() {
    if (_isSoundEffectEnabled) unawaited(_countDownBeginPlayer.replay());
  }
}
