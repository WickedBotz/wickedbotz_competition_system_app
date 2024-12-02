class Env{
  static const Map<String, String> _keys = {
    'API_URL': String.fromEnvironment('API_URL'),
  };

  static String _getKeys(String key){
    final value = _keys[key] ?? '';
    if(value.isEmpty){
      throw Exception(
        '$key is not set in Env'
      );
    }
    return value;
  }

  static String get API_URL => _getKeys('API_URL');
}