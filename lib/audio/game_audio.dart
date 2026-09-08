import 'dart:io' show Platform;
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameAudio {
  static const String boxRelease = 'box_release.wav';
  static const String boxLand = 'box_land.wav';
  static const String gameOver = 'game_over.wav';
  static const String highScore = 'high_score.wav';
  static const String cheerfulBgm = 'cheerful_bgm.wav';

  /// Global sound toggle state. When false, all SFX and BGM are muted.
  static bool soundEnabled = true;

  /// Verification & testing hooks: records SFX play events.
  static String? lastPlayedSound;
  static int playCount = 0;
  static final List<String> playHistory = [];

  static bool get _isTest => !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

  static bool _isInitialized = false;

  // Pre-warmed native low-latency audio player pools
  static _SfxPlayerPool? _releasePool;
  static _SfxPlayerPool? _landPool;
  static _SfxPlayerPool? _gameOverPool;
  static _SfxPlayerPool? _highScorePool;

  /// Resets test observation metrics.
  static void resetMetrics() {
    lastPlayedSound = null;
    playCount = 0;
    playHistory.clear();
  }

  /// Initializes the audio cache and pre-warms all game SFX assets on native players.
  static Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      // Sync initial sound state with SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      soundEnabled = prefs.getBool('sound_enabled') ?? true;

      // Update prefix for assets/sounds/ directory
      FlameAudio.updatePrefix('assets/sounds/');

      if (!_isTest) {
        // 1. Preload audio bytes into cache
        await FlameAudio.audioCache.loadAll([
          boxRelease,
          boxLand,
          gameOver,
          highScore,
          cheerfulBgm,
        ]);

        // 2. Pre-create and pre-source dedicated native players for zero-latency playback
        _releasePool = await _SfxPlayerPool.create(file: boxRelease, poolSize: 2);
        _landPool = await _SfxPlayerPool.create(file: boxLand, poolSize: 2);
        _gameOverPool = await _SfxPlayerPool.create(file: gameOver, poolSize: 1);
        _highScorePool = await _SfxPlayerPool.create(file: highScore, poolSize: 1);

        // 3. Initialize background music manager and pre-warm native BGM source
        try {
          await FlameAudio.bgm.initialize();
          await FlameAudio.bgm.audioPlayer.setReleaseMode(ReleaseMode.loop);
          await FlameAudio.bgm.audioPlayer.setSource(AssetSource(cheerfulBgm));
        } catch (e) {
          debugPrint('GameAudio bgm initialize notice: $e');
        }
      }
      _isInitialized = true;
    } catch (e) {
      debugPrint('GameAudio initialize notice: $e');
    }
  }

  // Centralized volume levels (SFX scaled ~1.4x from base levels for clear balance over BGM)
  static const double boxReleaseVolume = 0.63; // was 0.45 (0.45 * 1.4 = 0.63)
  static const double boxLandVolume = 0.70;    // was 0.50 (0.50 * 1.4 = 0.70)
  static const double gameOverVolume = 0.77;   // was 0.55 (0.55 * 1.4 = 0.77)
  static const double highScoreVolume = 0.77;  // was 0.55 (0.55 * 1.4 = 0.77)
  static const double bgmVolume = 0.25;        // continuous background music volume

  /// Plays short "tik" release sound when box is dropped from pendulum.
  static void playBoxRelease() {
    _playEvent(boxRelease);
    if (!soundEnabled || _isTest) return;
    if (_releasePool != null) {
      _releasePool!.play(volume: boxReleaseVolume);
    } else {
      _fallbackPlay(boxRelease, volume: boxReleaseVolume);
    }
  }

  /// Plays short "tuk" landing sound when box lands successfully on stack.
  static void playBoxLand() {
    _playEvent(boxLand);
    if (!soundEnabled || _isTest) return;
    if (_landPool != null) {
      _landPool!.play(volume: boxLandVolume);
    } else {
      _fallbackPlay(boxLand, volume: boxLandVolume);
    }
  }

  /// Plays sad game-over sound when tower collapses and game ends.
  static void playGameOver() {
    _playEvent(gameOver);
    if (!soundEnabled || _isTest) return;
    if (_gameOverPool != null) {
      _gameOverPool!.play(volume: gameOverVolume);
    } else {
      _fallbackPlay(gameOver, volume: gameOverVolume);
    }
  }

  /// Plays four-note ascending fanfare when player achieves a new high score.
  static void playHighScore() {
    _playEvent(highScore);
    if (!soundEnabled || _isTest) return;
    if (_highScorePool != null) {
      _highScorePool!.play(volume: highScoreVolume);
    } else {
      _fallbackPlay(highScore, volume: highScoreVolume);
    }
  }

  static void _playEvent(String file) {
    if (!soundEnabled) return;
    lastPlayedSound = file;
    playCount++;
    playHistory.add(file);
  }

  static void _fallbackPlay(String file, {double volume = 1.0}) {
    try {
      FlameAudio.play(file, volume: volume);
    } catch (e) {
      debugPrint('GameAudio fallback play notice ($file): $e');
    }
  }

  // --- Background Music ---

  static bool _bgmPlaying = false;
  static bool get isBgmPlaying => _bgmPlaying;

  /// Plays the game's cheerful background music track in a continuous loop.
  static void playCheerfulBgm({double volume = bgmVolume, bool forceRestart = false}) {
    playBgm(cheerfulBgm, volume: volume, forceRestart: forceRestart);
  }

  /// Starts looping background music track.
  static void playBgm(
    String trackName, {
    double volume = bgmVolume,
    bool forceRestart = false,
  }) {
    if (!soundEnabled) return;
    if (_bgmPlaying && !forceRestart) return;
    _bgmPlaying = true;
    if (_isTest) return;
    _startBgm(trackName, volume: volume);
  }

  static Future<void> _startBgm(String trackName, {double volume = bgmVolume}) async {
    try {
      await FlameAudio.bgm.stop();
      await FlameAudio.bgm.audioPlayer.setReleaseMode(ReleaseMode.loop);
      await FlameAudio.bgm.audioPlayer.setVolume(volume);
      await FlameAudio.bgm.audioPlayer.setSource(AssetSource(trackName));
      await FlameAudio.bgm.audioPlayer.seek(Duration.zero);
      await FlameAudio.bgm.resume();
    } catch (e) {
      debugPrint('GameAudio _startBgm notice: $e');
      try {
        await FlameAudio.bgm.play(trackName, volume: volume);
      } catch (e2) {
        debugPrint('GameAudio fallback play notice: $e2');
      }
    }
  }

  /// Stops current background music.
  static void stopBgm() {
    _bgmPlaying = false;
    if (_isTest) return;
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      debugPrint('GameAudio stopBgm notice: $e');
    }
  }

  /// Disposes all pre-loaded players and clears resources.
  static Future<void> dispose() async {
    stopBgm();
    if (!_isTest) {
      try {
        await FlameAudio.bgm.dispose();
      } catch (e) {
        debugPrint('GameAudio bgm dispose notice: $e');
      }
    }
    await _releasePool?.dispose();
    await _landPool?.dispose();
    await _gameOverPool?.dispose();
    await _highScorePool?.dispose();
    _releasePool = null;
    _landPool = null;
    _gameOverPool = null;
    _highScorePool = null;
    _isInitialized = false;
  }
}

/// Pre-allocated, pre-sourced AudioPlayer pool that eliminates native allocation and decode latency.
class _SfxPlayerPool {
  final List<AudioPlayer> _players;
  int _nextIndex = 0;

  _SfxPlayerPool(this._players);

  static Future<_SfxPlayerPool> create({
    required String file,
    required int poolSize,
  }) async {
    final players = <AudioPlayer>[];
    for (int i = 0; i < poolSize; i++) {
      final player = AudioPlayer()..audioCache = FlameAudio.audioCache;
      await player.setPlayerMode(PlayerMode.lowLatency);
      await player.setAudioContext(
        AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers).build(),
      );
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setSource(AssetSource(file));
      players.add(player);
    }
    return _SfxPlayerPool(players);
  }

  void play({required double volume}) {
    if (_players.isEmpty) return;
    final player = _players[_nextIndex];
    _nextIndex = (_nextIndex + 1) % _players.length;
    try {
      player.setVolume(volume);
      player.seek(Duration.zero);
      player.resume();
    } catch (e) {
      debugPrint('Error playing preloaded SFX: $e');
    }
  }

  Future<void> dispose() async {
    for (final p in _players) {
      try {
        await p.dispose();
      } catch (_) {}
    }
    _players.clear();
  }
}


