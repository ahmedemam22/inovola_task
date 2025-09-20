import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  final String? result;
  final String? message;
  final T? data;
  final String? errorType;
  final bool isSuccess;

  BaseResponse({
    this.result,
    this.message,
    this.data,
    this.errorType,
    this.isSuccess = false,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);

  // Factory for successful response
  factory BaseResponse.success(T data, {String? message}) {
    return BaseResponse<T>(
      result: 'success',
      message: message,
      data: data,
      isSuccess: true,
    );
  }

  // Factory for error response
  factory BaseResponse.error(String message, {String? errorType}) {
    return BaseResponse<T>(
      result: 'error',
      message: message,
      errorType: errorType,
      isSuccess: false,
    );
  }

  // Factory for currency API response
  factory BaseResponse.fromCurrencyApi(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    final result = json['result'] as String?;
    final isSuccess = result == 'success';
    
    if (isSuccess) {
      return BaseResponse<T>(
        result: result,
        data: fromJsonT(json),
        isSuccess: true,
      );
    } else {
      return BaseResponse<T>(
        result: result,
        message: 'API Error',
        errorType: json['error-type'] as String?,
        isSuccess: false,
      );
    }
  }

  @override
  String toString() {
    return 'BaseResponse(result: $result, isSuccess: $isSuccess, message: $message)';
  }
}
