import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:voicepals/app/data/api/api_connect.dart';
import 'package:voicepals/app/utils/constants.dart';
import 'package:http/http.dart' as http;
import '../../utils/common.dart';
import '../api/supabase_api.dart';
import '../model/message.dart';

class ChatProvider {
  ChatProvider();

  final ApiService _apiService = ApiService();
  ApiConnect api = ApiConnect.instance;

  Stream<List<Message>> getRoomsStream(String roomID) {
    return _apiService.subscribeToMessagesStream(roomID);
  }

  Future<void> updateMessagPlayed({required String messageID, required String roomID}) async {
    try {
      await _apiService.updateMessagPlayed(messageID: messageID, roomID: roomID);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateMessageRead({required String messageID, required String roomID}) async {
    try {
      await _apiService.updateMessageRead(messageID: messageID, roomID: roomID);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateMessageVisibility({required String messageID, required String roomID}) async {
    try {
      await _apiService.updateMessageVisibility(messageID: messageID, roomID: roomID);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> sendMessage(String content, String roomID, String content_link) async {
    try {
      await _apiService.sendMessage(content, roomID, content_link);
    } catch (e) {
      Common.showError(e.toString());
    }
  }

  Future<String> uploadMessageToStorageBucket(String filePath, File file) async {
    try {
      var response = await _apiService.uploadMessageToStorageBucket(filePath, file);
      log(response.toString());
      return response;
    } catch (e) {
      Common.showError(e.toString());
      rethrow;
    }
  }

  Future<String> transcribeAudio(String filePath) async {
    try {
      final response = await http.get(Uri.parse(filePath));
      if (response.statusCode == 200) {
        log(response.bodyBytes.toString());
        final responseFromTranscriptions = await api.post(
          'https://api.openai.com/v1/audio/transcriptions',
          FormData(
            {'file': MultipartFile(response.bodyBytes, filename: "order.m4a"), 'model': EndPoints.transcribeModel, "response_format": "text"},
          ),
          headers: {'Authorization': 'Bearer ${EndPoints.OPEN_AI_API_KEY}'},
          contentType: 'multipart/form-data',
        );
        if (responseFromTranscriptions.status.isOk) {
          return responseFromTranscriptions.bodyString.toString();
        } else {
          Common.showError(responseFromTranscriptions.statusCode.toString());
          throw Exception('Failed to transcribe audio: ${responseFromTranscriptions.statusCode} ${responseFromTranscriptions.statusText}');
        }
      } else {
        Common.showError(response.statusCode.toString());
        throw Exception('Failed to fetch audio: ${response.statusCode}');
      }
    } catch (e) {
      Common.showError(e.toString());
      rethrow;
    }
  }
}
