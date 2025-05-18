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
      backgroundColor: mainColor,
      foregroundColor: touchesColor,
    ),
    scaffoldBackgroundColor: secoderyColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: touchesColor),
      bodyMedium: TextStyle(color: touchesColor),
      bodySmall: TextStyle(color: touchesColor),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: mainColor.withAlpha(100),
      titleTextStyle: TextStyle(
        color: touchesColor,
        fontWeight: FontWeight.bold,
        fontSize: 18.sp,
      ),
      subtitleTextStyle: TextStyle(color: touchesColor),
      iconColor: touchesColor,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
// custom wigets===========================

Widget customButton({
  required void Function() onPressed,
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
        SizedBox(width: 10.w),
      ],
    ),
  );
}

Widget myTextField({
  required String label,
  bool? obscure,
  int? maxLines,
  TextEditingController? controller,
  String? Function(String?)? validator,
  TextInputType? keyboardType,
  Widget? suffix,
}) {
  return TextFormField(
    style: TextStyle(color: touchesColor),
    controller: controller,
    obscuringCharacter: '*',

    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(8, 5, 5, 5).r,

      suffix: suffix,

      labelText: label,
      labelStyle: TextStyle(color: touchesColor, fontWeight: FontWeight.bold),
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: touchesColor, width: 3.w),
      ),
    ),
    maxLines: maxLines,
    obscureText: obscure ?? false,
    keyboardType: keyboardType,

    validator: validator,
  );
}
