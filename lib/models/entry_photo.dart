import 'sentinel.dart';

class EntryPhoto {
  const EntryPhoto({
    required this.id,
    required this.entryId,
    required this.localPath,
    required this.createdAt,
    this.deletedAt,
  });

  final String id;
  final String entryId;
  final String localPath;
  final DateTime createdAt;
  final DateTime? deletedAt;

  EntryPhoto copyWith({
    String? id,
    String? entryId,
    String? localPath,
    DateTime? createdAt,
    Object? deletedAt = kSentinel,
  }) {
    return EntryPhoto(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      localPath: localPath ?? this.localPath,
      createdAt: createdAt ?? this.createdAt,
      deletedAt:
          deletedAt == kSentinel ? this.deletedAt : deletedAt as DateTime?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is EntryPhoto && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'EntryPhoto(id: $id, entryId: $entryId)';
}
