import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

import '../models/BookingModel.dart';

part 'RetrofitConfig.g.dart';

@RestApi(baseUrl:"http://testing.thedivor.com")
abstract class RetrofitConfig {
  factory RetrofitConfig(Dio dio, {String baseUrl}) = _RetrofitConfig;

  @GET("/api/API/GetBooking")
  Future<List<BookingModel>> getBookingDetails(@Query('email') String email);

}
