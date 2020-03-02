import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class FileCypher {
  static var cryptor = null;
  static decryptMessage({String key, String encryptedMesaage}) async {
    try {
      if (cryptor == null) {
        cryptor = new PlatformStringCryptor();
        return await cryptor.decrypt(encryptedMesaage, key);
      } else {
        return await cryptor.decrypt(encryptedMesaage, key);
      }
    } catch (e) {
      return e;
    }
  }

  static encryptMessage({String key, String mesaage}) async {
    try {
      if (cryptor == null) {
        cryptor = new PlatformStringCryptor();
        return await cryptor.encrypt(mesaage, key);
      } else {
        return await cryptor.encrypt(mesaage, key);
      }
    } catch (e) {
      return e;
    }
  }

  static getRandomKey() async {
    try {
      if (cryptor == null) {
        cryptor = new PlatformStringCryptor();
        return await cryptor.generateRandomKey();
      } else {
        return await cryptor.generateRandomKey();
      }
    } catch (e) {
      return e;
    }
  }
}
