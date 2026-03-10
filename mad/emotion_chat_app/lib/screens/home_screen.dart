import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_session.dart';
import '../models/message.dart';
import 'chat_screen.dart';
import 'account_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String? photoUrl;

  const HomeScreen({super.key, required this.username, this.photoUrl});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  late String currentUsername;

  List<ChatSession> sessions = [ChatSession(title: "New Chat", messages: [])];

  int activeSession = 0;

  @override
  void initState() {
    super.initState();
    currentUsername = widget.username;
  }

  void newChat() {
    setState(() {
      sessions.add(ChatSession(title: "Chat ${sessions.length}", messages: []));
      activeSession = sessions.length - 1;
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      ChatScreen(session: sessions[activeSession]),

      const Center(child: Text("Tap + to start new chat")),

      AccountScreen(
        username: currentUsername,
        photoUrl: widget.photoUrl,
        onNameChanged: (newName) {
          setState(() {
            currentUsername = newName;
          });
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1115),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF6C63FF),
              backgroundImage: widget.photoUrl != null
                  ? NetworkImage(widget.photoUrl!)
                  : null,
              child: widget.photoUrl == null
                  ? Text(
                      currentUsername.isNotEmpty
                          ? currentUsername[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.outfit(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              currentUsername,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded, color: Colors.white70),
            onPressed: newChat,
          )
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("Chat History")),

            for (int i = 0; i < sessions.length; i++)
              ListTile(
                title: Text(sessions[i].title),
                onTap: () {
                  setState(() {
                    activeSession = i;
                    currentIndex = 0;
                  });
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),

      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "New"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
