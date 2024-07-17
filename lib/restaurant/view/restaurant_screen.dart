import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_actual/restaurant/component/restaurant_card.dart';
import 'package:flutter_actual/restaurant/model/restaurant_model.dart';
import 'package:flutter_actual/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );
    // return resp.data를 하면 실제 바디 가져올 수 있음!
    // 그런데 내가 가져오고 싶은 값은?
    // data라는 키 안에 있는 값들만 반환할 거임!! -> 그래야 List 값을 가져올 수 있기에...
    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // <List>를 사용해 어떤 값이 들어오는지 확인
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              // 만약 snapshot에 data가 없으면
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // data가 있으면 ListView를 리턴
              return ListView.separated(
                // itemCount에는 몇 개의 아이템을 넣을 건지
                itemCount: snapshot.data!.length,
                // itemBuilder는 index를 받아서 각 아이템별로 렌더링
                itemBuilder: (_, index) {
                  // 아이템 저장
                  final item = snapshot.data![index];
                  final pItem = RestaurantModel.fromJson(item);

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
