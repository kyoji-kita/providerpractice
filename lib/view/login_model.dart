import 'package:flutter/cupertino.dart';

import '../repositry/auth_repositry.dart';

class LoginModel extends ChangeNotifier{
  late final AuthRepository repositry;
  String id = '';
  String password = '';
  String message = '';
  bool showPassword = false; //パスワードを平文で表示する

  LoginModel (this.repositry);

  void setMessage(String value) { //エラーメッセージ設定
    message = value;
    notifyListeners();
  }

void togglePasswordVisible() { //パスワード表示切り替え
  showPassword = !showPassword;
  notifyListeners();
}

  String? emptyValidator(String? value) { //必須入力チェック
    if (value == null || value.isEmpty) {
      return '入力してください';
    }
    return null;
  }

  Future<bool> auth() async {
    print("id: $id, password: $password");
    var results = await repositry.auth();
    return results;
  }
}

