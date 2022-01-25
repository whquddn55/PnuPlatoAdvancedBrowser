import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class M3u8Downloader {
  final String title;
  final String courseTitle;
  final String url;
  final String _baseUrl;
  final List<String> _tsUrlList = List.empty(growable: true);
  Map aesConf = {
    'method': '',
    'uri': '',
    'iv': '',
    'key': '',
  };

  M3u8Downloader({required this.url, required this.title, required this.courseTitle}) : _baseUrl = url.substring(0, url.lastIndexOf('/'));

  Future<void> _getAesConfigure(String m3u8Str) async {
    aesConf['method'] = m3u8Str.substring(m3u8Str.indexOf('METHOD=') + 'METHOD='.length, m3u8Str.indexOf(',', m3u8Str.indexOf('METHOD=')));
    aesConf['uri'] = _baseUrl + '/' + m3u8Str.substring(m3u8Str.indexOf('URI="') + 'URI="'.length, m3u8Str.indexOf('"', m3u8Str.indexOf('"') + 1));

    aesConf['key'] = Uint8List.fromList((await http.get(Uri.parse(aesConf['uri']))).body.codeUnits);
    aesConf['decrypter'] = AESDecrypter();
    aesConf['decrypter'].expandKey(aesConf['key']);
    return;
  }

  Future<bool> download() async {
    var response = await http.get(Uri.parse(url));
    var m3u8Str = response.body;
    m3u8Str.split('\n').forEach((item) {
      if (item.contains('.ts')) {
        _tsUrlList.add(_baseUrl + '/' + item);
      }
    });

    if (m3u8Str.contains('#EXT-X-KEY')) {
      await _getAesConfigure(m3u8Str);
    }

    int index = 0;
    m3u8Str = m3u8Str.split('\n').fold<String>('', (prv, str) {
      if (str.contains('URI=')) {
        var temp = str.split('URI=');
        temp.last = '';
        str = temp.join('URI=') + '"key"';
      }
      if (str.isEmpty || str[0] == '#') {
        return prv + str + '\n';
      } else {
        return prv + '${index++}.ts' + '\n';
      }
    });

    bool result = true;
    if (_tsUrlList.isNotEmpty) {
      Directory('/storage/emulated/0/Download/$courseTitle/$title').createSync(recursive: true);

      var keyFile = File('/storage/emulated/0/Download/$courseTitle/$title/key');
      if (keyFile.existsSync()) {
        keyFile.deleteSync();
      }
      keyFile.writeAsBytesSync(aesConf['key']);
      result &= keyFile.lengthSync() == aesConf['key'].length;

      var indexFile = File('/storage/emulated/0/Download/$courseTitle/$title/index');
      if (indexFile.existsSync()) {
        indexFile.deleteSync();
      }
      indexFile.writeAsStringSync(m3u8Str);
      result &= indexFile.lengthSync() == m3u8Str.length;

      var response = await _downloadTs();
      result &= response;
    }

    return result;
  }

  Future<bool> _downloadTs() async {
    bool res = true;
    for (int i = 0; i < _tsUrlList.length; ++i) {
      final String url = _tsUrlList[i];
      var bytes = Uint8List.fromList((await http.get(Uri.parse(url))).body.codeUnits);
      var tsFile = File('/storage/emulated/0/Download/$courseTitle/$title/$i.ts');
      tsFile.writeAsBytesSync(bytes);
      res &= tsFile.lengthSync() == bytes.length;
    }

    return res;
  }
}

class AESDecrypter {
  final List<int> _rcon = [0x0, 0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36];
  final List<Uint32List> _subMix = [Uint32List(256), Uint32List(256), Uint32List(256), Uint32List(256)];
  final List<Uint32List> _invSubMix = [Uint32List(256), Uint32List(256), Uint32List(256), Uint32List(256)];
  final Uint32List _sBox = Uint32List(256);
  final Uint32List _invSBox = Uint32List(256);
  Uint32List _key = Uint32List(0);
  int _keySize = 0;
  Uint32List _invKeySchedule = Uint32List(0);

