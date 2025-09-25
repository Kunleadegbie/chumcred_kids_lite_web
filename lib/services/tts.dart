import 'package:flutter_tts/flutter_tts.dart';

class TTS {
  static final FlutterTts _tts = FlutterTts();
  Future<void> speak(String text, {String lang='en-US'}) async {
    await _tts.setLanguage(lang);
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }
}
