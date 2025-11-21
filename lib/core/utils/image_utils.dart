import 'dart:convert';
import 'dart:typed_data';

Uint8List? decodeBase64Image(String base64String) {
  try {
    final cleanBase64 = base64String.split(',').last;
    return base64Decode(cleanBase64);
  } catch (e) {
    print('Error decodificando Base64: $e');
    return null;
  }
}