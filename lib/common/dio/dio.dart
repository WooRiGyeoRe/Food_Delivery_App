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

      return super.onRequest(options, handler);
    }
    return handler.next(options); // handler.next(options); 반드시 호출
  }

// 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    return handler.next(response); // 반드시 호출
  }

// 3) 에러가 났을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러 발생 시(statue code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을 함

    // 프린트로 어떤 요청, 어떤 URL의 요청에서 에러가 났는지 확인
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    // 3)-1. refreshToken 가져오기
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // 3)-2. 가져왔는데 refreshToken이 아예 없으면 에러를 던진다
    if (refreshToken == null) {
      // 에러를 던질 때는 handler.reject 사용(dio 룰임)
      return handler.reject(err);
    }

    // 3)-3. 401 상태인지 확인
    // requestOptions => 요청의 모든 값을 가져올 수 있음
    // response => 응답의 모든 값을 가져올 수 있음
    // (응답이 없을 수도 있으니깐 물음표)
    // statusCode가 401이면 isStatus401는 true
    final isStatus401 = err.response?.statusCode == 401;

    // 3)-4. 에러가 난 요청이 토큰을 리프레시하려다 에러가 났는지를 확인
    // 여기서 true를 반환받으면 '/auth/token'에 accessToken을
    // 새로 발급받으려다 에러가 난 거라서 refreshToken 자체에 문제가 있다는 의미!
    // => 결국 새로 요청을 보내봤자 에러가 남...
    //    이럴 땐, 리젝트를 또 해줘야 함!
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    // 3)-5. isStatus401이 true고 isPathRefresh가 false면
    // (즉, 토큰을 새로 리프레시 하려는 의도가 아니었는데 401에러가 발생했다면)
    if (isStatus401 && !isPathRefresh) {
      // 3)-6. dio를 새로 생성하고, dio로 토큰 리프레시 요청
      final dio = Dio();

      // 3)-8. 그런데 resp에서 에러를 반환받았다면?
      // 에러를 잡아주자!
      // 어떤 이유든 여기서 에러가 나면,
      // 더이상 토큰을 리프레시할 수 있는 상황이 아님...
      try {
        // resp 요청을 보내면 dio로 post 요청을 보내서
        // auth/token에 refreshToken을 사용해서
        // 새로운 accessToken을 발급받을 수 있게 됨!
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        // 3)-7. 실제 accessToken 가져오기
        // 그럴려면 데이터에서 accessToken이라는 값을 가져와야 함!
        final accessToken = resp.data['accessToken'];

        // 3)-11. 만약 에러가 나지 않았다면?
        // requestOptions를 가져온다.
        final options = err.requestOptions;

        // 3)-12. accessToken 새로 넣어주기(토큰 변경하기)
        // 그럼 토큰을 넣을 수 있음.
        // 하지만 새로 토큰을 발급받았기 때문에
        // final FlutterSecureStorage storage 안에도 업데이트가 필요!
        options.headers.addAll(
          {
            'authorization': 'Bearer $accessToken',
          },
        );

        // 3)-13. final FlutterSecureStorage storage 업데이트
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 3)-14.원래 보냈던 요청 다시 보내기(요청 재전송)
        // 위에 생성해준 dio에 fetch 붙여주기
        // 그러면 (requestOptions)이 자동완성 되는데,
        // 이를 통해 실제 요청을 보낼 때 필요한 모든 값들은
        // requestOptions 안에 들어있는 걸 알 수 있음!
        // 3)-15. requestOptions에 그냥 options 넣기
        // 그러면 실제 err를 발생시킨 모든 요청과 관련된 옵션들을 다 받아서
        // 토큰만 바꾼 다음 다시 요청을 다시 보내는 것!
        final response = await dio.fetch(options);

        // 3)-16. final response = await dio.fetch(options); 이렇게
        // 응답이 오면 onError가 불렸지만, 실제로 반환해야 하는 값은
        // 응답(요청)이 잘 왔다고 await dio.fetch(options); 에서
        // 받은 응답을 다시 되돌려줘야 함!
        return handler.resolve(response); // handler.resolve => 요청이 잘 끝났다는 의미
      } on DioException catch (e) {
        // 3)-10. 그냥 catch에서 수정
        // on DioException catch (e)로 바꿔주면 (아래 reject도 e를 넣어줌)
        // 그냥 catch로 에러 전체를 잡아도 되지만,
        // 예상되는 건 DioError니까 이렇게 따로 잡으면 좀 더 합리적임

        // 3)-9. 더이상 토큰을 리프레시할 수 있는
        // 상황이 아니라면 그냥 에러를 던져줌.
        return handler.reject(e);
      }
    }
    return super.onError(err, handler); // 반드시 호출
  }
}
