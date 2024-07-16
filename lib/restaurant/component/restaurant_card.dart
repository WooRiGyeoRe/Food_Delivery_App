import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/colors.dart';
import 'package:flutter_actual/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_actual/restaurant/model/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final Widget image; // 이미지 통째로 위젯에 넣을 거임
  final String name; // 레스토랑 이름
  final List<String> tags; // 레스토랑 태그들
  final int ratingsCount; // 평점 갯수
  final int deliveryTime; // 배송걸리는 시간
  final int deliveryFee; // 배송 비용
  final double ratings; // 평균 평점
  final bool isDetail; // 상세 카드 여부
  final String?
      detail; // 상세 내용 (detail isDetail이 false일 때 null일 수도 있으니까 물음표 추가)

  const RestaurantCard(
      {required this.image,
      required this.name,
      required this.tags,
      required this.ratingsCount,
      required this.deliveryTime,
      required this.deliveryFee,
      required this.ratings,
      this.isDetail = false,
      this.detail,
      super.key});

  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(
        model.thumbUrl,
        fit: BoxFit.cover,
      ),
      name: model.name,
      tags: model.tags,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      // model이 RestaurantDetailModel이면 model.detail을 넣어주고, 아니면 null
      detail: model is RestaurantDetailModel ? model.detail : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 만약 isDetail이 true면 => ClipRRect 구현 X
        if (isDetail) image,
        if (!isDetail) // isDetail이 false일 때만 ClipRRect 구현
          // ClipRRect => 테두리 깎기
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0), // 깎을 양, 모양
            child: image, // 깎을 것
          ),
        const SizedBox(height: 16),
        Padding(
          // isDetail이면 좌우 16 아니면 0
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 16 : 0),
          child: Column(
            // 왼쪽 정렬
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 외부에서 받은 final String name; 레스토랑 이름을 Text 위젯에 넣어 작업 가능해짐.
              // 레스토랑 이름
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              // 태그들
              Text(
                tags.join(' · '), // ( ) 이 안에는 합칠 때 넣고 싶은 문자 작성
                style: const TextStyle(
                  color: BODY_TEXT_COLOR,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _IconText(
                    icon: Icons.star,
                    label: ratings.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.receipt,
                    label: ratingsCount.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.timelapse_outlined,
                    label: '$deliveryTime 분',
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.timelapse_outlined,
                    label: deliveryFee == 0 ? '무료' : deliveryFee.toString(),
                  ),
                ],
              ),
              if (detail != null && isDetail)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(detail!),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget renderDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '·',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon; // 아이콘
  final String label; // 글자

  const _IconText({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_COLOR,
          size: 14,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
