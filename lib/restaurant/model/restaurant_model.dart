// priceRange는 3가지 값이 있음.
// 따로 enum으로 만들어주겠음.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart'; // part + '현재 파일 이름 + .g + .dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
class RestaurantModel {
  final String id;
  final String name;
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryFee;
  final int deliveryTime;

  // ★ 모델을 생성할 때(인스턴스화 할 때) 무조건 이 값들은 파라미터에 넣어줘야 함!
  // 위에 값들을 인스턴스화 할 때 파라미터로 값을
  // 꼭 넣어줘야 되게 하기 위해서 required this. 해주기
  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryFee,
    required this.deliveryTime,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  // factory RestaurantModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantModel(
  //       id: json['id'],
  //       name: json['name'],
  //       thumbUrl: 'http://$ip${json['thumbUrl']}',
  //       tags: List<String>.from(json['tags']),
  //       priceRange: RestaurantPriceRange.values
  //           .firstWhere((e) => e.name == json['priceRange']),
  //       ratings: json['ratings'],
  //       ratingsCount: json['ratingsCount'],
  //       deliveryFee: json['deliveryFee'],
  //       deliveryTime: json['deliveryTime']);
  // }
}
