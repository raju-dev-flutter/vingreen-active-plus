import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'config/constants/app_const.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'data/repositories/homepage_repositories.dart';
import 'data/repositories/invoice_repositories.dart';
import 'data/repositories/lead_repositories.dart';
import 'data/repositories/login_repositories.dart';
import 'data/repositories/petty_cash_repositories.dart';
import 'data/repositories/profile_repositories.dart';
import 'data/repositories/proforma_invoice_repositories.dart';
import 'data/repositories/quotation_repositories.dart';
import 'data/repositories/task_repositories.dart';
import 'data/repositories/ticket_repositories.dart';
import 'data/repositories/user_repositories.dart';
import 'logic/bloc/authentication/authentication_bloc.dart';
import 'logic/bloc/home/attendance/attendance_bloc.dart';
import 'logic/bloc/home/attendance_list/attendance_list_bloc.dart';
import 'logic/bloc/home/count/dashboard_count_bloc.dart';
import 'logic/bloc/home/dashboard/dashboard_bloc.dart';
import 'logic/bloc/invoice/invoice_bloc.dart';
import 'logic/bloc/petty_cash/petty_cash_bloc.dart';
import 'logic/bloc/profile/profile_bloc.dart';
import 'logic/bloc/proforma_invoice/proforma_invoice_bloc.dart';
import 'logic/bloc/quotation/quotation_bloc.dart';
import 'logic/cubit/invoice/invoice_crud_cubit.dart';
import 'logic/cubit/lead/call_again/call_again_lead_cubit.dart';
import 'logic/cubit/lead/converted/converted_lead_cubit.dart';
import 'logic/cubit/lead/fresh_lead/fresh_lead_cubit.dart';
import 'logic/cubit/lead/lead_crud/lead_crud_cubit.dart';
import 'logic/cubit/lead/lead_filter/lead_filter_cubit.dart';
import 'logic/cubit/lead/reconnect/reconnect_lead_cubit.dart';
import 'logic/cubit/navigation/navigation_cubit.dart';
import 'logic/cubit/permission/permission_cubit.dart';
import 'logic/cubit/petty_cash/petty_cash_crud_cubit.dart';
import 'logic/cubit/profile_update_form/profile_update_form_cubit.dart';
import 'logic/cubit/proforma_invoice/proforma_invoice_crud_cubit.dart';
import 'logic/cubit/quotation/quotation_crud_cubit.dart';
import 'logic/cubit/task/task_completed/task_completed_cubit.dart';
import 'logic/cubit/task/task_crud/task_crud_cubit.dart';
import 'logic/cubit/task/task_filter/task_filter_cubit.dart';
import 'logic/cubit/task/task_progress/task_progress_cubit.dart';
import 'logic/cubit/task/task_start/task_start_cubit.dart';
import 'logic/cubit/ticket/ticket_completed/ticket_completed_cubit.dart';
import 'logic/cubit/ticket/ticket_crud/ticket_crud_cubit.dart';
import 'logic/cubit/ticket/ticket_filter/ticket_filter_cubit.dart';
import 'logic/cubit/ticket/ticket_progress/ticket_progress_cubit.dart';
import 'logic/cubit/ticket/ticket_start/ticket_start_cubit.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/root/root_page.dart';
import 'presentation/pages/startup/permission_page.dart';
import 'presentation/pages/startup/splash_page.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  final connectivity = Connectivity();
  final userRepositories = UserRepositories();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // await Firebase.initializeApp();
  // await NotificationServiceBloc().initialize();
  runApp(
    MultiRepositoryProvider(
      providers: repositoryProvider(),
      child: MultiBlocProvider(
        providers: blocProvider(connectivity),
        child: AppWidget(userRepositories: userRepositories),
      ),
    ),
  );
}

