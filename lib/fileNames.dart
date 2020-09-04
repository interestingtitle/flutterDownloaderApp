import 'dart:io' as io;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

var files= new List<String>();
int Counter = -1;
String name = "";

String fileDirection = "";
String directory;
List file = new List();
var filo = new File("storage/emulated/0/Android/data/bariscan.flutterdownloader/files/156561.png");
double length = filo.lengthSync().toDouble();
String size = length.toString();

//var systemTempDir = Directory("/storage/emulated/0/Android/data/bariscan.flutterdownloader/files/");



//void getFileNamesInAppDirectory() {
//  files.clear();
//  systemTempDir.list(recursive: true, followLinks: false)
//      .listen((FileSystemEntity entity) {
//    String entityPath = entity.path;
//    entityPath =
//        entityPath.replaceAll("/storage/emulated/0/Android/data/bariscan.flutterdownloader/files/", "");
//
//    files.add(entityPath);
//   print(entityPath + " " + files[Counter]);
//
//  });
//
//}

