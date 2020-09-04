import 'dart:io' as io;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var files= new List<String>();
String serverIP="";
String serverPORT="";
int Counter = -1;
String name = "";
String appDirectory="";
String fileDirection = "";
String directory;
List file = new List();
var filo = new File("storage/emulated/0/Android/data/bariscan.flutterdownloader/files/156561.png");
double length = filo.lengthSync().toDouble();
String size = length.toString();
List <String> fileData=new List<String>();
List jsonFileData=new List();
List<String> requestList= new List<String>();

Future getJSONTest() async
{
  var res = await http.get(Uri.parse("http://192.168.43.199:8000/get_value"), headers: {"Accept": "application/json"});
  var resBody = json.decode(res.body);
  jsonFileData=resBody["filedata"] as List;
  print("Getting file list data from server : Done.");

}

