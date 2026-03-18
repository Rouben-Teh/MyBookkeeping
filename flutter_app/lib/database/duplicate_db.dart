import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<File> copyDatabase() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(join(dbFolder.path, 'bookkeeping.sqlite'));

  if (!await file.exists()) {
    print('no sqlite file');
    final data = await rootBundle.load('assets/bookkeeping.sqlite');
    final bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes);
  } else {
    print('yes sqlite file');
  }

  return file;
}
