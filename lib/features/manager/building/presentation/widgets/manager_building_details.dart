import 'package:flutter/material.dart';

import '../../../../tenant/building/data/models/building.dart';
import 'manager_building_info_tile.dart';

class ManagerBuildingDetails extends StatelessWidget {
  final Building building;
  final VoidCallback onEdit;

  const ManagerBuildingDetails({
    super.key,
    required this.building,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'My Building',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_rounded),
                  color: const Color(0xFF0057C8),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ManagerBuildingInfoTile(
              icon: Icons.apartment_rounded,
              title: 'Building name',
              value: building.buildingName,
            ),
            ManagerBuildingInfoTile(
              icon: Icons.qr_code_rounded,
              title: 'Building code',
              value: building.code,
            ),
            ManagerBuildingInfoTile(
              icon: Icons.location_on_rounded,
              title: 'Address',
              value: building.address,
            ),
            ManagerBuildingInfoTile(
              icon: Icons.domain_rounded,
              title: 'Total apartments',
              value: building.totalApartments.toString(),
            ),
            ManagerBuildingInfoTile(
              icon: Icons.phone_rounded,
              title: 'Emergency phone',
              value: building.emergencyPhone,
            ),
          ],
        ),
      ),
    );
  }
}
