// ignore_for_file: unused_element

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/colors.dart';
import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_actual/common/layout/default_layout.dart';
import 'package:flutter_actual/common/secure_storage/secure_storage.dart';
import 'package:flutter_actual/common/view/root_tab.dart';
import 'package:flutter_actual/user/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // deleteToken();
    checkToken();
  }

  void deleteToken() async {
    final storage = ref.read(secureStorageProvider);

    await storage.deleteAll();
  }

  // initState()에서는 await 불가능!
  // await storage.read(key: REFRESH_TOKEN_KEY);
  // await storage.read(key: ACCESS_TOKEN_KEY);

  // 함수를 만들어서 쓰자! -> 이제 스토리지로부터 토큰 가져올 수 있음
  void checkToken() async {
    final storage = ref.read(secureStorageProvider);

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final dio = Dio();

    try {
      final resp = await dio.post(
        'http://$ip/auth/token',
        options: Options(
          headers: {
            'authorization': 'Bearer $refreshToken',
          },
        ),
      );

      // 토큰 저장
      await storage.write(
          key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      // 에러 발생 X (정상일 때) => RootTab 으로
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const RootTab(),
        ),
        (route) => false,
      );
    } catch (e) {
      // 에러 발생 시 => LoginScreen으로
      print('=====================');
      print(e);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const Text(
              'Food Order App',
              style: TextStyle(
                  fontFamily: 'NotoSans',
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
