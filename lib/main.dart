import 'package:flutter/material.dart';
import 'package:flutter_actual/common/view/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_actual/user/login_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Actual App',
      theme: ThemeData(
        fontFamily: 'NotoSans',
        //primarySwatch: Colors.blue,
        //visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // 시작 화면 설정
    );
  }
}
