import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_actual/common/component/custom_text_form_field.dart';
import 'package:flutter_actual/common/const/colors.dart';
import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_actual/common/layout/default_layout.dart';
import 'package:flutter_actual/common/view/root_tab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = ''; // '' => 아무 것도 없는 값
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio(); // 로그인, 회원가입 2번 사용하니까 위로 빼줌!

    return DefaultLayout(
      child: SingleChildScrollView(
        child: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _Title(),
                    const SizedBox(height: 16),
                    const _SubTitle(),
                    Image.asset(
                      'asset/img/misc/logo.png',
                      width: MediaQuery.of(context).size.width / 3 * 2,
                    ),
                    CustomTextFormField(
                      hintText: '이메일을 입력해주세요.',
                      // onChanged -> TextField에 값이 들어갈 때마다 (String value) {  } 콜백이 불림
                      // 여기서 value는 실제 입력한 값
                      onChanged: (String? value) {
                        setState(() {
                          if (value != null && value.isNotEmpty) {
                            username = value;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      hintText: '비밀번호를 입력해주세요.',
                      onChanged: (String? value) {
                        setState(() {
                          if (value != null && value.isNotEmpty) {
                            password = value;
                          }
                        });
                      },
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      // 비동기로 요청하므로 async -> await 작성도 잊지말자!
                      onPressed: () async {
                        // 토큰 생성=> ID:비밀번호
                        //const rawString = 'test@test.ai:test';
                        final rawString = '$username:$password';
                        print(rawString);

                        // 토큰 Base64 인코딩
                        Codec<String, String> stringToBase64 =
                            utf8.fuse(base64);

                        // 사용하기
                        String token = stringToBase64.encode(rawString);

                        // dio선언 후, dio. 하면 http 요청 메소드들이 나옴
                        final resp = await dio.post(
                          'http://$ip/auth/login',
                          options: Options(
                            headers: {'authorization': 'Basic $token'},
                          ),
                        );
                        print('===========');
                        print(resp.statusCode); // 응답 코드 확인
                        print(resp.data); // 응답 데이터 확인

                        final refreshToken = resp.data['refreshToken'];
                        final accessToken = resp.data['accessToken'];

                        await storage.write(
                            key: REFRESH_TOKEN_KEY, value: refreshToken);
                        await storage.write(
                            key: ACCESS_TOKEN_KEY, value: accessToken);

                        // 에러가 발생하지 않았다면 잘 넘어갈 거임!
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RootTab(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      child: const Text(
                        '로그인',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {},
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.black),

                      //style: ElevatedButton.styleFrom(
                      //backgroundColor: PRIMARY_COLOR,
                      //),
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 메인 타이틀
class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

// 서브 타이틀
class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요. \n오늘도 성공적인 주문이 되길 :)', // \n -> 개행
      style: TextStyle(fontSize: 16, color: BODY_TEXT_COLOR),
    );
  }
}
