import 'dart:io' as io;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'fileNames.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'fileNames.dart';
import 'package:wifi/wifi.dart';
import 'package:splashscreen/splashscreen.dart';

var fileLocs = new List<String>();
var files= new List<String>();
String serverIP="192.168.2.128";
String serverPORT="8000";
int Counter = -1;
String name;
String appDirectory;
String fileDirection ;
String directory;
String setIPAdd;
String tempIP;
List file = new List();
var filo = new File("storage/emulated/0/Android/data/bariscan.flutterdownloader/files/156561.png");
double length = filo.lengthSync().toDouble();
String size = length.toString();
List <String> fileData=new List<String>();
List serverFileData=new List();
List appFileData=new List();
List<String> requestList= new List<String>();
List filesToShow=new List();
String iconName;

void fileSync() {
  appFileData = io.Directory("/storage/emulated/0/Android/data/bariscan.flutterdownloader/files").listSync();
  serverFileData=serverFileData;
  //print(appFileData);
  //print(serverFileData);
  filesToShow.clear();
  filesToShow.addAll(serverFileData);
  filesToShow.addAll(appFileData);
  //print(filesToShow);

}
Future <void> getServerFileJSONData() async
{
  if(serverIP!=null ) {
    try {
      var conn = await http.get(
          Uri.parse("http://" + serverIP + ":" + serverPORT + "/est_conn"));
      var res = await http.get(
          Uri.parse("http://" + serverIP + ":" + serverPORT + "/get_value"),
          headers: {"Accept": "application/json"});
      var resBody = json.decode(res.body);
      serverFileData = resBody["filedata"] as List;
      print("Getting file list data from server : Done.");
      print("Server Folder File Count:"+serverFileData.length.toString());
    }
    catch(e){
         print("Error: Cannot connect to server.");
         await establishConnection();
    }
  }

}
Future <void> discoverIpAddress() async {
    print('Checking for server');
    int port= int.parse(serverPORT);
    var stream2 =  NetworkAnalyzer.discover2(
      setIPAdd,
      port,
      timeout: Duration(milliseconds: 5000),
    );

    int found = 0;
    stream2.listen((NetworkAddress addr) {
      print('${addr.ip}:$port');
      if (addr.exists) {
        found++;
        print('Found Server IP: ${addr.ip}:$port');
        serverIP=addr.ip.toString();
        serverPORT=port.toString();
        return;
      }
    });
}

Future <void> createTemplateForIP() async{
  final String ip =tempIP;
  final String subnet = ip.substring(0, ip.lastIndexOf('.'));
  final int port = 8000;
  final stream = NetworkAnalyzer.discover2(subnet, port);
   stream.listen((NetworkAddress addr) {
    if (addr.exists) {
      print("Connected by: "+ip);
      var _IPSplitList=ip.split(".");
      print(_IPSplitList);
      setIPAdd=_IPSplitList[0]+'.'+_IPSplitList[1]+'.'+_IPSplitList[2];
      print("Created template: "+setIPAdd);
      discoverIpAddress();
    }

  });

}
Future <void> establishConnection() async {
  serverPORT="8000";
  print("Trying to connect server.");
  for (var interface in await NetworkInterface.list()) {
    print('== Interface: ${interface.name} ==');
    for (var addr in interface.addresses) {
      tempIP=addr.address;
      print(
          '${addr.address} ${addr.host} ${addr.isLoopback} ${addr
              .rawAddress} ${addr.type.name}');
      createTemplateForIP();
      return;
    }

  }
}


IconData getIcon(String x, int y){
  //this function returns us an icon related with the file's type
  x = files[y].substring(files[y].length - 4);
  if(x == ".png"){

    IconData iconName = Icons.image;
    return iconName;
  }
  if(x == ".mp3"){

    IconData iconName = Icons.music_note;
    return iconName;
  }
  if(x == ".mp4"){

    IconData iconName = Icons.video_library;
    return iconName;
  }
  if(x == ".jpeg"){

    IconData iconName = Icons.image;
    return iconName;
  }
  if(x == ".zip"){

    IconData iconName = Icons.archive;
    return iconName;
  }
  if(x == ".jpg"){

    IconData iconName = Icons.image;
    return iconName;
  }
}