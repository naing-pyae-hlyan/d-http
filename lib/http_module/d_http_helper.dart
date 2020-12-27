import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'd_htttp_response.dart';

enum DHttpMethod {
  POST,
  PUT,
  GET,
  DELETE,
}

class DHttpHeaderTypes {
  static const applicationJson = 'application/json';
  static const multipartFormData = 'multipart/from-data';
  static const xAuthorization = 'x-authorization';
}

const defaultJsonHeaders = {
  HttpHeaders.contentTypeHeader: DHttpHeaderTypes.applicationJson,
  HttpHeaders.acceptHeader: DHttpHeaderTypes.applicationJson,
};

const Duration defaultTimeoutDuration = const Duration(seconds: 30);

class DHttpServices {
  static Future<DHttpResponse> post({
    final ValueChanged<DHttpResponse> onResponse,
    final VoidCallback onTimeout,
    final VoidCallback onConnectionError,
    @required String tag,
    @required String url,
    final Map<String, String> headers = defaultJsonHeaders,
    final dynamic body,
    final Duration timeoutDuration = defaultTimeoutDuration,
  }) async {
    try {
      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(timeoutDuration, onTimeout: () {
        printDebugLog(
          tag,
          '\nRequest URL: $url'
          '\nRequest Method: ${DHttpMethod.POST}'
          '\nRequest Headers: ${headers?.toString()}'
          '\nRequest Body: $body'
          '\nRequest Timeout: $url',
        );

        if (onTimeout != null) {
          onTimeout();
        }
        return null;
      }).then((http.Response response) {
        printDebugLog(
          tag,
          '\nRequest URL: $url'
          '\nRequest Method: ${DHttpMethod.POST}'
          '\nRequest Headers: ${headers?.toString()}'
          '\nRequest Body: $body'
          '\nResponse Code: ${response?.statusCode}'
          '\nResponse Body: ${response?.body}',
        );
        if (onResponse != null) {
          onResponse(DHttpResponse(
            status: HttpResponseStatus.OK,
            response: response,
          ));
        }
        return response;
      });

      if (response == null) {
        return DHttpResponse(status: HttpResponseStatus.TIME_OUT);
      }

      return DHttpResponse(
        status: HttpResponseStatus.OK,
        response: response,
      );
    } on SocketException catch (_) {
      if (onConnectionError != null) {
        onConnectionError();
      }

      return DHttpResponse(status: HttpResponseStatus.CONNECTION_ERROR);
    }
  }

  static Future<DHttpStreamedResponse> postFormData({
    final ValueChanged<DHttpStreamedResponse> onResponse,
    final VoidCallback onTimeout,
    final VoidCallback onNoInternet,
    @required final String tag,
    @required final String url,
    final Map<String, String> headers = defaultJsonHeaders,
    final Map<String, String> params,
    final String key,
    final List<String> filePaths,
    final Duration timeoutDuration = defaultTimeoutDuration,
  }) async {
    var request = http.MultipartRequest(
      DHttpMethod.POST.toString(),
      Uri.parse(url),
    );

    request.headers.addAll(headers);

    if (params != null && params.isNotEmpty && params.length > 0) {
      params.forEach((key, value) {
        request.fields[key] = value;
      });
    }

    if (filePaths != null && filePaths.isNotEmpty && filePaths.length > 0) {
      for (String path in filePaths) {
        if (path != null && path.isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath(
            key,
            path,
            filename: path.split('/').last,
            contentType: MediaType('application', 'x-tar'),
          ));
        }
      }
    }

