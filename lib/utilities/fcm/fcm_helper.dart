import 'package:b2b/main_delegate.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/utilities/fcm/fcm_data.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmHelper {
  static final FcmHelper _singleton = FcmHelper._internal();

  factory FcmHelper() {
    return _singleton;
  }

  FcmHelper._internal();

  Future<void> init() async {
    await initializeFirebaseMessage();
  }

  Future<bool> checkTopic(String topic, String username) async {
    List<String>? topics = await LocalStorageHelper.getStringListWithPrefix(
        "fcm_topics", username);
    if (topics != null && topics.isNotEmpty) {
      for (var t in topics) {
        if (topic == t) return true;
      }
    }

    return false;
  }

  Future<void> unsubscribeUser(String username) async {
    List<String>? topics = await LocalStorageHelper.getStringListWithPrefix(
        "fcm_topics", username);
    if (topics != null && topics.isNotEmpty) {
      for (var element in topics) {
        print('unsubscribeFromTopic $element');
        FirebaseMessaging.instance.unsubscribeFromTopic(element);
      }
    }
  }

  Future<void> setFcmTopic(List<String>? topics) async {
    if (topics != null && topics.isNotEmpty) {
      Logger.debug('FCM TOPICS: ' + topics.toString());
      List<String>? oldTopics =
          await LocalStorageHelper.getStringList("fcm_topics");
      Map<String, bool> mark = {};
      if (oldTopics != null && oldTopics.isNotEmpty) {
        for (var element in oldTopics) {
          mark[element] = false;
        }
      }
      for (var element in topics) {
        mark[element] = true;
      }
      LocalStorageHelper.setStringList("fcm_topics", topics);


      //TOPIC-E294825E1157BEBEF7CDFC4929795B0798F8A0F5E0A58BE1F4757E2C766952X4

      FirebaseMessaging.instance.subscribeToTopic('TOPIC-E294825E1157BEBEF7CDFC4929795B0798F8A0F5E0A58BE1F4757E2C766952X4');

      for (var element in mark.keys) {
        if (mark[element] == true) {
          FirebaseMessaging.instance.subscribeToTopic(element);
        } else {
          FirebaseMessaging.instance.unsubscribeFromTopic(element);
        }
      }
    }
  }

  Future<void> initializeFirebaseMessage() async {
    Logger.debug('initializeFirebaseMessage');
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    SessionManager().deviceToken = (await firebaseMessaging.getToken()).toString();
    // if (Platform.isIOS) {
      Logger.debug('firebaseToken: ${SessionManager().deviceToken}');
    // } else if (Platform.isAndroid) {
    //   Logger.debug(
    //       'firebaseToken: ' + (await firebaseMessaging.getToken()).toString());
    // }

    final NotificationSettings settings =
        await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // author this app registed from firebase
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      Logger.debug('FCM: User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      Logger.debug('FCM: User granted provisional permission');
    } else {
      Logger.debug('FCM: User declined or has not accepted permission');
    }

    // init the way receive Noti when app in the terminated; required app have the one time initilizial
    await firebaseMessaging.getInitialMessage().then(
      (message) {
        if (message != null) {
          Logger.debug('Got a message whilst in the terminal!');
          Logger.debug('Notify when app terminated ${message.data}',logToFile: true);
          waitActionForContext(FcmData.fromJson(message.data),);
        }
      },
    );

    // also handle any interaction when the app is in the background via a Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Logger.debug(
          'Got a message whilst in the background! ${message.data.toString()}');
      Logger.debug('Notify in the background ${message.data}',logToFile: true);
      waitActionForContext(FcmData.fromJson(message.data));
    });

    // initialMessage.sendMessage()
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        Logger.debug('Notify in the foreground ${message.data}',logToFile: true);
        Logger.debug('Got a message whilst in the foreground!');
        Logger.debug('Message data: ${message.data}');
        Logger.debug('Message notification: ${message.notification}');
        processNotification(FcmData.fromJson(message.data),isBackground: false);
      },
    );
  }
}
