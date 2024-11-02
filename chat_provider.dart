import 'package:flutter/material.dart';
import 'message_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatProvider extends ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => _messages.reversed.toList();

  void sendMessage(String text) {
    _messages.add(Message(text: text, isUser: true));
    notifyListeners();
    _getAIResponse(text);
  }

  Future<void> _getAIResponse(String query) async {
    const apiKey = 'YOUR_API_KEY';
    const url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateText?key=$apiKey';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prompt': {
            'text': query,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final generatedText = data['candidates'][0]['output'];
        _messages.add(Message(text: generatedText, isUser: false));
      } else {
        _messages.add(Message(text: 'Error: ${response.body}', isUser: false));
      }
    } catch (e) {
      _messages.add(Message(text: 'An error occurred: $e', isUser: false));
    }
    notifyListeners();
  }
}
