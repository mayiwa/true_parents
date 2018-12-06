import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:true_parents/pages/child_manager.dart';
import 'package:true_parents/util/date_time_util.dart';
import 'package:true_parents/util/manage_parent_info.dart';
import 'package:true_parents/model/notification.dart';
import 'package:true_parents/util/build_drawer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsManager extends StatefulWidget {
  @override
  _NotificationsManagerState createState() => _NotificationsManagerState();
}

class _NotificationsManagerState extends State<NotificationsManager> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final dateFormatter = new DateFormat("EEEE, d MMMM y");
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final List<String> databaseNameList = <String>["TestAllClockIns","TestAllClockOuts"];
  List<DatabaseReference> databaseRefList = <DatabaseReference>[];
  List<FBNotification> notificationList = <FBNotification>[];
  String schoolIDList = "";
  String subjectID = "";


  @override
  void initState() {
    DatabaseReference databaseReference;
    super.initState();
    ManageParentInfo.getInfo().then((Map<String,String> map){
        notificationList.clear();
        subjectID = map["subjectID"];
        schoolIDList = map["schoolIDList"];
        print("schoollist is: $schoolIDList");
        List<String> list = schoolIDList.split(",");
        databaseNameList.forEach((String databaseName){
          list.forEach((schoolID){
            databaseReference = database.reference().child("$databaseName/$schoolID/$subjectID");
            databaseReference.onChildAdded.listen(_onEntryAdded);
            databaseReference.onChildRemoved.listen(_onEntryRemoved);
            setState(() {
              databaseRefList.add(databaseReference);
            });
          });
        });
      });

    var initializationSettingsAndroid =
    new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BuildDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("View Notifications"),  
      ),
      body: _buildBody(),
    );
  }

  void sortByDates(){
    setState(() {
      notificationList.sort((a,b)=>b.dateTime.compareTo(a.dateTime));
      notificationList.forEach((note){
        print("Date: ${note.dateTime} - ${note.message} \n");
      });
    });
  }

  Widget _buildBody(){

    sortByDates();

    if(notificationList.length > 0) {
      return Column(
          children: [
            Flexible(
              child: ListView.builder(
                  itemCount: notificationList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        color: Colors.grey[100],
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(10.0)),
                            Text("${dateToWords(
                                notificationList[index].dateTime)}"),
                            Padding(padding: EdgeInsets.all(10.0)),
                            Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.all(10.0)),
                                ClipOval(
                                  child: notificationList[index]
                                      .guardianImgUrl != null ?
                                  Image.network(
                                    notificationList[index].guardianImgUrl,
                                    width: 80.0, height: 80.0,
                                    fit: BoxFit.cover,) : null,
                                ),
                                Padding(padding: EdgeInsets.only(left: 15.0)),
                                ClipOval(
                                  child: notificationList[index].childImgUrl !=
                                      null ?
                                  Image.network(
                                    notificationList[index].childImgUrl,
                                    width: 80.0, height: 80.0,
                                    fit: BoxFit.cover,) : null,
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: notificationList[index].subject !=
                                        null
                                        ?
                                    Text(notificationList[index].subject)
                                        : null,
                                  ),
                                )
                              ],
                            ),
                            notificationList[index].message != null ?
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                notificationList[index].message,
                                textAlign: TextAlign.left,
                              ),
                            ) : null,
                            Padding(padding: EdgeInsets.all(10.0)),
                          ],
                        )
                    );
                  }),
            )
          ]
      );
    }else{
      return Center(
        child: Icon(Icons.signal_wifi_off,size: 400.0,),
      );
    }
  }

  String dateToWords(String dateTime){
    Map dateMap = MyDateTime.putDateTimeInArray(dateTime);
    print("Map received: $dateMap");
    return dateFormatter.format(DateTime(dateMap["year"], dateMap["month"],dateMap["day"],dateMap["hour"],dateMap["min"],dateMap["sec"]));
  }

  void _onEntryAdded(Event event) {
    setState(() {
      //print("adding ${event.snapshot.value["message"]}");
     notificationList.add(FBNotification.fromSnapshot(event.snapshot));
     _showNotification(event.snapshot.value["subject"],event.snapshot.value["message"]);
    });
  }

  void _onEntryRemoved(Event event){

    var oldEntry = notificationList.singleWhere((entry){
      return entry.key == event.snapshot.key;
    });

    setState(() {
      notificationList.removeAt(notificationList.indexOf(oldEntry));
    });
  }

  Future _showNotification(String subject, String message) async {

    print("show notification");

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, subject, message, platformChannelSpecifics,
        payload: 'item x');
  }

  Future _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => NotificationsManager()),
    );
  }
}
