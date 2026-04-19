
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AppConstants{
  //-------------- base url set here ---------------------//
  static const String BASE_URL="https://rosdeb.xdtunnel.icu/api/v1";
  static String get APP_NAME => dotenv.env['API_KEY'] ?? 'DefaultAppName';

  // share preference Key
  static String THEME ="theme";
  static const String fcmToken = 'fcmToken';
  static RegExp emailValidator = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp passwordValidator = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");


}