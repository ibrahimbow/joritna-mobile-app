import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/router/app_routes.dart';
import '../../../../../core/file/file_url_resolver.dart';
import '../../files/data/file_providers.dart';
import '../../../shared/presentation/layout/app_shell.dart';
import '../data/models/requests/create_share_and_help_post_request.dart';
import '../data/models/share_and_help_post.dart';
import '../data/share_and_help_providers.dart';
import '../../../../../core/file/file_type.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key, this.postToEdit});

  final ShareAndHelpPost? postToEdit;

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;
  String? _imageUrl;

  bool _isSubmitting = false;
  bool _isUploadingImage = false;

  bool get _isEditMode => widget.postToEdit != null;

  @override
  void initState() {
    super.initState();

    final post = widget.postToEdit;

    if (post != null) {
      _titleController.text = post.title;
      _descriptionController.text = post.description;
      _imageUrl = post.imageUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) {
      return;
    }

    setState(() {
      _selectedImage = image;
      _isUploadingImage = true;
    });

    try {
      final uploadedFile = await ref
          .read(fileApiClientProvider)
          .uploadImage(image: image, type: FileType.shareAndHelpImage);

      if (!mounted) {
        return;
      }

      setState(() {
        _imageUrl = uploadedFile.url;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

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

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate() ||
        _isSubmitting ||
        _isUploadingImage) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSubmitting = true;
    });

    final request = CreateShareAndHelpPostRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: _imageUrl,
    );

    try {
      final repository = ref.read(shareAndHelpRepositoryProvider);

      if (_isEditMode) {
        await repository.updatePost(
          postId: widget.postToEdit!.id,
          request: request,
        );
      } else {
        await repository.createPost(request);
      }

      ref.invalidate(shareAndHelpPostsProvider);

      if (!mounted) {
        return;
      }

      context.go(AppRoutes.tenantShareAndHelp);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode
                ? 'Could not update post: $error'
                : 'Could not create post: $error',
          ),
        ),
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

    return AppShell(
      selectedIndex: 4,
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Text(
                _isEditMode
                    ? 'Edit Share & Help Post'
                    : 'Create Share & Help Post',
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isEditMode
                    ? 'Update your post so neighbours see the latest information.'
                    : 'Ask for help, share something useful, or support your neighbours.',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                maxLength: 150,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Example: Anyone has a drill?',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: (value) {
                  final trimmedValue = value?.trim() ?? '';

                  if (trimmedValue.isEmpty) {
                    return 'Title is required';
                  }

                  if (trimmedValue.length > 150) {
                    return 'Title must not exceed 150 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLength: 5000,
                minLines: 5,
                maxLines: 8,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Explain what you need or want to share...',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: (value) {
                  final trimmedValue = value?.trim() ?? '';

                  if (trimmedValue.isEmpty) {
                    return 'Description is required';
                  }

                  if (trimmedValue.length > 5000) {
                    return 'Description must not exceed 5000 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
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
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: canSubmit ? _submitPost : null,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          _isEditMode ? Icons.save_rounded : Icons.send_rounded,
                        ),
                  label: Text(
                    _isUploadingImage
                        ? 'Uploading image...'
                        : _isSubmitting
                        ? _isEditMode
                              ? 'Saving...'
                              : 'Posting...'
                        : _isEditMode
                        ? 'Save changes'
                        : 'Post',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
