class PermissionDeniedException implements Exception {
  PermissionDeniedException([this.message]);
  final String? message;
}
