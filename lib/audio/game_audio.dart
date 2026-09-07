import 'dart:io' show Platform;
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameAudio {
  static const String boxRelease = 'box_release.wav';
  static const String boxLand = 'box_land.wav';
  static const String gameOver = 'game_over.wav';
  static const String highScore = 'high_score.wav';

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
        ]);

        // 2. Pre-create and pre-source dedicated native players for zero-latency playback
        _releasePool = await _SfxPlayerPool.create(file: boxRelease, poolSize: 2);
        _landPool = await _SfxPlayerPool.create(file: boxLand, poolSize: 2);
        _gameOverPool = await _SfxPlayerPool.create(file: gameOver, poolSize: 1);
        _highScorePool = await _SfxPlayerPool.create(file: highScore, poolSize: 1);
      }
      _isInitialized = true;
    } catch (e) {
      debugPrint('GameAudio initialize notice: $e');
    }
  }

  /// Plays short "tik" release sound when box is dropped from pendulum.
  static void playBoxRelease() {
    _playEvent(boxRelease);
    if (!soundEnabled || _isTest) return;
    if (_releasePool != null) {
      _releasePool!.play(volume: 0.45);
    } else {
      _fallbackPlay(boxRelease, volume: 0.45);
    }
  }

  /// Plays short "tuk" landing sound when box lands successfully on stack.
  static void playBoxLand() {
    _playEvent(boxLand);
    if (!soundEnabled || _isTest) return;
    if (_landPool != null) {
      _landPool!.play(volume: 0.50);
    } else {
      _fallbackPlay(boxLand, volume: 0.50);
    }
  }

  /// Plays sad game-over sound when tower collapses and game ends.
  static void playGameOver() {
    _playEvent(gameOver);
    if (!soundEnabled || _isTest) return;
    if (_gameOverPool != null) {
      _gameOverPool!.play(volume: 0.55);
    } else {
      _fallbackPlay(gameOver, volume: 0.55);
    }
  }

  /// Plays four-note ascending fanfare when player achieves a new high score.
  static void playHighScore() {
    _playEvent(highScore);
    if (!soundEnabled || _isTest) return;
    if (_highScorePool != null) {
      _highScorePool!.play(volume: 0.55);
    } else {
      _fallbackPlay(highScore, volume: 0.55);
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

  // --- Background Music (Prepared for upcoming Suno-generated BGM) ---

  static bool _bgmPlaying = false;

  /// Starts looping background music track.
  static void playBgm(String trackName, {double volume = 0.4}) {
    if (!soundEnabled) return;
    if (_isTest) {
      _bgmPlaying = true;
      return;
    }
    try {
      FlameAudio.bgm.play(trackName, volume: volume);
      _bgmPlaying = true;
    } catch (e) {
      debugPrint('GameAudio playBgm notice: $e');
    }
  }

  /// Stops current background music.
  static void stopBgm() {
    if (!_bgmPlaying) return;
    if (_isTest) {
      _bgmPlaying = false;
      return;
    }
    try {
      FlameAudio.bgm.stop();
      _bgmPlaying = false;
    } catch (e) {
      debugPrint('GameAudio stopBgm notice: $e');
    }
  }

  /// Disposes all pre-loaded players and clears resources.
  static Future<void> dispose() async {
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

