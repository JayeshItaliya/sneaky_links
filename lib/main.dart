
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:sneaky_links/Components/constants.dart';
import 'package:sneaky_links/Pages/Notification/norification%20page.dart';
import 'package:sneaky_links/controllers/network_binding.dart';
import 'dart:async';
import 'Components/constants.dart';
import 'Pages/DiscoverScreen/userProfileD.dart';
import 'Pages/message/chat.dart';
import 'Pages/splash_page.dart';
import 'VideoCalling/receivingpage.dart';
import 'controllers/payServices.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  await Firebase.initializeApp();
  print('Handling a background message ${message.toString()}');
}

AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb)
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCzUTJ69WR3RE4daYpv3XDdD_946rnHWcg",
          authDomain: "sneaky-links-us.firebaseapp.com",
          projectId: "sneaky-links-us",
          storageBucket: "sneaky-links-us.appspot.com",
          messagingSenderId: "442038173243",
          appId: "1:442038173243:web:521e4e021876861b33661e",
          measurementId: "G-LGZBRGW8BJ"
      ),
    );
  else
  await Firebase.initializeApp();
  Stripe.publishableKey = "pk_live_51KIfWjKxHMI6m1cAw9zIKWiyiLK0byUFkm7tQ0c8MFkiCVeyb8FHfhDpssspABVYZRJZnDymY8W2e0Aj0Il3v4dr005VM8FAD7";
  Stripe.merchantIdentifier = 'live';
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onGetnoti();
  }


  void onGetnoti() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      AndroidNotification? android = message!.notification!.android;
      print("message+++++"+message.data.toString());
      // print("message+++++"+message.data['channel'].toString());
      print("message+++++userId"+message.data['userId'].toString());
      var uid = message.data.entries.toString();
        setState(() {
          Constant.Token = message.data['token'];
          Constant.channel = message.data['channel'];
          Constant.profilePicture = message.data['profilePicture'];
          Constant.senderId = message.data['userId'];
          Constant.username = message.data['username'];
          Constant.type = message.data['type'];
        });

        if (message.data['notificationType'].toString() == "-1") {

        } else if (message.data['type'] == "null") {
          _showBigPictureNotification(
              message.notification!.title, message.notification!.body);
        } else if (message.data['type'] == "Audio") {
          Get.to(ReciverPage());
        }
        else if (message.data['type'] == "Video") {
          Get.to(ReciverPage());
        }
        else {

        }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
      if (message.data != null) {
        setState(() {
          Constant.Token = message.data['token'];
          Constant.channel = message.data['channel'];
          Constant.profilePicture = message.data['profilePicture'];
          Constant.senderId = message.data['userId'];
          Constant.username = message.data['username'];
          Constant.type = message.data['type'];
        });
        if (message.data["notificationType"] == "3") {
          var data = {
            'id': message.data["userId"],
            'user': message.data["username"],
            'image': message.data["profilePicture"],
            'token': "",
          };
          var res = await Get.to(Chat(
            data: data,
          ));
        } else if (message.data["notificationType"] == "1") {
          Get.to(UserProfileD(
            item: Constant.senderId.toString(),
          ));
        } else if (message.data['notificationType'].toString() == "-1") {
        } else if (message.data['type'] == "Audio") {
          Get.to(ReciverPage());
        } else if (message.data['type'] == "Video") {
          Get.to(ReciverPage());
        } else {}
      }
    });

    var initializationSettingsAndroid = const AndroidInitializationSettings('logo');
    var initializationSettingsIOS =  const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin!.initialize(initializationSettings);

  }


  Future<void> _showBigPictureNotification(title,msg) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',importance: Importance.max);
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics );
    await flutterLocalNotificationsPlugin!.show(0, title, msg, platformChannelSpecifics);
  }

  Future<void> onSelectNotification(String payload) async {
    print("__________________");
    // Get.to(NavBarPage(initialPage:"NotificationBlank"));
    Get.to(NotificationPage());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ProviderModel(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sneaky Links',
        theme: ThemeData(
          // canvasColor: Colors.transparent,
          primarySwatch: Colors.pink,
        ),
        initialBinding: NetworkBinding(),
        builder: EasyLoading.init(),
        home: SplashPage(),
        // home: ReciverPage(pname: "0",ptoken: "0",RoomId: "0"),
      ),
    );
  }

}
