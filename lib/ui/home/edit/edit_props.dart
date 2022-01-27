import 'dart:io';

class EditProps {
  EditProps({
    required this.imageFile,
    required this.uniqueTag,
  });

  final File imageFile;
  final String uniqueTag;
}
