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

void discoverIpAddress(String ipTemplate) async {
  // NetworkAnalyzer.discover pings PORT:IP one by one according to timeout.
  // NetworkAnalyzer.discover2 pings all PORT:IP addresses at once.

  const port = 8000;
  final stream = await NetworkAnalyzer.discover2(
    ipTemplate,
    port,
    timeout: Duration(milliseconds: 5000),
  );

  int found = 0;
  await stream.listen((NetworkAddress addr) {
    //print('${addr.ip}:$port');
    if (addr.exists) {
      found++;
      print('Found Server IP: ${addr.ip}:$port');
      serverIP=addr.ip.toString();
      serverPORT=port.toString();
      return;
    }
  });
}

void getIpAddress() async
{
  final String ip = await Wifi.ip;
  final String subnet = ip.substring(0, ip.lastIndexOf('.'));
  final int port = 8000;

  final stream = await NetworkAnalyzer.discover2(subnet, port);
  stream.listen((NetworkAddress addr) {
    if (addr.exists) {
      print("Connected by: "+ip);
      var _IPSplitList=ip.split(".");
      //print(_list);
      String setIPAdd=_IPSplitList[0]+'.'+_IPSplitList[1]+'.'+_IPSplitList[2];
      print("Created template: "+setIPAdd);
      discoverIpAddress(setIPAdd);
    }
  });
}
Future printIps() async {
  for (var interface in await NetworkInterface.list()) {
    print('== Interface: ${interface.name} ==');
    for (var addr in interface.addresses) {
      print(
          '${addr.address} ${addr.host} ${addr.isLoopback} ${addr
              .rawAddress} ${addr.type.name}');
    }
  }
}



void main() async{
  //#region FlutterDownloader plugin initialize
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: false // optional: set false to disable printing logs to console
  );
  //#endregion
  runApp(downloader());
  //#region Asking storage permission
  var status = await Permission.storage.status;

  if (!status.isGranted) {
    await Permission.storage.request();
  }
  //#endregion

  appDirectory = (await getApplicationDocumentsDirectory()).path;
  printIps();
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network.
    //getJSONTest();

  }
  else if (connectivityResult == ConnectivityResult.wifi) {
    // I am connected to a wifi network.
    //getJSONTest();
    //discoverIpAddress();
    getIpAddress();
    var conn = await http.get(Uri.parse("http://"+serverIP+":"+serverPORT+"/est_conn"));
  }
  else {
    // I am not connected to the internet
  }
  var abc=ConnectivityResult.values;
}

class downloader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: flutterdownloader(),
    );
  }
}

class flutterdownloader extends StatefulWidget {
  @override

  _flutterdownloaderState createState() => _flutterdownloaderState();
}

String test;

class _flutterdownloaderState extends State<flutterdownloader> {

  List<Task> tasks;

  @override
  void requestDownload(String downloadFile) {



    final taskId =  FlutterDownloader.enqueue(
      //url: "https://duckduckgo.com/i/0227507d.png",
        url: "http://"+serverIP+":"+serverPORT+"/download/"+downloadFile,
        //url: "http://192.168.43.195:8000"+"/download/"+downloadFile,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: '/storage/emulated/0/Android/data/bariscan.flutterdownloader/files',
        fileName: downloadFile,
        showNotification: true,
        openFileFromNotification: true);

    //this function is needed for using flutter downloader plugin


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listofFiles();
  }

  void _listofFiles() async {
    directory = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      file = io.Directory("/storage/emulated/0/Android/data/bariscan.flutterdownloader/files").listSync();  //use your folder name instead of resume.
    });
  }

  void compareFiles()
  {
    //jsonFileData.clear();
    //requestList.clear();
    getJSONTest();
    jsonFileData.forEach((text) {
      //print(text['filename']);
      print("Requested Filename: "+text['filename']);
      requestList.add(text['filename']);
      requestDownload(text['filename']);
    });

    print(requestList);

  }

  Future<void> executeOrder() async{
    await _listofFiles();
    await getIpAddress();
    await getJSONTest();
    await compareFiles();
    await _listofFiles();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutterdownloader'),
      ),
      body: Column(
        children: <Widget>[

          Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
            children: [
              Tooltip(
                message: 'Download',
                child: FlatButton(

                  color: Colors.blue,
                  child: Icon(Icons.file_download),
                  onPressed: (){
                    setState(() {
                      files.clear();
                      requestDownload("1.mp3");
                      _listofFiles();

                    });

                  },
                ),
              ),
              Tooltip(
                message: 'Sync Files',
                child: FlatButton(
                  autofocus: true,
                  color: Colors.blue,
                  child: Icon(Icons.folder_open),
                  onPressed: (){
                    setState(() {
                      executeOrder();
                    });
                  },
                ),
              ),
              Tooltip(
                message: 'List all files',

                child: GestureDetector(

                  child: FlatButton(
                    color: Colors.blue,
                    child: Icon(Icons.book),
                    onPressed: () {

                      setState(() {
                        _listofFiles();
                      });

                    },

                  ),
                ),

              ),
            ],
          ),

          Divider(),

//        GestureDetector(
//          onTap: () {
//            OpenFile.open("/storage/emulated/0/Android/data/bariscan.flutterdownloader/files/god.jpg");
//
//          },
//          child: Text(
//
//            name,
//            textAlign: TextAlign.center,
//            style: TextStyle(
//              fontFamily: 'Roboto',
//              color: Colors.grey[800],
//              fontWeight: FontWeight.bold,
//            ),
//          ),
//        ),
//#region ListView builder
          Expanded(
            child: ListView.builder(
              itemCount: file.length,
              itemBuilder: (context,index){
                files.add(file[index].toString().replaceAll("File: ", "").replaceAll("'", ""));
                filo = new File(files[index]);
                length = filo.lengthSync().toDouble();
                length = (length / 1024)/1024;

                IconData returnedIconName = getIcon(files[index],index);
                print(files[index]);
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      fileDirection = file[index].toString().replaceAll("File: ", "").replaceAll("'", "");
                      print(fileDirection);
                      OpenFile.open(fileDirection);
                    });

                  },
                  child: Container(
                    height: 60,

                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.vertical(),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.lightBlueAccent],
                      ),

                    ),
                    child: Center(child:
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                          TextSpan(text: file[index].toString().replaceAll("File: ", "").replaceAll("'", "").replaceAll("/storage/emulated/0/Android/data/bariscan.flutterdownloader/files/", "") + "   " + length.toStringAsFixed(2) + " MB   "),
                          WidgetSpan(

                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(returnedIconName),
                            ),
                          ),

                        ],
                      ),
                    )

                    ),

                  ),
                );
              },
            ),
          )
//#endregion

        ],
      ),
    );
  }
}


class Task {
  String name;
  String link;

  String taskId;
  int progress = 0;


  Task(String name, String link, String taskId){
    this.name = name;
    this.link = link;
    this.taskId = taskId;
  }
}
