// ignore_for_file: constant_identifier_names

// ------------ Enum DEFINITIONS -------------

/// Represents the various states of a process or operation.
/// foo bar
enum Status {
  /// The process has been successfully completed.
  COMPLETED,

  /// The process has failed to complete successfully.
  FAILED,

  /// The process is awaiting action or has not started yet.
  /// baz
  PENDING,

  /// The process is currently in progress.
  /// bezus
  PROCESSING;

  static Status fromString(String name) {
    switch (name) {
      case 'COMPLETED':
        return Status.COMPLETED;
      case 'FAILED':
        return Status.FAILED;
      case 'PENDING':
        return Status.PENDING;
      case 'PROCESSING':
        return Status.PROCESSING;
      default:
        throw ArgumentError.value(
          name,
          'name',
          'No Status enum member with this name',
        );
    }
  }
}

// ------------ END Enum DEFINITIONS -------------
// ------------ Input DEFINITIONS -------------

// ------------ END Input DEFINITIONS -------------
