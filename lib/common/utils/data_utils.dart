import 'package:flutter_actual/common/const/data.dart';

class DataUtils {
  // 이 class에 공통적으로 쓰는
  // static pathToUrl(String value) 메소드들을 다 정리하기!
  static pathToUrl(String value) {
    return 'http://$ip$value';
  }
}
