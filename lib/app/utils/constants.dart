import 'package:supabase_flutter/supabase_flutter.dart';

class EndPoints {
  EndPoints._();

  static const String baseUrl = 'https://yourapi/';
  static const String login = "auth/login";
  static const String user = "userdata";

  static const Duration timeout = Duration(seconds: 30);

  static const String token = 'authToken';

  static const String transcriptionUrl = 'https://api.openai.com/v1/audio/transcriptions';
  static const String OPEN_AI_API_KEY = "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";
  static const String transcribeModel = "whisper-1";
}

final supabase = Supabase.instance.client;

enum LoadDataState { initialize, loading, loaded, error, timeout, unknownerror }

extension StringCapitalization on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }

    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
