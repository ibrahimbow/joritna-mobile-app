import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/file/file_type.dart';
import '../../../../../core/file/file_url_resolver.dart';
import '../../data/models/manager_announcement.dart';
import 'manager_announcement_category_dropdown.dart';
import '../../../../community/files/data/file_providers.dart';

class ManagerAnnouncementForm extends ConsumerStatefulWidget {
  final String submitLabel;
  final ManagerAnnouncement? initialAnnouncement;
  final Future<void> Function(
    String title,
    String message,
    AnnouncementCategory category,
    String? imageUrl,
  )
  onSubmit;

  const ManagerAnnouncementForm({
    super.key,
    required this.submitLabel,
    required this.onSubmit,
    this.initialAnnouncement,
  });

  @override
  ConsumerState<ManagerAnnouncementForm> createState() =>
      _ManagerAnnouncementFormState();
}

class _ManagerAnnouncementFormState
    extends ConsumerState<ManagerAnnouncementForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;
  String? _imageUrl;

  late AnnouncementCategory _selectedCategory;

  bool _isSubmitting = false;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();

    final announcement = widget.initialAnnouncement;

    _titleController.text = announcement?.title ?? '';
    _messageController.text = announcement?.message ?? '';
    _imageUrl = announcement?.imageUrl;
    _selectedCategory = announcement?.category ?? AnnouncementCategory.general;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = image;
      _isUploadingImage = true;
    });

    try {
      final uploadedFile = await ref
          .read(fileApiClientProvider)
          .uploadImage(image: image, type: FileType.announcementImage);

      if (!mounted) return;

      setState(() {
        _imageUrl = uploadedFile.url;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _selectedImage = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not upload image: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageUrl = null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        _isSubmitting ||
        _isUploadingImage) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(
        _titleController.text.trim(),
        _messageController.text.trim(),
        _selectedCategory,
        _imageUrl,
      );
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
    final canSubmit = !_isSubmitting && !_isUploadingImage;
    final resolvedImageUrl = FileUrlResolver.resolve(_imageUrl);

    return Form(
      key: _formKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          TextFormField(
            controller: _titleController,
            maxLength: 255,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Title',
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) return 'Title is required';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _messageController,
            minLines: 5,
            maxLines: 9,
            maxLength: 5000,
            decoration: InputDecoration(
              labelText: 'Message',
              alignLabelWithHint: true,
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) return 'Message is required';
              return null;
            },
          ),
          const SizedBox(height: 12),
          ManagerAnnouncementCategoryDropdown(
            value: _selectedCategory,
            onChanged: (category) {
              if (category == null) return;
              setState(() => _selectedCategory = category);
            },
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _isUploadingImage ? null : _pickAndUploadImage,
            icon: _isUploadingImage
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.image_outlined),
            label: Text(
              _isUploadingImage
                  ? 'Uploading image...'
                  : _imageUrl == null
                  ? 'Add image'
                  : 'Change image',
            ),
          ),
          if (_selectedImage != null || resolvedImageUrl.isNotEmpty) ...[
            const SizedBox(height: 12),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _selectedImage != null
                        ? Image.file(
                            File(_selectedImage!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Image.network(
                            resolvedImageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: _isUploadingImage ? null : _removeImage,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 28),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: canSubmit ? _submit : null,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded),
              label: Text(
                _isUploadingImage
                    ? 'Uploading image...'
                    : _isSubmitting
                    ? 'Saving...'
                    : widget.submitLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
