import 'package:dio/dio.dart';
import 'package:flutter_actual/common/const/data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  // 스토리지에 넣어주기
  CustomInterceptor({
    required this.storage,
  });

// 1) 요청을 보낼 때
// 요청이 보내질 때마다
// 만약에 요청의 Header에 accessToken: true 라는 값이 있다면,
// 실제 토큰을 storage에서 가져와서
// authorization : Bearer $token으로 Header를 변경
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 이때 method는 get, post, delete를 의미
    print('[REQ] [${options.method}] ${options.uri}');

    // headers = 실제 요청의 헤더 => @Headers({'accessToken': 'true'}, )
    // headers에서 accessToken이란 값이 true라면 accessToken이라는 키를 삭제!
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      // 그리고 진짜 토큰으로 바꿔주기
      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      // 토큰을 가져왔다면 어떻게 넣어야 할까?
      //return super.onRequest(options, handler);
      options.headers.addAll({'authorization': 'Bearer $token'});

      return super.onRequest(options, handler); // handler.next(options); 반드시 호출
    }

// 2) 응답을 받을 때

// 3) 에러가 났을 때
  }
}
