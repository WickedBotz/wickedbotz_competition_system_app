import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future get({required String url, Map<String, String>? headers});
}


class HttpClient implements IHttpClient {
  final client = http.Client();

  @override
  Future<http.Response> get({required String url, Map<String, String>? headers}) async {
    return await client.get(Uri.parse(url), headers: headers);
  }
}