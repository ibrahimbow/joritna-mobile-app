import 'package:flutter/material.dart';

class TenantsLoading extends StatelessWidget {
  const TenantsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
