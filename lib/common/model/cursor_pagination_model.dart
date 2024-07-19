import 'package:flutter_actual/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

// d. @JsonSerializable()에 파라미터 추가
@JsonSerializable(
  genericArgumentFactories: true,
) //  4. @JsonSerializable() 달아주기
// 1. CursorPagination 클래스 만들기
class CursorPagination<T> {
  // a. 외부에서 T라는 타입을 받는다
  // 5.
  final CursorPaginationMeta meta;
  final List<T> data; // b. 그 타입을 받아 List에 넣어준다

  CursorPagination({
    required this.meta,
    required this.data,
  });

  // 6. factory constructor 생성 후,
  // flutter pub run build_runner build watch
  factory CursorPagination.fromJson(
          // c.  T Function(Object? json) fromJsonT , fromJsonT 추가
          Map<String, dynamic> json,
          T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable() // 4. @JsonSerializable() 달아주기
// 2. CursorPaginationMeta 클래스 만들기
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  // 3. factory constructor 생성
  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}
