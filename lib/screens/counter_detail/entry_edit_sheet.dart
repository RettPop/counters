import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../providers/entries_provider.dart';
import '../../providers/photos_provider.dart';

/// Bottom sheet for editing a [CounterEntry]'s comment retroactively.
class EntryEditSheet extends ConsumerStatefulWidget {
  const EntryEditSheet({
    super.key,
    required this.entry,
    required this.counterId,
  });

  final CounterEntry entry;
  final String counterId;

  @override
  ConsumerState<EntryEditSheet> createState() => _EntryEditSheetState();
}

class _EntryEditSheetState extends ConsumerState<EntryEditSheet> {
  late final TextEditingController _commentController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _commentController =
        TextEditingController(text: widget.entry.comment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final trimmed = _commentController.text.trim();
      final updatedEntry = widget.entry.copyWith(
        comment: trimmed.isEmpty ? null : trimmed,
        updatedAt: DateTime.now(),
      );
      await ref
          .read(entryNotifierProvider(widget.counterId).notifier)
          .updateEntry(updatedEntry);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.snackbarSaveFailed(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickFromGallery() => _pickPhoto(ImageSource.gallery);
  Future<void> _pickFromCamera() => _pickPhoto(ImageSource.camera);

  Future<void> _pickPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;

    // Copy to app documents directory
    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${appDir.path}/entry_photos');
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    final ext = picked.path.split('.').last;
    final uuid = const Uuid().v4();
    final dest = '${photosDir.path}/$uuid.$ext';
    await File(picked.path).copy(dest);

    final now = DateTime.now();
    final photo = EntryPhoto(
      id: uuid,
      entryId: widget.entry.id,
      localPath: dest,
      createdAt: now,
    );

    if (!mounted) return;
    await ref
        .read(photoNotifierProvider(widget.entry.id).notifier)
        .addPhoto(photo);
  }

  Future<void> _deletePhoto(EntryPhoto photo) async {
    // Soft-delete in DB
    await ref
        .read(photoNotifierProvider(photo.entryId).notifier)
        .deletePhoto(photo.id);
    if (!mounted) return;
    // Delete file from disk
    final file = File(photo.localPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final photosAsync = ref.watch(photosForEntryProvider(widget.entry.id));
    final photos = photosAsync.valueOrNull ?? [];

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              16, 8, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Text(
                l10n.editEntryTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Comment field
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: l10n.fieldComment,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                autofocus: true,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 16),

              // Photos section
              Text(
                l10n.buttonAddPhoto,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length + 1, // +1 for add button
                  itemBuilder: (context, index) {
                    if (index == photos.length) {
                      return _AddPhotoButton(
                        onGallery: _pickFromGallery,
                        onCamera: _pickFromCamera,
                        l10n: l10n,
                      );
                    }
                    final photo = photos[index];
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(photo.localPath),
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 72,
                                height: 72,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => _deletePhoto(photo),
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.buttonSave),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// A compact button that shows "From gallery" and "Camera" options.
class _AddPhotoButton extends StatelessWidget {
  const _AddPhotoButton({
    required this.onGallery,
    required this.onCamera,
    required this.l10n,
  });

  final VoidCallback onGallery;
  final VoidCallback onCamera;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 34,
            child: OutlinedButton.icon(
              onPressed: onGallery,
              icon: const Icon(Icons.photo_library_outlined, size: 16),
              label: Text(l10n.buttonFromGallery,
                  style: const TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 34,
            child: OutlinedButton.icon(
              onPressed: onCamera,
              icon: const Icon(Icons.camera_alt_outlined, size: 16),
              label: Text(l10n.buttonCamera,
                  style: const TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