    try {
      final response = await request.send().timeout(
        timeoutDuration,
        onTimeout: () {
          printDebugLog(
            tag,
            '\nRequest URL: $url'
            '\nRequest Method: ${DHttpMethod.POST}'
            '\nRequest Headers: $headers'
            '\nRequest Key: $key'
            '\nRequest Files: ${filePaths?.toString()}'
            '\nRequest Body: ${params?.toString()}'
            '\nRequest Timeout: $url',
          );

          if (onTimeout != null) {
            onTimeout();
          }

          return null;
        },
      ).then((http.StreamedResponse response) {
        printDebugLog(
          tag,
          '\nRequest URL: $url'
          '\nRequest Method: ${DHttpMethod.POST}'
          '\nRequest Headers: $headers'
          '\nRequest Key: $key'
          '\nRequest Files: ${filePaths?.toString()}'
          '\nRequest Body: ${params?.toString()}'
          '\nResponse Code: ${response?.statusCode}'
          '\nResponse Body: ${response?.toString()}',
        );

        if (onResponse != null) {
          onResponse(DHttpStreamedResponse(
            status: HttpResponseStatus.OK,
            response: response,
          ));
        }

        return response;
      });

      if (response == null) {
        return DHttpStreamedResponse(status: HttpResponseStatus.TIME_OUT);
      }

      return DHttpStreamedResponse(
        status: HttpResponseStatus.OK,
        response: response,
      );
    } on SocketException catch (_) {
      if (onNoInternet != null) {
        onNoInternet();
      }

      return DHttpStreamedResponse(status: HttpResponseStatus.CONNECTION_ERROR);
    }
  }

  static Future<DHttpResponse> put({
    final ValueChanged<DHttpResponse> onResponse,
    final VoidCallback onTimeout,
    final VoidCallback onNoInternet,
    @required final String tag,
    @required final String url,
    final Map<String, String> headers = defaultJsonHeaders,
    final dynamic body,
    final Duration timeoutDuration =  defaultTimeoutDuration,
  }) async {
    try {
      final response =
          await http.put(url, headers: headers, body: body).timeout(
        timeoutDuration,
        onTimeout: () {
          printDebugLog(
            tag,
            '\nRequest URL: $url'
            '\nRequest Method: ${DHttpMethod.PUT}'
            '\nRequest Headers: ${headers?.toString()}'
            '\nRequest Body: $body'
            '\nRequest Timeout: $url',
          );

          if (onTimeout != null) {
            onTimeout();
          }

          return null;
        },
      ).then((http.Response response) {
        printDebugLog(
          tag,
          '\nRequest URL: $url'
          '\nRequest Method: ${DHttpMethod.PUT}'
          '\nRequest Headers: ${headers?.toString()}'
          '\nRequest Body: $body'
          '\nResponse Code: ${response?.statusCode}'
          '\nResponse Body: ${response?.body}',
        );

        if (onResponse != null) {
          onResponse(DHttpResponse(
            status: HttpResponseStatus.OK,
            response: response,
          ));
        }

        return response;
      });

      if (response == null) {
        return DHttpResponse(status: HttpResponseStatus.TIME_OUT);
      }

      return DHttpResponse(
        status: HttpResponseStatus.OK,
        response: response,
      );
    } on SocketException catch (_) {
      if (onNoInternet != null) {
        onNoInternet();
      }

      return DHttpResponse(status: HttpResponseStatus.CONNECTION_ERROR);
    }
  }

  static Future<DHttpResponse> get({
    final ValueChanged<DHttpResponse> onResponse,
    final VoidCallback onTimeout,
    final VoidCallback onNoInternet,
    @required final String tag,
    @required final String url,
    final Map<String, String> headers = defaultJsonHeaders,
    final Map<String, String> params,
    final Duration timeoutDuration = defaultTimeoutDuration,
  }) async {
    String fullUrl = url;

    if (params != null && params.isNotEmpty && params.length > 0) {
      fullUrl += '?';
      params.forEach((key, value) {
        if (fullUrl[fullUrl.length - 1] != '?') {
          fullUrl += '&';
        }
        fullUrl += key + '=' + value;
      });
    }

    try {
      final response = await http.get(fullUrl, headers: headers).timeout(
        timeoutDuration,
        onTimeout: () {
          printDebugLog(
            tag,
            '\nRequest URL: $fullUrl'
            '\nRequest Method: ${DHttpMethod.GET}'
            '\nRequest Headers: ${headers?.toString()}'
            '\nRequest Params: ${params?.toString()}'
            '\nRequest Timeout: $fullUrl',
          );

          if (onTimeout != null) {
            onTimeout();
          }

          return null;
        },
      ).then((http.Response response) {
        printDebugLog(
          tag,
          '\nRequest URL: $fullUrl'
          '\nRequest Method: ${DHttpMethod.GET}'
          '\nRequest Headers: ${headers?.toString()}'
          '\nRequest Params: ${params?.toString()}'
          '\nResponse Code: ${response?.statusCode}'
          '\nResponse Body: ${response?.body}',
        );

        if (onResponse != null) {
          onResponse(DHttpResponse(
            status: HttpResponseStatus.OK,
            response: response,
          ));
        }

        return response;
      });

      if (response == null) {
        return DHttpResponse(status: HttpResponseStatus.TIME_OUT);
      }

      return DHttpResponse(
        status: HttpResponseStatus.OK,
        response: response,
      );
    } on SocketException catch (_) {
      if (onNoInternet != null) {
        onNoInternet();
      }

      return DHttpResponse(status: HttpResponseStatus.CONNECTION_ERROR);
    }
  }

  static Future<DHttpResponse> delete({
    final ValueChanged<DHttpResponse> onResponse,
    final VoidCallback onTimeout,
    final VoidCallback onNoInternet,
    @required final String tag,
    @required final String url,
    final Map<String, String> headers = defaultJsonHeaders,
    final dynamic body,
    final Duration timeoutDuration = defaultTimeoutDuration,
  }) async {
    try {
      final response = await http
          .delete(url, headers: headers)
          .timeout(timeoutDuration, onTimeout: () {
        printDebugLog(
          tag,
          '\nRequest URL: $url'
          '\nRequest Method: ${DHttpMethod.DELETE}'
          '\nRequest Headers: ${headers?.toString()}'
          '\nRequest Body: $body'
          '\nRequest Timeout: $url',
        );

        if (onTimeout != null) {
          onTimeout();
        }

        return null;
      }).then((http.Response response) {
        printDebugLog(
          tag,
          '\nRequest URL: $url'
          '\nRequest Method: ${DHttpMethod.DELETE}'
          '\nRequest Headers: ${headers?.toString()}'
          '\nRequest Body: $body'
          '\nResponse Code: ${response?.statusCode}'
          '\nResponse Body: ${response?.body}',
        );

        if (onResponse != null) {
          onResponse(DHttpResponse(
            status: HttpResponseStatus.OK,
            response: response,
          ));
        }

        return response;
      });

      if (response == null) {
        return DHttpResponse(status: HttpResponseStatus.TIME_OUT);
      }

      return DHttpResponse(
        status: HttpResponseStatus.OK,
        response: response,
      );
    } on SocketException catch (_) {
      if (onNoInternet != null) {
        onNoInternet();
      }

      return DHttpResponse(status: HttpResponseStatus.CONNECTION_ERROR);
    }
  }

  static void printDebugLog(String tag, String msg) {
    if (kReleaseMode) {
      return;
    }
    log('$tag : $msg');
  }
}
