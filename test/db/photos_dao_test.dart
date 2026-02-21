import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:counters/db/database.dart';
import 'package:counters/models/models.dart' as domain;

AppDatabase openTestDb() => AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  late AppDatabase db;

  setUp(() => db = openTestDb());
  tearDown(() => db.close());

  final now = DateTime(2024, 6, 1, 12);

  domain.EntryPhoto makePhoto({
    String id = 'p-1',
    String entryId = 'e-1',
    String localPath = '/tmp/photo.jpg',
    DateTime? createdAt,
  }) =>
      domain.EntryPhoto(
        id: id,
        entryId: entryId,
        localPath: localPath,
        createdAt: createdAt ?? now,
      );

  group('PhotosDao', () {
    test('insert photo and retrieve via watchPhotosForEntry', () async {
      await db.photosDao.insertPhoto(makePhoto());

      final list = await db.photosDao.watchPhotosForEntry('e-1').first;
      expect(list.length, 1);
      expect(list[0].id, 'p-1');
      expect(list[0].entryId, 'e-1');
      expect(list[0].localPath, '/tmp/photo.jpg');
      expect(list[0].deletedAt, isNull);
    });

    test('soft-delete photo disappears from stream', () async {
      await db.photosDao.insertPhoto(makePhoto());

      final before = await db.photosDao.watchPhotosForEntry('e-1').first;
      expect(before.length, 1);

      await db.photosDao.softDeletePhoto('p-1');

      final after = await db.photosDao.watchPhotosForEntry('e-1').first;
      expect(after, isEmpty);
    });

    test('watchPhotosForEntry is scoped to the given entryId', () async {
      await db.photosDao.insertPhoto(makePhoto(id: 'p-1', entryId: 'e-1'));
      await db.photosDao.insertPhoto(makePhoto(id: 'p-2', entryId: 'e-2'));

      final list = await db.photosDao.watchPhotosForEntry('e-1').first;
      expect(list.length, 1);
      expect(list[0].id, 'p-1');
    });

    test('watchPhotosForEntry returns empty list when no photos exist',
        () async {
      final list =
          await db.photosDao.watchPhotosForEntry('no-such-entry').first;
      expect(list, isEmpty);
    });

    test('multiple photos for same entry are all returned', () async {
      await db.photosDao
          .insertPhoto(makePhoto(id: 'p-1', localPath: '/tmp/a.jpg'));
      await db.photosDao
          .insertPhoto(makePhoto(id: 'p-2', localPath: '/tmp/b.jpg'));

      final list = await db.photosDao.watchPhotosForEntry('e-1').first;
      expect(list.length, 2);
      final paths = list.map((p) => p.localPath).toSet();
      expect(paths, containsAll(['/tmp/a.jpg', '/tmp/b.jpg']));
    });
  });
}
