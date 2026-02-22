import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import 'database_provider.dart';

/// Watches all non-deleted photos for [entryId], ordered by creation date.
final photosForEntryProvider =
    StreamProvider.family<List<EntryPhoto>, String>((ref, entryId) {
  return ref
      .watch(databaseProvider)
      .photosDao
      .watchPhotosForEntry(entryId);
});

/// Handles photo mutations (insert, soft-delete) scoped to a specific entry.
class PhotoNotifier extends FamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String arg) async {}

  Future<void> addPhoto(EntryPhoto p) async {
    await ref.read(databaseProvider).photosDao.insertPhoto(p);
  }

  Future<void> deletePhoto(String id) async {
    await ref.read(databaseProvider).photosDao.softDeletePhoto(id);
  }
}

final photoNotifierProvider =
    AsyncNotifierProvider.family<PhotoNotifier, void, String>(
        () => PhotoNotifier());
