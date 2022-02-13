import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

Future<Uint8List> getNetworkImage(Uri url) async {
  try {
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw NetworkImageException(
        NetworkImageExceptionType.badStatus,
        message: 'Failed to access URL: Status Code ${response.statusCode}',
        resStatus: response.statusCode,
      );
    }
    final contentType = response.headers['content-type'];
    if (contentType == null) {
      throw NetworkImageException(NetworkImageExceptionType.notImage);
    }
    final mainType = contentType.split('/').first;
    if (mainType == 'image') {
      return response.bodyBytes;
    }
    throw NetworkImageException(NetworkImageExceptionType.notImage);
  } on NetworkImageException {
    rethrow;
  } on SocketException catch (e) {
    throw NetworkImageException(
      NetworkImageExceptionType.socket,
      message: e.message,
    );
  } on Exception {
    throw NetworkImageException(NetworkImageExceptionType.other);
  }
}

class NetworkImageException implements Exception {
  NetworkImageException(this.errorType, {this.message, this.resStatus});

  final NetworkImageExceptionType errorType;
  final String? message;
  final int? resStatus;
}

enum NetworkImageExceptionType { badStatus, notImage, socket, other }
