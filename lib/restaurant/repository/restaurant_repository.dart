import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_actual/common/model/cursor_pagination_model.dart';
import 'package:flutter_actual/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_actual/restaurant/model/restaurant_model.dart';
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  // http://$ip/restaurant 까지만 일반화 할 거임!
  // 그 뒤에 나머지 공통되지 않은 부분만 따로 입력
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // http://$ip/restaurant/
  @GET('/')
  @Headers(
    {'accessToken': 'true'},
  )
  Future<CursorPagination<RestaurantModel>> paginate();

  // http://$ip/restaurant/:id/
  @GET('/{id}')
  @Headers(
    {'accessToken': 'true'},
  )
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
