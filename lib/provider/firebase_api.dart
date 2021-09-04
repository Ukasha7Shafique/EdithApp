import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/firebase_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseApi with ChangeNotifier {
//Upload Files section
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (_) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (_) {
      return null;
    }
  }

  // Download files sections
  static Future<List<String>> getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll() async {
    final user = FirebaseAuth.instance.currentUser;
    String path1 = user!.email.toString();
    String path = 'files/$path1/';
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future downloadFile(Reference ref) async {
    final String url = await ref.getDownloadURL();
    // final http.Response downloadData = await http.get(Uri.parse(url));
    final Directory? systemTempDir = await getExternalStorageDirectory();
    print(systemTempDir.toString());
    final File tempFile = File('${systemTempDir!.path}/tmp.jpg');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final task = ref.writeToFile(tempFile);
    final String name = ref.name;
    final String path = ref.fullPath;
    print(
      'Success!\nDownloaded $name \nUrl: $url'
      '\npath: $path',
    );
  }

  static Future deleteFile(FirebaseFile ref) async {
    final str = FirebaseStorage.instance.refFromURL(ref.url);
    // String str = ref.url;
    print(str);

    await str.delete();
    print('Deleted');
  }
}
