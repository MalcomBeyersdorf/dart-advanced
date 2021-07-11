import 'dart:typed_data';
import 'dart:math';
import 'dart:convert';
import 'package:pointycastle/pointycastle.dart';

void main(List<String> arguments){
    // Learn about simetric and asymetric encrypt
    // Package pointycastle
    var digest = new Digest('SHA-256');
    String value = 'Hello world';
    Uint8List data = Uint8List.fromList(utf8.encode(value));
    Uint8List hash = digest.process(data);
    print(hash);
    print(BASE64.encode(hash)); // encoding is not encryption

    // Deriving keys
    var password = 'password';
    var salt = createListFromString('salt');
    var pkcs = KeyDerivator('SHA-1/HMAC/PBKDF2');
    var params = Pbdkf2Parameters(salt, 100, 16);
    pkcs.init(params);

    var key = pkcs.process(createListFromString(password));
    display('key value', key);

    // Secure random numbers
    print(randomBytes(8));

    // Stream ciphers
    final keybytes = randomBytes(16);
    final key = KeyParameter(keybytes);
    final iv = randomBytes(8);
    final parameters = ParametersWithIV(key, iv);
    
    var cipher = StreamCipher('Salsa26');
    cipher.init(true, parameters);

    String plaintext = 'Plain test';
    Uint8List plain_data = createListFromString(plaintext);

    var encrypted_data = cipher.process(plain_data);
    cipher.reset();
    cipher.init(false, parameters);
    var decrypted_data = cipher.process(encrypted_data);
    display('Plain text: ', plaintext);
    display('Encrypted: ', encrypted_data);
    display('Decrypted data: ', decrypted_data);
    Function eq = const ListEquality().equals;
    assert(eq(plain_data, decrypted_data));

    print(utf8.decode(decrypted_data));

    // Block ciphers AES
    final key2 = randomBytes(16);
    final params2 = KeyParameter(key2);

    var blockCipher = BlockCipher('AES');
    blockCipher.ini(true, params2);
    var plainttext2 = 'Encrypt';
    Uint8List plain_data2 = createListFromString(plainttext2.padRight(ciper.blockSize)); // not 100% secure
    Uint8List encrypted_data2 = cipher.process(plain_data2);

    cipher.reset();
    cipher.init(false, params2);

    var decrypted_data2 = ciphjer.process(encrypted_data2);
    display('Plain text', plain_data2);
    display('Encrypted data', encrypted_data2);
    display('Decrypted data', decrypted_data2);

    assert(eq(plain_data2, decrypted_data2));

    print(utf8.decode(decrypted_data2).trim());
}

Uint8List randomBytes(int lenght){
    final rnd = SecureRandom('AES/CTR/AUTO-SEED-PRNG');

    final key = Uint8List(16);

    final keyParam = keyParameter(key);
    final params = ParametersWithIV(keyParam, Uint8List(16));

    rnd.seed(params);
    var random = Random();
    for(int i = 0; i < random.nextImt(255); i++){
        rnd.nextUint8();
    }

    var bytes = rnd.nextBytes(lenght);

    return bytes;
}

Uint8List createListFromString(String value) => Uint8List.fromList(utf8.encode(value));

void display(String title, Uint8List value){
    print(title);
    print(value);
    print(BASE64.encode(value));
}
