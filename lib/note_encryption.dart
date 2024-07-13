import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> writeKey(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> readKey(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> deleteKey(String key) async {
    await _storage.delete(key: key);
  }
}
class EncryptionService {
  static Future<String> encryptData(String data) async {
    final encryptionKey = await SecureStorage.readKey('encryptionKey');

    if (encryptionKey == null) {
      final key = encrypt.Key.fromSecureRandom(32);
      await SecureStorage.writeKey('encryptionKey', base64.encode(key.bytes));
      return _encrypt(data, key);
    } else {
      final key = encrypt.Key(base64.decode(encryptionKey));
      return _encrypt(data, key);
    }
  }

  static String _encrypt(String data, encrypt.Key key) {
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return '${base64.encode(iv.bytes)}:${base64.encode(encrypted.bytes)}';
  }

  static Future<String> decryptData(String encryptedData) async {
    final encryptionKey = await SecureStorage.readKey('encryptionKey');
    if (encryptionKey == null) {
      throw Exception('Şifreleme anahtarı bulunamadı!');
    }

    final key = encrypt.Key(base64.decode(encryptionKey));
    final parts = encryptedData.split(':');
    final iv = encrypt.IV(base64.decode(parts[0]));
    final encrypted = encrypt.Encrypted(base64.decode(parts[1]));
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}