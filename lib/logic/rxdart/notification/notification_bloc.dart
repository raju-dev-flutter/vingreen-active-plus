// import 'dart:async';  
//
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:rxdart/rxdart.dart';
//
// class NotificationServiceBloc {
//  
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   // final BehaviorSubject<String> _messageStreamController =
//   // BehaviorSubject<String>();
//   //
//   static final NotificationServiceBloc _notificationServiceBloc =
//   NotificationServiceBloc._internal();
//
//   factory NotificationServiceBloc() {
//     return _notificationServiceBloc;
//   }
//
//   NotificationServiceBloc._internal();
// 
//  
//   // Stream<String> get messageStream => _messageStreamController.stream;
// 
//   Future<void> initialize() async {
//     // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('app_icon');
//   
//     final DarwinInitializationSettings initializationSettingsDarwin =
//     DarwinInitializationSettings(
//         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//   
//     const LinuxInitializationSettings initializationSettingsLinux =
//     LinuxInitializationSettings(defaultActionName: 'Open notification');
//  
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsDarwin,
//         linux: initializationSettingsLinux
//     );
//
//     // await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
//     //     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) {
//         switch (notificationResponse.notificationResponseType) {
//           case NotificationResponseType.selectedNotification:
//             selectNotificationStream.add(notificationResponse.payload);
//             break;
//           case NotificationResponseType.selectedNotificationAction:
//             if (notificationResponse.actionId == navigationActionId) {
//               selectNotificationStream.add(notificationResponse.payload);
//             }
//             break;
//         }
//       },
//       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//     );
//   }
// 
//   void onDidReceiveLocalNotification(
//       int? id, String? title, String? body, String? payload) async {
//     
//   }
//  
//   void onDidReceiveNotificationResponse()async {}
// }
// 