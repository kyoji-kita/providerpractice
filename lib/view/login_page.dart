import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:providerpractice/provider/provider.dart';
import 'package:providerpractice/view/index_page.dart';

import '../repositry/auth_repositry.dart';
import 'login_model.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginModel(
        AuthRepository(),
      ),
      child: LoginApp(),
    );
  }
}

class LoginApp extends StatelessWidget {
  final _formKey = GlobalKey<FormState>(); // 入力フォーム

  @override
  Widget build(BuildContext context) {

    //追記
    final BuildContext context2 = context;

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'UserId',
                    hintText: 'ユーザIDを入力してください',
                  ),
                  validator: context.read<LoginModel>().emptyValidator, // 入力チェック
                  onSaved: (value) => context.read<LoginModel>().id = value!, // save() 時に同期
        ),
                TextFormField(
                  obscureText: !context.watch<LoginModel>().showPassword, // パスワード表示状態を監視(watch)
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'パスワードを入力してください',
                    suffixIcon: IconButton(
                      icon: Icon(context.watch<LoginModel>().showPassword // パスワード表示状態を監視(watch)
                          ? FontAwesomeIcons.solidEye
                          : FontAwesomeIcons.solidEyeSlash),
                      onPressed: () =>
                          context.read<LoginModel>().togglePasswordVisible(), // パスワード表示・非表示をトグルする
                    ),
                  ),
                  validator: context.read<LoginModel>().emptyValidator, // 入力チェック
                  onSaved: (value) =>
                  context.read<LoginModel>().password = value!,
                ),
                Container( // エラー文言表示エリア
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                  child: Text(
                    context.watch<LoginModel>().message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () async { // ログインボタンアクション
                        context.read<LoginModel>().setMessage(''); // エラーメッセージを空に

                        if (_formKey.currentState!.validate()) { // 入力チェック
                          _formKey.currentState!.save(); // 入力チェックOK -> フォームの値を同期する

                          var response =
                          await context.read<LoginModel>().auth();
                          print('auth response = $response');

                          if (response) {
                            Navigator.push( // 画面遷移
                              context,
                              MaterialPageRoute(
                                builder: (context) => IndexPage(),
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar( // SnackBar表示
                              SnackBar(
                                content: Text('ログインしました'),
                              ),
                            );
                          } else {
                            context
                                .read<LoginModel>()
                                .setMessage('パスワードが誤っています'); // エラーメッセージセット
                          }
                        }
                      },
                      child: const Text('ログイン'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
