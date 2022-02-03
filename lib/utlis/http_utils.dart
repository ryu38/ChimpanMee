import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

Future<Uint8List> getNetworkImage(Uri url) async {
  try {
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw NetworkImageException('Failed to access URL: Status Code ${response.statusCode}');
    }
    final contentType = response.headers['content-type'];
    if (contentType == null) throw NetworkImageException('not image');
    final mainType = contentType.split('/').first;
    if (mainType == 'image') {
      return response.bodyBytes;
    }
    throw NetworkImageException('Entered URL is not Image Link');
  } on NetworkImageException {
    rethrow;
  } on SocketException {
    throw NetworkImageException('Failed to access URL');
  } on Exception {
    throw NetworkImageException('Error occurred while accessing URL');
  }
}

class NetworkImageException implements Exception {
  NetworkImageException(this.message);

  final String message;
}
