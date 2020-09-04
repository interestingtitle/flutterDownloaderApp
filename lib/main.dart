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

import 'fileNames.dart';


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
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: false // optional: set false to disable printing logs to console
  );
  runApp(downloader());


  var status = await Permission.storage.status;

  if (!status.isGranted) {
    await Permission.storage.request();
  }


    //var appPath ='/storage/emulated/0/Android/data/bariscan.flutterdownloader/files';
    //await Directory(appPath).create(recursive: true); // <-- 1


    String directory = (await getApplicationDocumentsDirectory()).path;
    String directoryTest = (await getExternalStorageDirectory()).path;
    // List directory contents, recursing into sub-directories,
    // but not following symbolic links.
    printIps();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    }
    else if (connectivityResult == ConnectivityResult.wifi) {
    // I am connected to a wifi network.
    }
    else {
        // I am not connected to the internet
    }
    var abc=ConnectivityResult.values;
    var abce3="test";
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



class _flutterdownloaderState extends State<flutterdownloader> {

  List<Task> tasks;



  @override
  void requestDownload(String downloadFile) async{
    //
    var rnd = new Random();
    final taskId = await FlutterDownloader.enqueue(
        //url: "https://duckduckgo.com/i/0227507d.png",
        url: "http://192.168.43.199:8000/download/"+downloadFile,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: '/storage/emulated/0/Android/data/bariscan.flutterdownloader/files',
        fileName: downloadFile,
        showNotification: true,
        openFileFromNotification: true);
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
    requestList.clear();
    Future.sync(() => getJSONTest);
    for(int i=0;i<10;i++)
    {
      String plainText=jsonFileData.elementAt(i).toString();
      var plainTextArray=plainText.split("{filename: ");
      //print(jsonFileData.elementAt(i));
      //print(fileData.elementAt(i));
      //print(plainTextArray);
      //print( plainTextArray.elementAt(1));
      plainText=plainTextArray.elementAt(1).toString();
      //print(plainText);
      plainTextArray=plainText.split(".mp3");
      //print("->"+ plainTextArray.elementAt(0));
      String musicFileName=plainTextArray.elementAt(0).toString()+".mp3";
      print("Requested Filename: "+musicFileName);
      requestList.add(musicFileName);
      requestDownload(musicFileName);

    }
    print(requestList);

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
                color: Colors.blue,
                child: Icon(Icons.folder_open),
                onPressed: (){
                  setState(() {
                      _listofFiles();
                    //openFile();;
                      getJSONTest();
                      compareFiles();
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
                      length = (length/1024);
                      print(size);
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

        Expanded(
          child: ListView.builder(
            itemCount: file.length,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  setState(() {
                    fileDirection = file[index].toString().replaceAll("File: ", "").replaceAll("'", "");
                    print(fileDirection);
                    OpenFile.open(fileDirection);
                  });

                },
                child: Container(
                  height: 50,

                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.black26],
                    ),

                  ),
                  child: Center(child: Text(file[index].toString().replaceAll("File: ", "").replaceAll("'", ""), style: TextStyle(fontWeight: FontWeight.bold),)),

                ),
              );
            },
          ),
        )

        
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