repositoryProvider() {
  return [
    RepositoryProvider<UserRepositories>(
        create: (context) => UserRepositories()),
    RepositoryProvider<LoginRepositories>(
        create: (context) => LoginRepositories()),
    RepositoryProvider<HomepageRepositories>(
        create: (context) => HomepageRepositories()),
    RepositoryProvider<ProfileRepositories>(
        create: (context) => ProfileRepositories()),
    RepositoryProvider<TaskRepositories>(
        create: (context) => TaskRepositories()),
    RepositoryProvider<LeadRepositories>(
        create: (context) => LeadRepositories()),
    RepositoryProvider<TicketRepositories>(
        create: (context) => TicketRepositories()),
    RepositoryProvider<PettyCashRepositories>(
        create: (context) => PettyCashRepositories()),
    RepositoryProvider<QuotationRepositories>(
        create: (context) => QuotationRepositories()),
    RepositoryProvider<InvoiceRepositories>(
        create: (context) => InvoiceRepositories()),
    RepositoryProvider<ProformaInvoiceRepositories>(
        create: (context) => ProformaInvoiceRepositories()),
  ];
}

blocProvider(Connectivity connectivity) {
  return [
    BlocProvider<AuthenticationBloc>(create: (context) {
      return AuthenticationBloc(
          userRepositories: context.read<UserRepositories>())
        ..add(AppStarted());
    }),
    BlocProvider<PermissionCubit>(create: (context) {
      return PermissionCubit(currentPermission: Permission.unknown)
        ..checkIfPermissionNeeded();
    }),
    BlocProvider<NavigationCubit>(create: (context) => NavigationCubit()),

    // Home Page

    BlocProvider<DashboardBloc>(create: (context) {
      return DashboardBloc(
          userRepositories: context.read<UserRepositories>(),
          homepageRepositories: context.read<HomepageRepositories>())
        ..add(GetUserDetails());
    }),
    BlocProvider<AttendanceBloc>(create: (context) {
      return AttendanceBloc(
          userRepositories: context.read<UserRepositories>(),
          homepageRepositories: context.read<HomepageRepositories>())
        ..add(AttendanceStatus());
    }),
    BlocProvider<DashboardCountBloc>(create: (context) {
      return DashboardCountBloc(
          userRepositories: context.read<UserRepositories>(),
          homepageRepositories: context.read<HomepageRepositories>())
        ..add(DashboardCount());
    }),

    BlocProvider<AttendanceListBloc>(create: (context) {
      return AttendanceListBloc(
          userRepositories: context.read<UserRepositories>(),
          homepageRepositories: context.read<HomepageRepositories>())
        ..add(GetAttendanceList());
    }),

    // Profile  Page

    BlocProvider<ProfileBloc>(create: (context) {
      return ProfileBloc(
          userRepositories: context.read<UserRepositories>(),
          profileRepositories: context.read<ProfileRepositories>())
        ..add(ProfileStatus());
    }),
    BlocProvider<ProfileUpdateFormCubit>(
      create: (context) => ProfileUpdateFormCubit(
        userRepositories: context.read<UserRepositories>(),
        profileRepositories: context.read<ProfileRepositories>(),
      ),
    ),

    // Task  Page

    BlocProvider<TaskStartCubit>(
      create: (context) => TaskStartCubit(
        userRepositories: context.read<UserRepositories>(),
        taskRepositories: context.read<TaskRepositories>(),
      )..getTaskStartDetails(),
    ),
    BlocProvider<TaskProgressCubit>(
      create: (context) => TaskProgressCubit(
        userRepositories: context.read<UserRepositories>(),
        taskRepositories: context.read<TaskRepositories>(),
      )..getTaskProgressDetails(),
    ),
    BlocProvider<TaskCompletedCubit>(
      create: (context) => TaskCompletedCubit(
        userRepositories: context.read<UserRepositories>(),
        taskRepositories: context.read<TaskRepositories>(),
      )..getTaskCompletedDetails(),
    ),
    BlocProvider<TaskCrudCubit>(
      create: (context) => TaskCrudCubit(
        userRepositories: context.read<UserRepositories>(),
        taskRepositories: context.read<TaskRepositories>(),
      ),
    ),
    BlocProvider<TaskFilterCubit>(
      create: (context) => TaskFilterCubit(
        userRepositories: context.read<UserRepositories>(),
        taskRepositories: context.read<TaskRepositories>(),
      ),
    ),

    // Lead  Page

    BlocProvider<FreshLeadCubit>(
      create: (context) => FreshLeadCubit(
        userRepositories: context.read<UserRepositories>(),
        leadRepositories: context.read<LeadRepositories>(),
      )..getFreshLead(),
    ),
    BlocProvider<CallAgainLeadCubit>(
      create: (context) => CallAgainLeadCubit(
        userRepositories: context.read<UserRepositories>(),
        leadRepositories: context.read<LeadRepositories>(),
      )..getCallAgainLead(),
    ),
    BlocProvider<ReconnectLeadCubit>(
      create: (context) => ReconnectLeadCubit(
        userRepositories: context.read<UserRepositories>(),
        leadRepositories: context.read<LeadRepositories>(),
      )..getReconnectLead(),
    ),
    BlocProvider<ConvertedLeadCubit>(
      create: (context) => ConvertedLeadCubit(
        userRepositories: context.read<UserRepositories>(),
        leadRepositories: context.read<LeadRepositories>(),
      )..getConvertedLead(),
    ),
    BlocProvider<LeadCrudCubit>(
      create: (context) => LeadCrudCubit(
        userRepositories: context.read<UserRepositories>(),
        leadRepositories: context.read<LeadRepositories>(),
      ),
    ),
    BlocProvider<LeadFilterCubit>(
      create: (context) => LeadFilterCubit(
        userRepositories: context.read<UserRepositories>(),
        leadRepositories: context.read<LeadRepositories>(),
      ),
    ),

    // Tickets  Page

    BlocProvider<TicketStartCubit>(
      create: (context) => TicketStartCubit(
        userRepositories: context.read<UserRepositories>(),
        ticketRepositories: context.read<TicketRepositories>(),
      )..getTicketStartDetails(),
    ),
    BlocProvider<TicketProgressCubit>(
      create: (context) => TicketProgressCubit(
        userRepositories: context.read<UserRepositories>(),
        ticketRepositories: context.read<TicketRepositories>(),
      )..getTicketProgressDetails(),
    ),
    BlocProvider<TicketCompletedCubit>(
      create: (context) => TicketCompletedCubit(
        userRepositories: context.read<UserRepositories>(),
        ticketRepositories: context.read<TicketRepositories>(),
      )..getTicketCompletedDetails(),
    ),
    BlocProvider<TicketCrudCubit>(
      create: (context) => TicketCrudCubit(
        userRepositories: context.read<UserRepositories>(),
        ticketRepositories: context.read<TicketRepositories>(),
      ),
    ),

    BlocProvider<TicketFilterCubit>(
      create: (context) => TicketFilterCubit(
        userRepositories: context.read<UserRepositories>(),
        ticketRepositories: context.read<TicketRepositories>(),
      ),
    ),

    // Petty Cash  Page

    BlocProvider<PettyCashBloc>(
      create: (context) => PettyCashBloc(
        userRepositories: context.read<UserRepositories>(),
        pettyCashRepositories: context.read<PettyCashRepositories>(),
      ),
    ),
    BlocProvider<PettyCashCrudCubit>(
      create: (context) => PettyCashCrudCubit(
        userRepositories: context.read<UserRepositories>(),
        pettyCashRepositories: context.read<PettyCashRepositories>(),
      ),
    ),

    // Quotation Page

    BlocProvider<QuotationBloc>(
      create: (context) => QuotationBloc(
        userRepositories: context.read<UserRepositories>(),
        quotationRepositories: context.read<QuotationRepositories>(),
      ),
    ),
    BlocProvider<QuotationCrudCubit>(
      create: (context) => QuotationCrudCubit(
        userRepositories: context.read<UserRepositories>(),
        quotationRepositories: context.read<QuotationRepositories>(),
      ),
    ),

    // Invoice Page

    BlocProvider<InvoiceBloc>(
      create: (context) => InvoiceBloc(
        userRepositories: context.read<UserRepositories>(),
        invoiceRepositories: context.read<InvoiceRepositories>(),
      ),
    ),
    BlocProvider<InvoiceCrudCubit>(
      create: (context) => InvoiceCrudCubit(
        userRepositories: context.read<UserRepositories>(),
        invoiceRepositories: context.read<InvoiceRepositories>(),
      ),
    ),

    // Proforma Invoice Page

    BlocProvider<ProformaInvoiceBloc>(
      create: (context) => ProformaInvoiceBloc(
        userRepositories: context.read<UserRepositories>(),
        proformaInvoiceRepositories:
            context.read<ProformaInvoiceRepositories>(),
      ),
    ),
    BlocProvider<ProformaInvoiceCrudCubit>(
      create: (context) => ProformaInvoiceCrudCubit(
        userRepositories: context.read<UserRepositories>(),
        proformaInvoiceRepositories:
            context.read<ProformaInvoiceRepositories>(),
      ),
    ),
  ];
}

