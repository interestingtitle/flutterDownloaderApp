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





void main() async{

  //#region FlutterDownloader plugin initialize
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: false // optional: set false to disable printing logs to console
  );
  //#endregion
  runApp(downloader());
  establishConnection();
  //#region Asking storage permission
  var status = await Permission.storage.status;

  if (!status.isGranted) {
    await Permission.storage.request();
  }
  //#endregion

  appDirectory = (await getApplicationDocumentsDirectory()).path;

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network.
    //getJSONTest();

  }
  else if (connectivityResult == ConnectivityResult.wifi) {
    // I am connected to a wifi network.
    establishConnection();
  }
  else {
    // I am not connected to the internet
  }
  //await getServerFileJSONData();
  fileSync();

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
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 10,
        navigateAfterSeconds: new AfterSplash(),
        title: new Text('Welcome In SplashScreen',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),),
        image: new Image.network('https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: ()=>print("Flutter Egypt"),
        loaderColor: Colors.red
    );
  }
}

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash> {

  bool _tryAgain = false;

  _checkWifi() async {
    discoverIpAddress();
    // the method below returns a Future
    var connectivityResult = await (new Connectivity().checkConnectivity());
    bool connectedToWifi = (connectivityResult == ConnectivityResult.wifi);
    if (!connectedToWifi) {
      _showAlert(context);
    }
    if (_tryAgain != !connectedToWifi) {
      setState(() => _tryAgain = !connectedToWifi);
    }
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Wifi"),
          content: Text("Wifi not detected. Please activate it."),
        )
    );
  }

  List<Task> tasks;

  @override
  void requestDownload(String downloadFile) async {
    //establishConnection();
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
    filesToShow.add(test.toString()+'.png');

  }
  @override
  void dummyDownload() async {

    var rnd = new Random();
    var test=rnd.nextInt(700000)+100000;
    final taskId =  FlutterDownloader.enqueue(
        url: "http://"+serverIP+":"+serverPORT+"/download/"+"abc.png",
        //url: "https://duckduckgo.com/i/0227507d.png",
        //url: "http://"+serverIP+":"+serverPORT+"/download/"+downloadFile,
        //url: "http://192.168.43.195:8000"+"/download/"+downloadFile,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: '/storage/emulated/0/Android/data/bariscan.flutterdownloader/files',
        fileName: test.toString()+'.png',
        showNotification: true,
        openFileFromNotification: true);
    //await _listofFiles();
    //this function is needed for using flutter downloader plugin
    filesToShow.add(test.toString()+'.png');

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
      fileSync();
      //file = filesToShow;  //use your folder name instead of resume.

    });
  }
  void _tempDownloadList() async{
    setState(() {
      //file=serverFileData.toList();
    });
  }

  Future <void> compareFiles() async
  {
    //jsonFileData.clear();
    //requestList.clear();

    serverFileData.forEach((text) {
      //print(text['filename']);
      print("Requested Filename: "+text['filename']);
      requestList.add(text['filename']);
      requestDownload(text['filename']);
    });

    print(requestList);
  }

  Future<void> executeOrder() async{

  }
  Future<void> exe2() async{

    await getServerFileJSONData();
    //fileSync();
    await compareFiles();
    //print("File Count:"+serverJSONData.length.toString());
    setState(() {
      _listofFiles();
    });

  }

  @override
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
                    //establishConnection();
                    setState(() {
                      requestDownload("abc.png");
                      //dummyDownload();
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
                    exe2();
                    setState(() {
                      _checkWifi();
                      _listofFiles();
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
//#region ListView builder
          Expanded(

            child: ListView.builder(
              itemCount: filesToShow.length,

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
                          TextSpan(text: filesToShow[index].toString()),
                          WidgetSpan(

                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              //child: Icon(returnedIconName),
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
