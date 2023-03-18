class Response {
  int code;
  String status;
  String? message;
  List? data;

  Response({required this.code, required this.status, this.message, this.data});

  Map<String, dynamic> toJson() => {
    'code': code,
    'status': status,
    'message': message,
    'data': data,
  };
}
