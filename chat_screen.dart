import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_provider.dart';
import 'message_model.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat with AI')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final Message message =
                    chatProvider.messages[index]; // Specify Message type
                return ListTile(
                  title: Text(message.text),
                  subtitle: Text(
                    message.isUser ? "You" : "Assistant",
                    style: TextStyle(
                      color: message.isUser ? Colors.blue : Colors.green,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:
                        const InputDecoration(hintText: 'Type your message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      chatProvider.sendMessage(controller.text);
                      controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
