import 'dart:convert';
import 'package:crypto/crypto.dart';

class CryptoUtil {
  static String generateHashCode(String code) {
    var bytes = utf8.encode(code); // Convert the code to bytes
    var digest = sha256.convert(bytes); // Perform SHA-256 hashing
    return digest.toString(); // Convert the digest to a string
  }
}
