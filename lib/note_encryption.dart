import 'package:easy_localization/easy_localization.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();
  static final _supabase = Supabase.instance.client;

  static Future<void> writeKey(String userId, String key, String value) async {
    await _storage.write(key: "${userId}_$key", value: value);
    await _supabase.from('encryption_keys').upsert({
      'user_id': userId,
      'key': key,
      'value': value,
    });
  }

  static Future<String?> readKey(String userId, String key) async {
    String? value = await _storage.read(key: "${userId}_$key");
    if (value == null) {
      final response = await _supabase
          .from('encryption_keys')
          .select('value')
          .eq('user_id', userId)
          .eq('key', key)
          .maybeSingle();
      if (response != null) {
        value = response['value'];
        await _storage.write(key: "${userId}_$key", value: value);
      }
    }
    return value;
  }

  static Future<void> deleteKey(String userId, String key) async {
    await _storage.delete(key: "${userId}_$key");
    // Veritabanından da sil
    await _supabase
        .from('encryption_keys')
        .delete()
        .eq('user_id', userId)
        .eq('key', key);
  }
}

class EncryptionService {
  static Future<String> encryptData(String userId, String data) async {
    String? encryptionKey = await SecureStorage.readKey(userId, 'encryptionKey');

    if (encryptionKey == null) {
      final key = encrypt.Key.fromSecureRandom(32);
      encryptionKey = base64.encode(key.bytes);
      await SecureStorage.writeKey(userId, 'encryptionKey', encryptionKey);
    }

    final key = encrypt.Key(base64.decode(encryptionKey));
    return _encrypt(data, key);
  }

  static String _encrypt(String data, encrypt.Key key) {
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return '${base64.encode(iv.bytes)}:${base64.encode(encrypted.bytes)}';
  }

  static Future<String> decryptData(String userId, String encryptedData) async {
    final encryptionKey = await SecureStorage.readKey(userId, 'encryptionKey');
    if (encryptionKey == null) {
      throw Exception('encryptionService.encryptionKeyNotFound'.tr());
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