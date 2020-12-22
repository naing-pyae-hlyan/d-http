import 'package:http/http.dart' as http;

enum HttpResponseStatus {
  OK,
  TIME_OUT,
  CONNECTION_ERROR,
}

class DHttpResponse {
  DHttpResponse({this.status, this.response});

  HttpResponseStatus status;
  http.Response response;
}

class DHttpStreamedResponse {
  DHttpStreamedResponse({this.status, this.response});
  HttpResponseStatus status;
  http.StreamedResponse response;
}
