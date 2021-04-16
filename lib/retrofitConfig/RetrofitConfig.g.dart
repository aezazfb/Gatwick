// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RetrofitConfig.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RetrofitConfig implements RetrofitConfig {
  _RetrofitConfig(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'http://testing.thedivor.com';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<List<BookingModel>> getBookingDetails(email) async {
    ArgumentError.checkNotNull(email, 'email');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'email': email};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/api/API/GetBooking',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => BookingModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<CfgCustAppModel>> getCfgCustApp(office) async {
    ArgumentError.checkNotNull(office, 'office');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'office': office};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/api/API/CfgCustApp',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => CfgCustAppModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<String> insertBooking(bookingModel) async {
    ArgumentError.checkNotNull(bookingModel, 'bookingModel');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(bookingModel?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<String>('/api/API/InsertBooking',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<ResponseModel> signupCustomerRegistration(customerModel) async {
    ArgumentError.checkNotNull(customerModel, 'customerModel');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(customerModel?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        '/api/API/CustomerSignUp',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ResponseModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<String> loginCustomer(email_or_number, pass, check) async {
    ArgumentError.checkNotNull(email_or_number, 'email_or_number');
    ArgumentError.checkNotNull(pass, 'pass');
    ArgumentError.checkNotNull(check, 'check');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'id': email_or_number,
      r'pass': pass,
      r'check': check
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<String>('/api/API/CustomerLogin',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }
}
