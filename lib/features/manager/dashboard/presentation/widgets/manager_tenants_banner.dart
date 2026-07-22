import 'package:flutter/material.dart';

class ManagerTenantsBanner extends StatelessWidget {
  const ManagerTenantsBanner({
    super.key,
    required this.totalTenants,
    required this.onTap,
  });

  final int totalTenants;
  final VoidCallback onTap;

  static const Color _primaryBlue = Color(0xFF0057C8);
  static const Color _darkText = Color(0xFF0F172A);
  static const Color _mutedText = Color(0xFF64748B);
  static const Color _softBorder = Color(0xFFE6F0FF);

  @override
  Widget build(BuildContext context) {
    final residentsLabel = totalTenants == 1
        ? '1 Active Resident'
        : '$totalTenants Active Residents';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          height: 108,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEAF3FF), Color(0xFFF6FAFF), Colors.white],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border(
              left: const BorderSide(color: _softBorder),
              right: const BorderSide(color: _softBorder),
              bottom: const BorderSide(color: _softBorder),
              top: BorderSide.none,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF3FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  color: _primaryBlue,
                  size: 30,
                ),
              ),

              const SizedBox(width: 16),

              Container(width: 1, height: 58, color: _softBorder),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Building Tenants',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: _darkText,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      residentsLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _mutedText,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Manage residents',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: _primaryBlue,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
