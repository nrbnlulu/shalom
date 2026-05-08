// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_import, unnecessary_this, unnecessary_non_null_assertion, depend_on_referenced_packages, camel_case_types

// ------------ Enum DEFINITIONS -------------

enum AlbumEventKind {
  ALBUM_CREATED,

  GIF_ADDED_TO_ALBUM,

  GIF_REMOVED_FROM_ALBUM;

  static AlbumEventKind fromString(String name) {
    switch (name) {
      case 'ALBUM_CREATED':
        return AlbumEventKind.ALBUM_CREATED;
      case 'GIF_ADDED_TO_ALBUM':
        return AlbumEventKind.GIF_ADDED_TO_ALBUM;
      case 'GIF_REMOVED_FROM_ALBUM':
        return AlbumEventKind.GIF_REMOVED_FROM_ALBUM;
      default:
        throw ArgumentError.value(
          name,
          'name',
          'No enum member with this name',
        );
    }
  }
}

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------

// ------------ END Input DEFINITIONS -------------
