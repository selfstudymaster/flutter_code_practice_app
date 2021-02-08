import 'package:flutter/material.dart'; // マテリアルデザイン

// mainからMyApp
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ステートレスはビルドメソッドを持つ
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaterialAppのtitle:プロパティ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FirstPage')),
      body: Center(
        child: RaisedButton(
          // ボタン押下でpushする
          onPressed: () {
            // 新しいルートに遷移する
            // Navigator.popを呼び出すと自動的に画面左上にも戻るアイコンが追加される
            Navigator.push(
              context,
              // 画面遷移アニメーションがなされるMaterialPageRoute
              // 引数にMaterialPageRouteインスタンスを渡し、builderプロパティで遷移したいウィジェットを指定
              MaterialPageRoute(builder: (context) {
                return SecondPage();
              }
                  //モーダル遷移にしたい時に下記一行を追記
                  // fullscreenDialog: true
                  ),
            );
          },
          // ボタン内のテキスト
          child: Text('Next Page'),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(
        child: RaisedButton(
          // ボタン押下でpopする
          onPressed: () {
            // 元のルートに戻る
            Navigator.pop(context);
          },
          // ボタン内のテキスト
          child: Text('Go Back'),
        ),
      ),
    );
  }
}
