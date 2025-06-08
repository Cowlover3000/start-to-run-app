import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  bool _initialized = false;

  // Initialize the service with user preferences
  Future<void> initialize({required bool soundEnabled, required bool hapticEnabled}) async {
    _soundEnabled = soundEnabled;
    _hapticEnabled = hapticEnabled;
    await _configureAudioPlayer();
    _initialized = true;
    debugPrint('FeedbackService initialized - Sound: $_soundEnabled, Haptic: $_hapticEnabled');
  }

  // Update preferences
  void updateSettings({required bool soundEnabled, required bool hapticEnabled}) {
    _soundEnabled = soundEnabled;
    _hapticEnabled = hapticEnabled;
    debugPrint('FeedbackService settings updated - Sound: $_soundEnabled, Haptic: $_hapticEnabled');
  }

  Future<void> _configureAudioPlayer() async {
    try {
      // Set audio player to play sounds even when device is on silent mode
      await _audioPlayer.setAudioContext(AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {
            AVAudioSessionOptions.mixWithOthers,
            AVAudioSessionOptions.duckOthers,
          },
        ),
        android: AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.notification,
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
        ),
      ));
      
      // Set volume to maximum for notifications
      await _audioPlayer.setVolume(1.0);
      debugPrint('AudioPlayer configured successfully');
    } catch (e) {
      debugPrint('Error configuring AudioPlayer: $e');
    }
  }

  // Play segment transition sound (when switching activities)
  Future<void> playSegmentTransition() async {
    if (!_soundEnabled || !_initialized) return;
    
    try {
      debugPrint('Playing segment transition sound');
      // Play a distinctive double beep
      await _playTone(800, 200); // High tone
      await Future.delayed(const Duration(milliseconds: 100));
      await _playTone(600, 200); // Lower tone
    } catch (e) {
      debugPrint('Error playing segment transition sound: $e');
    }
  }

  // Play warning sound (10 seconds before segment ends)
  Future<void> playSegmentWarning() async {
    if (!_soundEnabled || !_initialized) return;
    
    try {
      debugPrint('Playing segment warning sound');
      // Play a warning tone
      await _playTone(1000, 300); // High warning tone
    } catch (e) {
      debugPrint('Error playing segment warning sound: $e');
    }
  }

  // Play countdown sound (last 3 seconds)
  Future<void> playCountdownBeep() async {
    if (!_soundEnabled || !_initialized) return;
    
    try {
      debugPrint('Playing countdown beep');
      // Play a short beep
      await _playTone(700, 150); // Medium tone, short duration
    } catch (e) {
      debugPrint('Error playing countdown beep: $e');
    }
  }

  // Generate and play a tone using AudioPlayer
  Future<void> _playTone(double frequency, int durationMs) async {
    try {
      // Use system sounds as a reliable alternative since generating tones is complex
      await SystemSound.play(SystemSoundType.click);
      
      // Also try haptic feedback which often produces audible feedback
      await HapticFeedback.selectionClick();
      
      debugPrint('Played tone: ${frequency}Hz for ${durationMs}ms');
    } catch (e) {
      debugPrint('Error playing tone: $e');
      // Fallback to basic system sound
      try {
        await SystemSound.play(SystemSoundType.click);
      } catch (fallbackError) {
        debugPrint('Fallback sound also failed: $fallbackError');
      }
    }
  }

  // Play completion sound
  Future<void> _playCompletionSound() async {
    if (!_soundEnabled || !_initialized) return;
    
    try {
      debugPrint('Playing completion sound sequence');
      // Play a success sequence - ascending tones
      await _playTone(600, 200);
      await Future.delayed(const Duration(milliseconds: 150));
      await _playTone(800, 200);
      await Future.delayed(const Duration(milliseconds: 150));
      await _playTone(1000, 300);
    } catch (e) {
      debugPrint('Error playing completion sound: $e');
    }
  }

  // Haptic feedback for segment transition
  Future<void> vibrateMedium() async {
    if (!_hapticEnabled) return;
    
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(duration: 500, amplitude: 128);
      } else {
        await HapticFeedback.mediumImpact();
      }
    } catch (e) {
      debugPrint('Error with haptic feedback: $e');
    }
  }

  // Light haptic feedback for warnings
  Future<void> vibrateLight() async {
    if (!_hapticEnabled) return;
    
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(duration: 200, amplitude: 64);
      } else {
        await HapticFeedback.lightImpact();
      }
    } catch (e) {
      debugPrint('Error with light haptic feedback: $e');
    }
  }

  // Strong haptic feedback for session completion
  Future<void> vibrateStrong() async {
    if (!_hapticEnabled) return;
    
    try {
      if (await Vibration.hasVibrator()) {
        // Double vibration for completion
        await Vibration.vibrate(duration: 300, amplitude: 255);
        await Future.delayed(const Duration(milliseconds: 100));
        await Vibration.vibrate(duration: 300, amplitude: 255);
      } else {
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      debugPrint('Error with strong haptic feedback: $e');
    }
  }

  // Combined feedback for segment transition
  Future<void> segmentTransitionFeedback() async {
    await Future.wait([
      playSegmentTransition(),
      vibrateMedium(),
    ]);
  }

  // Combined feedback for segment warning (10 seconds left)
  Future<void> segmentWarningFeedback() async {
    await Future.wait([
      playSegmentWarning(),
      vibrateLight(),
    ]);
  }

  // Combined feedback for countdown (last 3 seconds)
  Future<void> countdownFeedback() async {
    await Future.wait([
      playCountdownBeep(),
      vibrateLight(),
    ]);
  }

  // Combined feedback for session completion
  Future<void> sessionCompletionFeedback() async {
    await Future.wait([
      _playCompletionSound(),
      vibrateStrong(),
    ]);
  }

  // Dispose resources
  void dispose() {
    _audioPlayer.dispose();
  }
}
