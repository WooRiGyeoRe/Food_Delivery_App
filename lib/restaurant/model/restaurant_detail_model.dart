import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_actual/common/utils/data_utils.dart';
import 'package:flutter_actual/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

// 2. part 임포트하고 flutter pub run build_runner build
part 'restaurant_detail_model.g.dart';

// 1. @JsonSerializable()
@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail; // detail
  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryFee,
    required super.deliveryTime,
    required this.detail,
    required this.products,
  });

  // 3. .fromJson 주석처리
  // factory RestaurantDetailModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantDetailModel(
  //     id: json['id'],
  //     name: json['name'],
  //     thumbUrl: 'http://$ip${json['thumbUrl']}',
  //     tags: List<String>.from(json['tags']),
  //     priceRange: RestaurantPriceRange.values
  //         .firstWhere((e) => e.name == json['priceRange']),
  //     ratings: json['ratings'],
  //     ratingsCount: json['ratingsCount'],
  //     deliveryFee: json['deliveryFee'],
  //     deliveryTime: json['deliveryTime'],
  //     detail: json['detail'],
  //     products: json['products']
  //         .map<RestaurantProductModel>(
  //           (x) => RestaurantProductModel.fromJson(
  //             json: x,
  //           ),
  //         )
  //         .toList(),
  //   );
  // }

  // 4. factory constructor 작성
  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantDetailModelFromJson(json);
}

// 5. @JsonSerializable()
@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  // factory RestaurantProductModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantProductModel(
  //     id: json['id'],
  //     name: json['name'],
  //     imgUrl: 'http://$ip${json['imgUrl']}',
  //     detail: json['detail'],
  //     price: json['price'],
  //   );
  // }

  // 6. RestaurantProductModel도 fromJson을 해줘야 한다는 에러 고쳐주기
  factory RestaurantProductModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantProductModelFromJson(json);
}
