import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:zippy_rider/models/CfgCustAppModel.dart';

import '../models/BookingModel.dart';

part 'RetrofitConfig.g.dart';

@RestApi(baseUrl:"http://testing.thedivor.com")
abstract class RetrofitConfig {
  factory RetrofitConfig(Dio dio, {String baseUrl}) = _RetrofitConfig;

  //Booking History (Booked, Cancelled, Completed) Details
  @GET("/api/API/GetBooking")
  Future<List<BookingModel>> getBookingDetails(@Query('email') String email);

  //Configuration Customer at the start of the app - office(CYP)
  @GET("/api/API/CfgCustApp")
  Future<List<CfgCustAppModel>> getCgfCustApp(@Query('office') String office);

  @POST("/api/API/InsertBooking")
  Future<String> insertBooking(@Body() BookingModel bookingModel);
}
