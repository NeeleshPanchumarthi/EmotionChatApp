import 'message.dart';

class ChatSession {
  final String title;
  final List<Message> messages;

  ChatSession({required this.title, required this.messages});
}