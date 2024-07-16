import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget?
      bottomNavigationBar; // 물음표를 쓴 이유 => bottomNavigationBar 사용 안 하는 곳도 있으니까
  final Widget? floatingActionButton;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar, // bottomNavigationBar 외부에서 받도록 여기에 정의
    this.floatingActionButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      // 하단에 탭 만들기
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  // 물음표 => null 가능
  AppBar? renderAppBar() {
    // 타이틀이 입력 안 됐을 때
    if (title == null) {
      return null;
    } else {
      // 타이틀이 입력됐을 때
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title!, // 느낌표 => 절대로 null이 될 수 없다
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
