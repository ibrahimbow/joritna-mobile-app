import 'package:flutter/material.dart';

class ManagerBuildingHeader extends StatelessWidget {
  const ManagerBuildingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0057C8), Color(0xFF0F75FF)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.business_rounded, color: Colors.white, size: 34),
          SizedBox(height: 16),
          Text(
            'Welcome Manager',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first building to unlock the manager dashboard.',
            style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }
}
