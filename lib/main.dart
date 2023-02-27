import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:todo_app/utils/constants/todo_colors.dart';
import 'models/todo_list/todo_list_model.dart';
import 'models/todo/todo_model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'navigation/todo_router_delegate.dart';
import 'navigation/todo_router_information_parser.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await Hive.initFlutter();
    Hive.registerAdapter(TodoListModelAdapter());
    Hive.registerAdapter(TodoModelAdapter());
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const MyApp());
  },
          (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TodoRouterDelegate routerDelegate = TodoRouterDelegate();
  TodoRouterInformationParser routerInformationParser = TodoRouterInformationParser();

  @override
  Widget build(BuildContext context) => MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.light().copyWith(
          extensions: <ThemeExtension<TodoColors>>[
            const TodoColors(
                supportSeparator: Color(0x33000000),
                supportOverlay: Color(0x0F000000),
                labelPrimary: Color(0xff000000),
                labelSecondary: Color(0x99000000),
                labelTertiary: Color(0x4D000000),
                labelDisable: Color(0x26000000),
                colorRed: Color(0xffFF3B30),
                colorGreen: Color(0xff34C759),
                colorBlue: Color(0xff007AFF),
                colorGray: Color(0xff8E8E93),
                colorGrayLight: Color(0xffD1D1D6),
                colorWhite: Color(0xffFFFFFF),
                backPrimary: Color(0xffF7F6F2),
                backSecondary: Color(0xffFFFFFF),
                backElevated: Color(0xffFFFFFF),
                remoteColor: Color(0xffFF3B30)
            )
          ]
      ),
      darkTheme: ThemeData.dark().copyWith(
          extensions: <ThemeExtension<TodoColors>>[
            const TodoColors(
                supportSeparator: Color(0x33FFFFFF),
                supportOverlay: Color(0x52000000),
                labelPrimary: Color(0xffFFFFFF),
                labelSecondary: Color(0x99FFFFFF),
                labelTertiary: Color(0x66FFFFFF),
                labelDisable: Color(0x26FFFFFF),
                colorRed: Color(0xffFF453A),
                colorGreen: Color(0xff32D74B),
                colorBlue: Color(0xff0A84FF),
                colorGray: Color(0xff8E8E93),
                colorGrayLight: Color(0xff48484A),
                colorWhite: Color(0xffFFFFFF),
                backPrimary: Color(0xff161618),
                backSecondary: Color(0xff252528),
                backElevated: Color(0xff3C3C3F),
                remoteColor: Color(0xffFF453A)
            )
          ]
      ),
      routerDelegate: routerDelegate,
      routeInformationParser: routerInformationParser
  );
}