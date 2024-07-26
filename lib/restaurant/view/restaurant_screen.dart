import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_actual/common/dio/dio.dart';
import 'package:flutter_actual/common/model/cursor_pagination_model.dart';
import 'package:flutter_actual/restaurant/component/restaurant_card.dart';
import 'package:flutter_actual/restaurant/model/restaurant_model.dart';
import 'package:flutter_actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // <List>를 사용해 어떤 값이 들어오는지 확인
          child: FutureBuilder<CursorPagination<RestaurantModel>>(
            future: ref.watch(restaurantRepositoryProvider).paginate(),
            builder: (context,
                AsyncSnapshot<CursorPagination<RestaurantModel>> snapshot) {
              // 만약 snapshot에 data가 없으면
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // data가 있으면 ListView를 리턴
              return ListView.separated(
                // itemCount에는 몇 개의 아이템을 넣을 건지
                itemCount: snapshot.data!.data.length,
                // itemBuilder는 index를 받아서 각 아이템별로 렌더링
                itemBuilder: (_, index) {
                  // 아이템 저장
                  final pItem = snapshot.data!.data[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RestaurantDetailScreen(
                            id: pItem.id,
                          ),
                        ),
                      );
                    },
                    child: RestaurantCard.fromModel(model: pItem),
                  );
                },
                // separatorBuilder => 각 아이템 사이사이에 들어가는 거를 빌드
                separatorBuilder: (_, index) {
                  return const SizedBox(
                    height: 16,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
