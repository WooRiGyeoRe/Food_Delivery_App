import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_actual/common/const/colors.dart';
import 'package:flutter_actual/common/layout/default_layout.dart';
import 'package:flutter_actual/restaurant/view/restaurant_screen.dart';

// index의 변경으로 StatelessWidget에서 StatefulWidget으로 수정해주기
class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  // TabController? controller; 해줘도 되지만,
  // initState()에서 무조건 선언되므로 late 키워드 사용
  late TabController controller;

  // index 저장
  int index = 0; // 처음엔 홈이니까 0

  // initState 무조건 먼저 실행되는 구간
  @override
  void initState() {
    super.initState();

    // length = children에 넣은 값의 개수(리스트의 길이)
    // vsync는 렌더링 엔진에서 필요한 것으로
    // controller를 선언하는 현재 State를 넣어주면 됨!
    // 그런데 this가 특정 기능을 가지고 있어야 함! => Single Ticker Provider State Mixin
    controller = TabController(length: 4, vsync: this);

    // addListener => 값이 변경될 때마다 특정 변수를 실행해라
    controller.addListener(tabListener);
  }

  // 컨트롤러의 인덱스를 이 인덱스에다가 계속 넣어줌
  // 그리고 매번 이 컨트롤러에서 변화가 있을 때마다 setState를 실행
  // controller에서 매번 속성들이 바뀔 때마다 tabListener 함수가 실행됨
  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  // 앱 재실행 시, 다시 홈에서 시작
  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '겨구미 딜리버리',
      bottomNavigationBar: BottomNavigationBar(
        // BottomNavigationBar 사용시 items 필수 입력!
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed, // shifting 선택된 탭 확대 효과
        backgroundColor: Colors.white,
        // onTap은 함수를 넣어줘야 함!
        // 이때, int index인 이유 => 클릭한 탭의 인덱스에 숫자가 들어가니까!
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '프로필',
          ),
        ],
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          RestaurantScreen(),
          Center(child: Text('음식')),
          Center(child: Text('주문')),
          Center(child: Text('프로필')),
        ],
      ),
    );
  }
}
