import 'dart:io';
import 'dart:ui';

class EditProps {
  EditProps({
    required this.imageFile,
    required this.uniqueTag,
    required this.imageData,
  });

  final File imageFile;
  final String uniqueTag;
  final Image imageData;
}
