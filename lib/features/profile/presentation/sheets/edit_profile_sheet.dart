import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/file/file_url_resolver.dart';
import '../../data/models/current_user_profile.dart';
import '../../data/models/update_profile_request.dart';
import '../../data/profile_providers.dart';

class EditProfileSheet extends ConsumerStatefulWidget {
  const EditProfileSheet({super.key, required this.profile});

  final CurrentUserProfile profile;

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _displayNameController;
  late final TextEditingController _phoneNumberController;

  File? _selectedAvatarFile;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _displayNameController = TextEditingController(
      text: widget.profile.displayName,
    );

    _phoneNumberController = TextEditingController(
      text: widget.profile.phoneNumber,
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentAvatarUrl = FileUrlResolver.resolve(widget.profile.avatarUrl);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Edit profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFE2E7FF),
                    backgroundImage: _selectedAvatarFile != null
                        ? FileImage(_selectedAvatarFile!)
                        : currentAvatarUrl.isNotEmpty
                        ? NetworkImage(currentAvatarUrl)
                        : null,
                    child: _saving
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : _selectedAvatarFile == null &&
                              currentAvatarUrl.isEmpty
                        ? const Icon(Icons.person, size: 44)
                        : null,
                  ),
                  IconButton.filled(
                    onPressed: _saving ? null : _pickAvatar,
                    icon: const Icon(Icons.camera_alt_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _displayNameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Display name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';

                  if (text.isEmpty) {
                    return 'Display name is required';
                  }

                  if (text.length < 2) {
                    return 'Display name is too short';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save changes'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: _saving ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (image == null) {
      return;
    }

    setState(() {
      _selectedAvatarFile = File(image.path);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _saving = true);

    try {
      String? avatarUrl = widget.profile.avatarUrl;

      if (_selectedAvatarFile != null) {
        avatarUrl = await ref
            .read(profileAvatarApiClientProvider)
            .uploadAvatar(_selectedAvatarFile!);

        if (!mounted) {
          return;
        }
      }

      final request = UpdateProfileRequest(
        displayName: _displayNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        avatarUrl: avatarUrl,
        preferredLanguage: widget.profile.preferredLanguage,
        notificationsEnabled: widget.profile.notificationsEnabled,
      );

      await ref.read(profileRepositoryProvider).updateProfile(request);

      ref.invalidate(profileProvider);
      await ref.read(profileProvider.future);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}
