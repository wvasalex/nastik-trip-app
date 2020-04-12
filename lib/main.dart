import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'shared/shared.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'ru_RU';
  await initializeDateFormatting('ru_RU', null);

  Connection().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color textColor = Color(0xFF323132);
    final Color errorColor = Colors.deepOrange;
    final Color primaryColor = Colors.deepOrange;

    return MaterialApp(
      title: 'Мгновенные заметки',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'OpenSans',
        primaryColor: primaryColor,
        errorColor: errorColor,
        secondaryHeaderColor: Color(0xFFF5F5DC),
        scaffoldBackgroundColor: Colors.white,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
        colorScheme: ColorScheme(
          primary: primaryColor,
          primaryVariant: Color(0xff333333),
          secondary: Color(0xFFBDBDBD),
          secondaryVariant: Color(0xFFE0E0E0),
          surface: Color(0xffd5b59c),
          background: Color(0xffd5b59c),
          error: errorColor,
          brightness: Brightness.light,
          onBackground: Color(0xff0043EE),
          onError: Color(0xff0043EE),
          onPrimary: Color(0xff0043EE),
          onSecondary: Color(0xff0043EE),
          onSurface: Color(0xff0043EE),
        ),
        textTheme: TextTheme(
          headline: TextStyle(
            fontSize: 26,
            height: 30 / 26,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          subhead: TextStyle(
            fontSize: 24,
            height: 28 / 24,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          title: TextStyle(
            fontSize: 22,
            height: 26 / 22,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          subtitle: TextStyle(
            fontSize: 18,
            height: 22 / 18,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          body1: TextStyle(
            fontSize: 15,
            height: 19 / 15,
            color: textColor,
          ),
          body2: TextStyle(
            fontSize: 11,
            height: 14 / 11,
            color: textColor,
          ),
          display4: TextStyle(
            fontSize: 11,
            height: 14 / 11,
            fontWeight: FontWeight.normal,
            color: Color(0xFF323132),
          ),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: SwitchScreen.routeName,
      routes: {
        SwitchScreen.routeName: (_) => SwitchScreen(),
        ContentList.routeName: (_) => ContentList(),
      },
    );
  }
}