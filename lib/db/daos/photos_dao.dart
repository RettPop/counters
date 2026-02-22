import 'package:drift/drift.dart';

import '../../models/models.dart' as domain;
import '../database.dart';
import '../tables/entry_photos_table.dart';

part 'photos_dao.g.dart';

@DriftAccessor(tables: [EntryPhotos])
class PhotosDao extends DatabaseAccessor<AppDatabase> with _$PhotosDaoMixin {
  PhotosDao(super.db);

  /// Stream of photos for an entry, excluding soft-deleted.
  Stream<List<domain.EntryPhoto>> watchPhotosForEntry(String entryId) {
    return (select(entryPhotos)
          ..where((t) => t.entryId.equals(entryId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch()
        .map((rows) => rows.map(_rowToDomain).toList());
  }

  /// Insert a new photo.
  Future<void> insertPhoto(domain.EntryPhoto p) {
    return into(entryPhotos).insert(_domainToCompanion(p));
  }

  /// Soft-delete a photo.
  Future<void> softDeletePhoto(String id) {
    return (update(entryPhotos)..where((t) => t.id.equals(id))).write(
      EntryPhotosCompanion(
        deletedAt: Value(DateTime.now()),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Private mapping helpers
  // ---------------------------------------------------------------------------

  domain.EntryPhoto _rowToDomain(EntryPhoto row) {
    return domain.EntryPhoto(
      id: row.id,
      entryId: row.entryId,
      localPath: row.localPath,
      createdAt: row.createdAt,
      deletedAt: row.deletedAt,
    );
  }

  EntryPhotosCompanion _domainToCompanion(domain.EntryPhoto p) {
    return EntryPhotosCompanion(
      id: Value(p.id),
      entryId: Value(p.entryId),
      localPath: Value(p.localPath),
      createdAt: Value(p.createdAt),
      deletedAt: Value(p.deletedAt),
    );
  }
}
