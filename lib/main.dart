import 'dart:convert'; // JSOnのデコードとエンコード

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'; // マテリアルデザイン
import 'package:flutter_code_practice_app/model/connpass_model.dart';
import 'package:flutter_code_practice_app/model/event_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_http_request.dart'; // http
// import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
  MyHomePage({Key key, this.title}) : super(key: key);

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
    _getRepository(_controller.text).then((repository) {
      setState(() {
        _repository = repository;
      });
    });
  }

  // API呼び出す
  Future<ConnpassRepository> _getRepository(String searchWord) async {
    final response = await http.get(
        'https://connpass.com/api/v1/event/?count=100&order=1&kewword=' +
            searchWord);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<String, dynamic>();
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
        if (_repository.events != null) {
          final EventRepository event = _repository.events[index];
          return _resultCard(event);
        } else {
          return null;
        }
      },
      itemCount: _repository.resultsReturned,
    );
  }

  // Detail()に代入して、Detailクラスを別途下に書いていく
  Widget _resultCard(EventRepository eventRepository) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Detail(event: eventRepository),
              ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(eventRepository.title),
            ),
          ],
        ),
      ),
    );
  }
}

// _resultCard()のMaterialPageRoute()内のDetail()
class Detail extends StatelessWidget {
  final EventRepository event;
  Detail({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('イベント詳細'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            titleSection(),
            detailSection(),
          ],
        ),
      ),
    );
  }

  Widget thumbnailSection() {
    return Container();
  }

  Widget titleSection() {
    return Container(
      padding: EdgeInsets.all(28),
      child: Column(
        children: [
          Text(
            event.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            event.catchMessage,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget detailSection() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildDetail(),
          buildUrlLink(),
        ],
      ),
    );
  }

  Widget buildDetail() {
    Map<String, String> detailMap = {
      '開催日時': changeTimeFormat(event.startedAt),
      '終了日時': changeTimeFormat(event.endedAt),
    };
    return Container(child: buildDetailRow(detailMap));
  }

  Widget buildDetailRow(Map<String, String> detailMap) {
    List<Widget> detailList = [];
    detailMap.forEach((key, value) {
      detailList.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Text(key == null ? '' : key),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text(value == null ? '' : value),
            ),
          ),
        ],
      ));
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: detailList,
    );
  }

  Widget buildUrlLink() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
      width: double.infinity,
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: [
            TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              text: '公式サイトは',
            ),
            TextSpan(
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                text: 'こちらから',
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await launch(
                      event.eventUrl,
                      forceWebView: true,
                      forceSafariVC: true,
                    );
                  })
          ],
        ),
      ),
    );
  }

  String changeTimeFormat(String before) {
    initializeDateFormatting('', "ja_JP");

    DateTime datetime = DateTime.parse(before);
    var formatter = new DateFormat('yyyy年MM月dd日HH時mm分', "ja_JP");
    var formatted = formatter.format(datetime);
    return formatted;
  }
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
