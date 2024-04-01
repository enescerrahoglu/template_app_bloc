class HttpResponseModel<T> {
  int? statusCode;
  T? data;
  String? message;

  HttpResponseModel({
    this.statusCode,
    this.data,
    this.message,
  });

  factory HttpResponseModel.fromJson(Map<String, dynamic> json) {
    return HttpResponseModel(
      statusCode: json['statusCode'],
      data: json['data'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data,
      'message': message,
    };
  }
}
