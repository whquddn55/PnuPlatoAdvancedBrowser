import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceController extends GetxController{
  SharedPreferences? _preference;

  SharedPreferences get preference => _preference!;

  static Future<PreferenceController> instance() async {
    PreferenceController newObject = PreferenceController();
    newObject._preference = await SharedPreferences.getInstance();
    return newObject;
  }
}