class AppWidget extends StatelessWidget {
  final UserRepositories userRepositories;

  const AppWidget({super.key, required this.userRepositories});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConst.title,
      theme: appThemData(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes.generateRoute,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState state) {
          if (state is AuthenticationUninitialized) {
            return const SplashPage();
          }
          if (state is AppPermissionNotGranded) {
            return const PermissionPage();
          }
          if (state is AuthenticationUnauthenticated) {
            return LoginPage(userRepositories: userRepositories);
          }
          if (state is AuthenticationAuthenticated) {
            return const RootPage();
          }
          return Container();
        },
      ),
    );
  }
}

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('${bloc.runtimeType} $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
  }
}


/*
    
    _initFirebaseCM();
  }

  _initApp() async {
    _isUserLoggedIn = await SharedPreferenceHelper()
        .getValueFromKey(Constants.USER_LOGGED_IN);
    _isPermissionGranted =
        await SharedPreferenceHelper().getValueFromKey(Constants.PERMISSION);
    setState(() {
      _isLoading = false;
    });
  }

  _askNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  _initFirebaseCM() {
    _firebaseMessaging.getToken().then((value) {
      print("AppDeviceKey :: $value");
      SharedPreferenceHelper().setDeviceToken(value);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      _showNotification(event);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data["leadId"] != null &&
          message.data["leadId"] != "" &&
          message.data["leadName"] != null &&
          message.data["leadName"] != "") {
        String leadId = message.data["leadId"].toString();
        String leadName = message.data["leadName"].toString();
        try {
          navigatorKey.currentState.push(MaterialPageRoute(
              builder: (_) => LeadViewScreen(leadId, leadName)));
        } catch (e) {
          print("Message listener(e) : ${e.toString()}");
        }
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      try {
        if (message.data["leadId"] != null &&
            message.data["leadId"] != "" &&
            message.data["leadName"] != null &&
            message.data["leadName"] != "") {
          String leadId = message.data["leadId"].toString();
          String leadName = message.data["leadName"].toString();
          navigatorKey.currentState.push(MaterialPageRoute(
              builder: (_) => LeadViewScreen(leadId, leadName)));
        }
      } catch (e) {
        print("Background handler(e) : ${e.toString()}");
      }
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('_', '__',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        message.notification.title ?? "CRM",
        message.notification.body ?? "You received a new message",
        platformChannelSpecifics,
        payload: '${message.data["leadId"]},${message.data["leadName"]}');
  }
  
  // |=======================| 

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
             android: initializationSettingsAndroid,
             iOS: initializationSettingsDarwin,
             linux: initializationSettingsLinux
            );
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onDidReceiveNotificationResponse: onDidReceiveLocalNotification);
  }

  void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: const Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           // await Navigator.push(
    //           //   context,
    //           //   MaterialPageRoute(
    //           //     builder: (context) => SecondScreen(payload),
    //           //   ),
    //           // );
    //         },
    //       )
    //     ],
    //   ),
    // );
  }

  Future selectNotification(String? message) async {
    //Handle notification tapped logic here
    debugPrint(message);
    try {
      List<String> result = message!.split(",");

      String id = result[0];
      final isCheckId = id != "null" && id != "";
      if (isCheckId) {
        // navigatorKey.currentState?.push(
        //     MaterialPageRoute(builder: (_) => LeadDetailPage(leadId: id)));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
*/