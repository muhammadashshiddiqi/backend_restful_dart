class ResponseWrapper {
  int statusCode;
  String? message;
  List? data;

  ResponseWrapper(
      {required this.statusCode, this.message, this.data});

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'message': message,
        'data': data,
      };
}
