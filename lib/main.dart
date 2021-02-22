import 'dart:convert'; // JSOnのデコードとエンコード

import 'package:flutter/material.dart'; // マテリアルデザイン
import 'package:http/http.dart' as http; // http

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'APIアプリ'),
    );
  }
}

// 本来ならevent_list_viewに切り分ける
class MyHomePage extends StatefulWidget {
  MyHomePage(Key key, this.title) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _controller = TextEditingController();

  var _repository = new ConnpassRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              _searchInput(),
              _searchCount(),
              _searchResult(),
            ],
          ),
        ),
    );
  }

  // ListViewの_searchInput()
  Widget _searchInput() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(),
              controller: _controller,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
          child: RaisedButton(
            child: const Text('search'),
            onPressed: _search,
          ),
        ),
      ],
    );
  }

  void _search() {
    _getRepository(_controller.text).then((repository){
      setState(() {
        _repository = repository;
      });
    });
  }

  // API呼び出す
  Future<ConnpassRepository> _getRepository(String searchWord) async {
    final response = await http.get(
      'https://connpass.com/api/v1/event/?count=100&order=1&kewword=' + searchWord);
    if (response.statusCode == 200) {
      final parsed = json,decode(response.body).cast<String, dynamic>();
      ConnpassRepository repository = ConnpassRepository.fromJson(parsed);
      return repository;
    } else {
      throw Exception('Fail to search repository');
    }
  }

  // ListViewの_searchCount()に検索結果件数に合わせた表示を設定
  Widget _searchCount() {
    if (_repository.resultsReturned == null) {
      return Container();
    } else if (_repository.resultsReturned < 100) {
      return Padding(
        padding: EdgeInsets.all(12),
        child: Text('検索結果は ${_repository.resultsReturned.toString()} 件です'),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(12),
        child: Text('件数が多すぎるので上限の100件を表示しています'),
      );
    }
  }

  // ListViewの_searchResult()を設定
  Widget _searchResult() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        if(_repository.events != null) {
          final EventRepository event = repository.events[index];
          return _resultCard(event);
        } else {
          return null;
        }
      },
      itemCount: _repository.resultsReturned,
    );
  }

  // Detail()に代入して、Detailクラスを別途下に書いていく
  Widget _resultCard(EventRepository eventRepository) {}
}

// 画面遷移の練習
// // mainからMyApp
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // ステートレスはビルドメソッドを持つ
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MaterialAppのtitle:プロパティ',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: FirstPage(),
//     );
//   }
// }
//
// class FirstPage extends StatelessWidget {
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('FirstPage')),
//       body: Center(
//         child: RaisedButton(
//           // ボタン押下でpushする
//           onPressed: () {
//             // 新しいルートに遷移する
//             // Navigator.popを呼び出すと自動的に画面左上にも戻るアイコンが追加される
//             Navigator.push(
//               context,
//               // 画面遷移アニメーションがなされるMaterialPageRoute
//               // 引数にMaterialPageRouteインスタンスを渡し、builderプロパティで遷移したいウィジェットを指定
//               MaterialPageRoute(builder: (context) {
//                 return SecondPage();
//               }
//                   //モーダル遷移にしたい時に下記一行を追記
//                   // fullscreenDialog: true
//                   ),
//             );
//           },
//           // ボタン内のテキスト
//           child: Text('Next Page'),
//         ),
//       ),
//     );
//   }
// }
//
// class SecondPage extends StatelessWidget {
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Second Page')),
//       body: Center(
//         child: RaisedButton(
//           // ボタン押下でpopする
//           onPressed: () {
//             // 元のルートに戻る
//             Navigator.pop(context);
//           },
//           // ボタン内のテキスト
//           child: Text('Go Back'),
//         ),
//       ),
//     );
//   }
// }
