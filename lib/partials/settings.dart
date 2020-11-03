import 'package:shared_preferences/shared_preferences.dart';

class SecryptoSettings {
  static final storage = SharedPreferences.getInstance();

  static void enableNarration(bool status) async => (await storage).setBool("narration", status ?? false);

  static void enableMorseCode(bool status) async => (await storage).setBool("morseCode", status ?? false);

  static void enableReducedNetorkUsage(bool status) async => (await storage).setBool("reducedNetwork", status ?? false);

  static void enableSosMorseFlash(bool status) async => (await storage).setBool("sosMorseFlash", status ?? false);

  static void enableDarkMode(bool status) async => (await storage).setBool("darkMode", status ?? false);

  static Future<bool> shouldNarrate() async => (await storage).getBool("narration") ?? false;

  static Future<bool> shouldDarkMode() async => (await storage).getBool("darkMode") ?? false;

  static Future<bool> shouldSosMorseFlash() async => (await storage).getBool("sosMorseFlash") ?? false;

  static Future<bool> shouldMorseCode() async => (await storage).getBool("morseCode") ?? false;

  static Future<bool> shouldReducedNetorkUsage() async => (await storage).getBool("reducedNetwork") ?? false;
}
