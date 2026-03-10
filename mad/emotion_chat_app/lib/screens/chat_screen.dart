import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/chat_session.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final ChatSession session;

  const ChatScreen({super.key, required this.session});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final scrollController = ScrollController();

  /// ⭐ For auto keyboard
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    /// 🔥 Open keyboard automatically
    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) return;

    String text = controller.text;

    // ✅ Add user message
    setState(() {
      widget.session.messages.add(Message(text: text, isUser: true));
      controller.clear();
    });

    scrollDown();

    try {
      final res = await http.post(
        Uri.parse("http://10.107.87.251:5012/chat"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": text}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final emotion = data["emotion"] ?? "neutral";
        final confidence = data["confidence"] ?? 0;

        // 🎭 Emotion → Emoji
        String emoji = "😐";

        switch (emotion) {
          case "joy":
            emoji = "😊";
            break;
          case "sadness":
            emoji = "😢";
            break;
          case "anger":
            emoji = "😠";
            break;
          case "fear":
            emoji = "😨";
            break;
          case "surprise":
            emoji = "😲";
            break;
        }

        // ✅ Bot message with emotion
        setState(() {
          widget.session.messages.add(
            Message(
              text:
                  "$emoji Emotion: $emotion (${confidence.toStringAsFixed(2)})\n\n${data["reply"]}",
              isUser: false,
            ),
          );
        });
      } else {
        widget.session.messages.add(
          Message(text: "Server error", isUser: false),
        );
      }
    } catch (e) {
      setState(() {
        widget.session.messages.add(
          Message(text: "Connection error 😢", isUser: false),
        );
      });
    }

    scrollDown();

    /// 🔥 Keep keyboard open after sending
    FocusScope.of(context).requestFocus(focusNode);
  }

  void scrollDown() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 💬 Messages
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: widget.session.messages.length,
            itemBuilder: (_, i) =>
                MessageBubble(message: widget.session.messages[i]),
          ),
        ),

        /// ✏️ Input bar
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode, // ⭐ IMPORTANT
                  decoration: InputDecoration(
                    hintText: "Message...",
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),

                  /// Enter key sends message
                  onSubmitted: (_) => sendMessage(),
                ),
              ),
            ),

            IconButton(icon: const Icon(Icons.send), onPressed: sendMessage),
          ],
        ),
      ],
    );
  }
}
