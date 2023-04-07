import 'dart:io';

final vr = _Variables._();

class _Variables {
  _Variables._();



  final headers = {
    HttpHeaders.accessControlAllowMethodsHeader: 'GET, POST, PUT, DELETE',
    HttpHeaders.accessControlAllowHeadersHeader: 'Origin, Content-Type',
    HttpHeaders.accessControlAllowOriginHeader: '*',
    HttpHeaders.accessControlRequestHeadersHeader: '*',
    HttpHeaders.accessControlRequestMethodHeader: '*',
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  final kSupportedLanguages = {
    'en',
    'id',
  };

}
