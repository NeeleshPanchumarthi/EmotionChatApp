import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountScreen extends StatelessWidget {
  final String username;
  final String? photoUrl;
  final ValueChanged<String>? onNameChanged;

  const AccountScreen(
      {super.key, required this.username, this.photoUrl, this.onNameChanged});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Profile card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E2030), Color(0xFF1A1D27)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.07)),
          ),
          child: Column(
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: const Color(0xFF6C63FF),
                  backgroundImage:
                      photoUrl != null ? NetworkImage(photoUrl!) : null,
                  child: photoUrl == null
                      ? Text(
                          username.isNotEmpty
                              ? username[0].toUpperCase()
                              : '?',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                username,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                photoUrl != null ? 'Signed in with Google' : 'Guest Account',
                style: GoogleFonts.outfit(
                  color: photoUrl != null
                      ? const Color(0xFF6C63FF)
                      : Colors.white38,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Options
        _optionTile(context, Icons.edit_outlined, 'Edit Profile', onTap: () {
          _showEditProfileDialog(context);
        }),
        _optionTile(context, Icons.palette_outlined, 'Theme'),
        _optionTile(context, Icons.notifications_outlined, 'Notifications'),
        _optionTile(context, Icons.security_outlined, 'Privacy & Security'),
        _optionTile(context, Icons.help_outline_rounded, 'Help & Support'),

        const SizedBox(height: 32),

        // Logout button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.withOpacity(0.15),
              foregroundColor: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.redAccent.withOpacity(0.3)),
              ),
            ),
            icon: const Icon(Icons.logout_rounded, size: 20),
            label: Text(
              'Logout',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            onPressed: () async {
              await GoogleSignIn().signOut();
              if (context.mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final controller = TextEditingController(text: username);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2030),
          title: Text('Edit Profile',
              style: GoogleFonts.outfit(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: GoogleFonts.outfit(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter your name...',
              hintStyle: GoogleFonts.outfit(color: Colors.white24),
              filled: true,
              fillColor: Colors.white.withOpacity(0.06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: GoogleFonts.outfit(color: Colors.white60)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
              ),
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty && onNameChanged != null) {
                  onNameChanged!(newName);
                }
                Navigator.pop(context);
              },
              child: Text('Save',
                  style: GoogleFonts.outfit(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _optionTile(BuildContext context, IconData icon, String title,
      {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D27),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Colors.white24,
          size: 20,
        ),
        onTap: onTap ?? () {},
      ),
    );
  }
}
