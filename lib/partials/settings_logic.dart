class Settings {
  static Map<String, Object> _config = {
    // true, false, auto (system-based)
    "Dark Mode": "false",
    "Notification": true,

    "Storage Usage": {
      "MB Send"
    }
  
  };

  

  static Map<String, String> getConfig() {
    return _config;
  }
}