  AESDecrypter() {
    var sBox = _sBox;
    var invSBox = _invSBox;
    var subMix = _subMix;
    var subMix0 = subMix[0];
    var subMix1 = subMix[1];
    var subMix2 = subMix[2];
    var subMix3 = subMix[3];
    var invSubMix = _invSubMix;
    var invSubMix0 = invSubMix[0];
    var invSubMix1 = invSubMix[1];
    var invSubMix2 = invSubMix[2];
    var invSubMix3 = invSubMix[3];

    Uint32List d = Uint32List(256);
    for (int i = 0; i < 256; ++i) {
      if (i < 128) {
        d[i] = i << 1;
      } else {
        d[i] = (i << 1) ^ 0x11b;
      }
    }

    int x = 0;
    int xi = 0;
    for (int i = 0; i < 256; ++i) {
      int sx = xi ^ _lshift(xi, 1) ^ _lshift(xi, 2) ^ _lshift(xi, 3) ^ _lshift(xi, 4);
      sx = (sx >>> 8) ^ (sx & 0xff) ^ 0x63;
      sBox[x] = sx;
      invSBox[sx] = x;

      int x2 = d[x];
      int x4 = d[x2];
      int x8 = d[x4];

      int t = (d[sx] * 0x101) ^ (sx * 0x1010100);
      subMix0[x] = _lshift(t, 24) | (t >>> 8);
      subMix1[x] = _lshift(t, 16) | (t >>> 16);
      subMix2[x] = _lshift(t, 8) | (t >>> 24);
      subMix3[x] = t;

      t = (x8 * 0x1010101) ^ (x4 * 0x10001) ^ (x2 * 0x101) ^ (x * 0x1010100);
      invSubMix0[sx] = _lshift(t, 24) | (t >>> 8);
      invSubMix1[sx] = _lshift(t, 16) | (t >>> 16);
      invSubMix2[sx] = _lshift(t, 8) | (t >>> 24);
      invSubMix3[sx] = t;

      if (x == 0) {
        x = xi = 1;
      } else {
        x = x2 ^ d[d[d[x8 ^ x2]]];
        xi ^= d[d[xi]];
      }
    }
  }

  void expandKey(Uint8List keybuff) {
    var key = _uint8ListToUint32List(keybuff);
    var sameKey = true;
    var offset = 0;

    if (key.length == _key.length) {
      while (offset < key.length && sameKey) {
        sameKey = (key[offset] == _key[offset]);
        offset++;
      }
      if (sameKey) return;
    }

    _key = key;
    var keySize = _keySize = (key.length);
    var ksRows = (key.length + 7) * 4;
    var keySchedule = Uint32List(ksRows);
    var invKeySchedule = _invKeySchedule = Uint32List(ksRows);
    var sbox = _sBox;
    var rcon = _rcon;
    var invSubMix = _invSubMix;
    var invSubMix0 = invSubMix[0];
    var invSubMix1 = invSubMix[1];
    var invSubMix2 = invSubMix[2];
    var invSubMix3 = invSubMix[3];

    int prev = 0, t = 0;
    for (int ksRow = 0; ksRow < ksRows; ++ksRow) {
      if (ksRow < keySize) {
        prev = keySchedule[ksRow] = key[ksRow];
        continue;
      }
      t = prev;
      if (ksRow % keySize == 0) {
        t = _lshift(t, 8) | (t >>> 24);

        t = _lshift(sbox[t >>> 24], 24) | _lshift(sbox[(t >>> 16) & 0xff], 16) | _lshift(sbox[(t >>> 8) & 0xff], 8) | sbox[t & 0xff];
        t ^= _lshift(rcon[(ksRow ~/ keySize) | 0], 24);
      } else if ((keySize > 6) && (ksRow % keySize == 4)) {
        t = _lshift(sbox[t >>> 24], 24) | _lshift(sbox[(t >>> 16) & 0xff], 16) | _lshift(sbox[(t >>> 8) & 0xff], 8) | sbox[t & 0xff];
      }

      keySchedule[ksRow] = prev = (keySchedule[ksRow - keySize] ^ t) >>> 0;
    }

    for (int invKsRow = 0; invKsRow < ksRows; invKsRow++) {
      int ksRow = ksRows - invKsRow;
      if ((invKsRow & 3) != 0) {
        t = keySchedule[ksRow];
      } else {
        t = keySchedule[ksRow - 4];
      }

      if (invKsRow < 4 || ksRow <= 4) {
        invKeySchedule[invKsRow] = t;
      } else {
        invKeySchedule[invKsRow] =
            invSubMix0[sbox[t >>> 24]] ^ invSubMix1[sbox[(t >>> 16) & 0xff]] ^ invSubMix2[sbox[(t >>> 8) & 0xff]] ^ invSubMix3[sbox[t & 0xff]];
      }

      invKeySchedule[invKsRow] = invKeySchedule[invKsRow] >>> 0;
    }
  }

