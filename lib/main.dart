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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return SecondPage();
              }),
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
            Navigator.pop(context);
          },
          // ボタン内のテキスト
          child: Text('Go Back'),
        ),
      ),
    );
  }
}
