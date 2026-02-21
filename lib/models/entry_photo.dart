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
}