  Uint8List decrypt(Uint8List inputArrayBuffer, Uint8List aesIv) {
    int nRounds = _keySize + 6;
    var invKeySchedule = _invKeySchedule;
    var invSBox = _invSBox;

    var invSubMix = _invSubMix;
    var invSubMix0 = invSubMix[0];
    var invSubMix1 = invSubMix[1];
    var invSubMix2 = invSubMix[2];
    var invSubMix3 = invSubMix[3];

    var initVector = _uint8ListToUint32List(aesIv);
    var initVector0 = initVector[0];
    var initVector1 = initVector[1];
    var initVector2 = initVector[2];
    var initVector3 = initVector[3];

    var inputInt32 = inputArrayBuffer.buffer.asInt32List();
    var outputInt32 = Int32List(inputInt32.length);

    int offset = 0;
    while (offset < inputInt32.length) {
      int inputWords0 = _swapWord(inputInt32[offset]);
      int inputWords1 = _swapWord(inputInt32[offset + 1]);
      int inputWords2 = _swapWord(inputInt32[offset + 2]);
      int inputWords3 = _swapWord(inputInt32[offset + 3]);

      int s0 = (inputWords0 ^ invKeySchedule[0]);
      int s1 = (inputWords3 ^ invKeySchedule[1]);
      int s2 = (inputWords2 ^ invKeySchedule[2]);
      int s3 = (inputWords1 ^ invKeySchedule[3]);

      int ksRow = 4;
      int t0, t1, t2, t3;
      for (int i = 1; i < nRounds; ++i) {
        t0 = invSubMix0[(s0 >>> 24) & 0xff] ^
            invSubMix1[(s1 >> 16) & 0xff] ^
            invSubMix2[(s2 >> 8) & 0xff] ^
            invSubMix3[s3 & 0xff] ^
            invKeySchedule[ksRow];
        t1 = invSubMix0[(s1 >>> 24) & 0xff] ^
            invSubMix1[(s2 >> 16) & 0xff] ^
            invSubMix2[(s3 >> 8) & 0xff] ^
            invSubMix3[s0 & 0xff] ^
            invKeySchedule[ksRow + 1];
        t2 = invSubMix0[(s2 >>> 24) & 0xff] ^
            invSubMix1[(s3 >> 16) & 0xff] ^
            invSubMix2[(s0 >> 8) & 0xff] ^
            invSubMix3[s1 & 0xff] ^
            invKeySchedule[ksRow + 2];
        t3 = invSubMix0[(s3 >>> 24) & 0xff] ^
            invSubMix1[(s0 >> 16) & 0xff] ^
            invSubMix2[(s1 >> 8) & 0xff] ^
            invSubMix3[s2 & 0xff] ^
            invKeySchedule[ksRow + 3];

        s0 = t0;
        s1 = t1;
        s2 = t2;
        s3 = t3;

        ksRow = ksRow + 4;
      }

      t0 = (_lshift(invSBox[(s0 >>> 24) & 0xff], 24) ^
              _lshift(invSBox[(s1 >> 16) & 0xff], 16) ^
              _lshift(invSBox[(s2 >> 8) & 0xff], 8) ^
              invSBox[s3 & 0xff]) ^
          invKeySchedule[ksRow];
      t1 = (_lshift(invSBox[(s1 >>> 24) & 0xff], 24) ^
              _lshift(invSBox[(s2 >> 16) & 0xff], 16) ^
              _lshift(invSBox[(s3 >> 8) & 0xff], 8) ^
              invSBox[s0 & 0xff]) ^
          invKeySchedule[ksRow + 1];
      t2 = (_lshift(invSBox[(s2 >>> 24) & 0xff], 24) ^
              _lshift(invSBox[(s3 >> 16) & 0xff], 16) ^
              _lshift(invSBox[(s0 >> 8) & 0xff], 8) ^
              invSBox[s1 & 0xff]) ^
          invKeySchedule[ksRow + 2];
      t3 = (_lshift(invSBox[(s3 >>> 24) & 0xff], 24) ^
              _lshift(invSBox[(s0 >> 16) & 0xff], 16) ^
              _lshift(invSBox[(s1 >> 8) & 0xff], 8) ^
              invSBox[s2 & 0xff]) ^
          invKeySchedule[ksRow + 3];
      ksRow = ksRow + 3;

      outputInt32[offset] = _swapWord(t0 ^ initVector0);
      outputInt32[offset + 1] = _swapWord(t3 ^ initVector1);
      outputInt32[offset + 2] = _swapWord(t2 ^ initVector2);
      outputInt32[offset + 3] = _swapWord(t1 ^ initVector3);

      initVector0 = inputWords0;
      initVector1 = inputWords1;
      initVector2 = inputWords2;
      initVector3 = inputWords3;

      offset = offset + 4;
    }
    return outputInt32.sublist(0, outputInt32.length - 8).buffer.asUint8List();
  }

  int _lshift(int v, int l) {
    return (v << l) & 0xFFFFFFFF;
  }

  int _swapWord(int word) {
    return _lshift(word, 24) | ((word & 0xff00) << 8) | ((word & 0xff0000) >> 8) | ((word >>> 24) & 0xff);
  }

  Uint32List _uint8ListToUint32List(Uint8List list) {
    var newList = Uint32List(list.length ~/ 4);
    for (int i = 0; i < list.length ~/ 4; ++i) {
      newList[i] = (list[i * 4].toInt() << 24) + (list[i * 4 + 1].toInt() << 16) + (list[i * 4 + 2].toInt() << 8) + list[i * 4 + 3].toInt();
    }
    return newList;
  }
}
