import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future<http.Response> get({required String url, Map<String, String>? headers});
  Future<http.Response> post({required String url, Map<String, String>? headers, dynamic body});
}

class HttpClient implements IHttpClient {
  final client = http.Client();

  @override
  Future<http.Response> get({required String url, Map<String, String>? headers}) async {
    return await client.get(Uri.parse(url), headers: headers);
  }

  @override
  Future<http.Response> post({required String url, Map<String, String>? headers, dynamic body}) async {
    return await client.post(Uri.parse(url), headers: headers, body: body);
  }
}
