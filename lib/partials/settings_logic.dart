import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static final storage = SharedPreferences.getInstance();

  static void enableNarration(bool status) async {
    (await storage).setBool("narration", status ?? false);
  }

  static void enableMorseCode(bool status) async {
    (await storage).setBool("morseCode", status ?? false);
  }

  static void enableReducedNetorkUsage(bool status) async {
    (await storage).setBool("reducedNetwork", status ?? false);
  }

  static Future<bool> shouldNarrate() async {
    return (await storage).getBool("narration") ?? false;
  }

  static Future<bool> shouldMorseCode() async {
    return (await storage).getBool("morseCode") ?? false;
  }

  static Future<bool> shouldReducedNetorkUsage() async {
    return (await storage).getBool("reducedNetwork") ?? false;
  }
}
