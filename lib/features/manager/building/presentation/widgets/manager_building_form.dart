import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../tenant/building/data/models/building.dart';
import '../../data/manager_building_providers.dart';
import '../../data/models/create_building_request.dart';
import '../../data/models/update_building_request.dart';
import 'manager_building_header.dart';
import 'manager_building_text_field.dart';

class ManagerBuildingForm extends ConsumerStatefulWidget {
  final Building? building;
  final VoidCallback? onCompleted;

  const ManagerBuildingForm({super.key, this.building, this.onCompleted});

  @override
  ConsumerState<ManagerBuildingForm> createState() =>
      _ManagerBuildingFormState();
}

class _ManagerBuildingFormState extends ConsumerState<ManagerBuildingForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _buildingNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _totalApartmentsController;
  late final TextEditingController _emergencyPhoneController;

  bool _isSubmitting = false;
  String? _errorMessage;

  bool get _isUpdateMode => widget.building != null;

  @override
  void initState() {
    super.initState();

    _buildingNameController = TextEditingController(
      text: widget.building?.buildingName ?? '',
    );
    _addressController = TextEditingController(
      text: widget.building?.address ?? '',
    );
    _totalApartmentsController = TextEditingController(
      text: widget.building?.totalApartments.toString() ?? '',
    );
    _emergencyPhoneController = TextEditingController(
      text: widget.building?.emergencyPhone ?? '',
    );
  }

  @override
  void dispose() {
    _buildingNameController.dispose();
    _addressController.dispose();
    _totalApartmentsController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(managerBuildingRepositoryProvider);

      if (_isUpdateMode) {
        await repository.updateBuilding(
          id: widget.building!.id,
          request: UpdateBuildingRequest(
            buildingName: _buildingNameController.text.trim(),
            address: _addressController.text.trim(),
            totalApartments: int.parse(_totalApartmentsController.text.trim()),
            emergencyPhone: _emergencyPhoneController.text.trim(),
          ),
        );
      } else {
        await repository.createBuilding(
          CreateBuildingRequest(
            buildingName: _buildingNameController.text.trim(),
            address: _addressController.text.trim(),
            totalApartments: int.parse(_totalApartmentsController.text.trim()),
            emergencyPhone: _emergencyPhoneController.text.trim(),
          ),
        );
      }

      ref.invalidate(myManagedBuildingsProvider);
      ref.invalidate(myManagedBuildingProvider);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isUpdateMode
                ? 'Building updated successfully.'
                : 'Building created successfully.',
          ),
        ),
      );

      widget.onCompleted?.call();
    } catch (_) {
      setState(() {
        _errorMessage = _isUpdateMode
            ? 'Could not update building. Please try again.'
            : 'Could not create building. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            final horizontalPadding = isWide ? 32.0 : 20.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                24,
                horizontalPadding,
                32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ManagerBuildingHeader(),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                _isUpdateMode
                                    ? 'Update your building'
                                    : 'Create your building',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _isUpdateMode
                                    ? 'Keep your building information accurate and up to date.'
                                    : 'Add your building details to start managing tenants, announcements, chat, and community posts.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ManagerBuildingTextField(
                                controller: _buildingNameController,
                                label: 'Building name',
                                icon: Icons.apartment_rounded,
                                validator: (value) {
                                  final text = value?.trim() ?? '';

                                  if (text.length < 2) {
                                    return 'Building name must be at least 2 characters.';
                                  }

                                  if (text.length > 80) {
                                    return 'Building name is too long.';
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              ManagerBuildingTextField(
                                controller: _addressController,
                                label: 'Address',
                                icon: Icons.location_on_rounded,
                                validator: (value) {
                                  final text = value?.trim() ?? '';

                                  if (text.length < 5) {
                                    return 'Address must be at least 5 characters.';
                                  }

                                  if (text.length > 150) {
                                    return 'Address is too long.';
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              ManagerBuildingTextField(
                                controller: _totalApartmentsController,
                                label: 'Total apartments',
                                icon: Icons.domain_rounded,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  final number = int.tryParse(
                                    value?.trim() ?? '',
                                  );

                                  if (number == null) {
                                    return 'Enter a valid number.';
                                  }

                                  if (number < 4) {
                                    return 'Total apartments must be at least 4.';
                                  }

                                  if (number > 500) {
                                    return 'Total apartments cannot exceed 500.';
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              ManagerBuildingTextField(
                                controller: _emergencyPhoneController,
                                label: 'Emergency phone',
                                icon: Icons.phone_rounded,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  final phone = value?.trim() ?? '';

                                  final isValid = RegExp(
                                    r'^\+?[0-9\s().-]+$',
                                  ).hasMatch(phone);

                                  final digits = phone
                                      .replaceAll(RegExp(r'\D'), '')
                                      .length;

                                  if (!isValid || digits < 10 || digits > 15) {
                                    return 'Enter a valid emergency phone.';
                                  }

                                  return null;
                                },
                              ),
                              if (_errorMessage != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24),
                              SizedBox(
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _isSubmitting ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0057C8),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          _isUpdateMode
                                              ? 'Update Building'
                                              : 'Create Building',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
