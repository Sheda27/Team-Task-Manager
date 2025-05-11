import 'package:team_task_manager/view/index.dart';

class AppTheme {
  ThemeData lightTheme = ThemeData(
    brightness: Brightness.dark,

    // primarySwatch:MaterialColor(1,mainColor)  ,
    appBarTheme: AppBarTheme(
      backgroundColor: mainColor,
      foregroundColor: touchesColor,
      shadowColor: mainColor,
      elevation: 5,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secoderyColor,
    ),
    scaffoldBackgroundColor: touchesColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: touchesColor),
      bodyMedium: TextStyle(color: touchesColor),
      bodySmall: TextStyle(color: touchesColor),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: thirdColor.withAlpha(150),
      titleTextStyle: TextStyle(
        color: mainColor,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      subtitleTextStyle: TextStyle(color: mainColor),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // static ThemeData darkTheme = ThemeData(
  //   brightness: Brightness.dark,
  //   primarySwatch: Colors.blueGrey,
  //   appBarTheme: AppBarTheme(
  //     backgroundColor: Colors.blueGrey,
  //     foregroundColor: Colors.white,
  //     elevation: 0,
  //   ),
  //   textTheme: TextTheme(
  //     bodyText1: TextStyle(color: Colors.white),
  //     bodyText2: TextStyle(color: Colors.white70),
  //   ),
  //   buttonTheme: ButtonThemeData(
  //     buttonColor: Colors.blueGrey,
  //     textTheme: ButtonTextTheme.primary,
  //   ),
  // );
}
// custom wigets===========================

Widget customButton({
  required Future<void> Function() onPressed,
  required String buttonText,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(touchesColor),
      backgroundColor: WidgetStatePropertyAll(mainColor),
      shadowColor: WidgetStatePropertyAll(thirdColor),
      elevation: WidgetStatePropertyAll(5),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(buttonText, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
      ],
    ),
  );
}
