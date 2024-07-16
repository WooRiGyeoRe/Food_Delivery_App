import 'package:flutter/material.dart';
import 'package:flutter_actual/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  // 파라미터
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String?> onChanged;

  const CustomTextFormField(
      {super.key,
      this.hintText,
      this.errorText,
      this.obscureText = false,
      this.autofocus = false,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(color: INPUT_BORDER_COLOR, width: 1.0),
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      // 비밀번호 입력할 때
      obscureText: obscureText,
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(color: BODY_TEXT_COLOR, fontSize: 14),
        fillColor: INPUT_BG_COLOR,
        filled: true, // false - 배경색 없음, true - 배경색 있음
        border: baseBorder, // 모든 Input 상태의 기본 스타일 세팅
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color:
                PRIMARY_COLOR, // copyWith 자주 쓰일 예정 -> color만 변경해서 그대로 borderSide에 넣겠다
          ),
        ),
      ),
    );
  }
}
