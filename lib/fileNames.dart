import 'dart:io' as io;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var fileLocs= new List<String>();
var fileSizes= new List<String>();
var files= new List<String>();
int Counter = -1;
String name = "";

var filo;
double length;

String fileDirection = "";
String directory;
List file = new List();

String size = length.toString();
List <String> fileData=new List<String>();
List jsonFileData=new List();
List<String> requestList= new List<String>();

Future getJSONTest() async
{
  var res = await http.get(Uri.parse("http://192.168.43.199:8000/get_value"), headers: {"Accept": "application/json"});
  var resBody = json.decode(res.body);
  jsonFileData=resBody["filedata"] as List;

  print("done");

}
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

