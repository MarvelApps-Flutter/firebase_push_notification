import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_push_notifications_app/main.dart';
import 'package:flutter_push_notifications_app/screen.dart';

class Messaging extends StatefulWidget {
  const Messaging({Key? key}) : super(key: key);
  static late BuildContext openContext;

  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final List<Message> messages = [];
  int _counter =0;



  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.notification!=null) {
      setState(() {
        messages.add(
          Message(
            title: message.notification!.title.toString(),
            body: message.notification!.body.toString(),
          ),
        );
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Screen(text: 'Open from terminated state',)));
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(message.notification!.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(message.notification!.body.toString())],
                  ),
                ),
              );
            });
      });
    }
  }

  void selectNotification(String? payload) async {

    debugPrint('notification payload: $payload');

    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => Screen(text:payload.toString())),
    );
  }

  @override
  void initState() {
    super.initState();

    setupInteractedMessage();

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             channelDescription: channel.description,
    //             color: Colors.blue,
    //             playSound: true,
    //             icon: '@mipmap/ic_launcher',
    //           ),
    //         ),
    //         payload: 'Open from foreground notification'
    //     );
    //     setState(() {
    //       messages.add(
    //         Message(
    //           title: message.notification!.title.toString(),
    //           body: message.notification!.body.toString(),
    //         ),
    //       );
    //     });
    //
    //   }
    // });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Screen(text: 'open from the background state',)));
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            });
        setState(() {
          messages.add(
            Message(
              title: message.notification!.title.toString(),
              body: message.notification!.body.toString(),
            ),
          );
        });
      }
    });
  }

  // void showNotification() {
  //   setState(() {
  //     _counter++;
  //   });
  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       "Testing $_counter",
  //       "How you doin ?",
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(channel.id, channel.name,
  //             channelDescription: channel.description,
  //             importance: Importance.high,
  //             color: Colors.blue,
  //             playSound: true,
  //             icon: '@mipmap/ic_launcher'),
  //       ),
  //       payload: 'Open from Local Notification'
  //   );
  //   setState(() {
  //     messages.add(
  //       Message(
  //         title: "Testing $_counter",
  //         body: "How you doin ?",
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Messaging.openContext=context;
    return
      Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: AppBar(
          title: const Text('Notification'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: messages.map(buildMessage).toList(),
            ),
          ),
        ),
        //floatingActionButton:
        // FloatingActionButton(
        //   onPressed: showNotification,
        //   tooltip: 'Local Notification',
        //   child: const Text(
        //     '@',
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontSize: 30,
        //       fontStyle:FontStyle.italic,
        //       fontWeight:FontWeight.bold,
        //     ),
        //   ),
        // ),
      );
  }

  Widget buildMessage(Message message) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade400,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:10.0),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage:
                NetworkImage('https://via.placeholder.com/150'),
                backgroundColor: Colors.transparent,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.title,style:TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontStyle:FontStyle.italic,
                  fontWeight:FontWeight.w500,
                ),),
                Text(message.body,style:TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),),
              ],
            ),
          ],
        ),
      ),


    ),
  );


  SliverAppBar buildSliverAppBar()
  {
    return SliverAppBar(
      snap: true,
      floating: true,
      backgroundColor: const Color(0xFF200087),
      expandedHeight: 100,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          borderRadius:
          const BorderRadius.vertical(bottom: Radius.circular(40)),
        ),
      ),
    );
  }
}

class Message {
  final String title;
  final String body;

  const Message({
    required this.title,
    required this.body,
  });
}