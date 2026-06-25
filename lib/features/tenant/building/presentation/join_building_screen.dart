import 'package:flutter/material.dart';

class JoinBuildingScreen extends StatelessWidget {
  const JoinBuildingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF0F172A),
        title: const Text(
          'Join Building',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6EFFD),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.apartment_rounded,
                      size: 56,
                      color: Color(0xFF0057C8),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Join Your Building',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Enter the building code provided by your building manager to unlock Announcements, Chat and Share & Help.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 36),
                  TextField(
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Building Code',
                      hintText: 'Example: BM-447124',
                      prefixIcon: const Icon(
                        Icons.key_rounded,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () {
                        // TODO: Join Building
                      },
                      icon: const Icon(
                        Icons.login_rounded,
                      ),
                      label: const Text(
                        'Join Building',
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'You only need to join your building once.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}