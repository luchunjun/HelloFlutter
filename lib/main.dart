
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'PicModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World',
      theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.brown),
      home: MyHomePage(
          title: 'HelloWorld',
          hint: 'You have pushed the button this many times:'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.hint}) : super(key: key);
  final String title;
  final String hint;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PicModel> picList = new List();
  int page = 1;

  @override
  void initState() {
    super.initState();
    _getPicList();
  }

  _getPicList() async {
   // String url = 'https://www.apiopen.top/meituApi?page=$page';
    String url = 'http://gank.io/api/data/福利/10/$page';
    //http://gank.io/api/data/福利/10/1
    var httpClient = new HttpClient();
    try {
      var req = await httpClient.getUrl(Uri.parse(url));
      var res = await req.close();
      // print(res);
      if (res.statusCode == HttpStatus.OK) {
        var jsonString = await res.transform(utf8.decoder).join(); //将结果转换成字符串拼接
       //  print(jsonString);
        Map data = jsonDecode(jsonString); //格式化成Map对象
        List pics = data['results'];
        List<PicModel> items = new List();
        for (var value in pics) {
            items.add(new PicModel(
                value['createdAt'], value['publishedAt'], value['type'],
                value['url'], value['desc']));

        }
        setState(() {
         picList.addAll(items);
         page++;
        });
      }
    } catch (e) {}
  }
  buildItem(item) {
    //print(item.desc);
    return new GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                new Scaffold(
                  appBar: new AppBar(
                    title: new Text(item.desc),
                  ),
                  body: new Center(
                      child: new Container(
                        width: 500.0,
                        child: new CachedNetworkImage(
                          imageUrl: item.url,
                          fit: BoxFit.fitWidth,
                        ),

                      )
                  ),
                )
            )
        );
      },
      child: new CachedNetworkImage(
        errorWidget: new Icon(Icons.error),
        imageUrl: item.url,
        fadeInDuration: new Duration(seconds: 1),
        fadeOutDuration: new Duration(seconds: 1),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('美图'),
        centerTitle: true,
      ),
      body: new GridView.builder(
        padding: const EdgeInsets.all(1.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 1.0,
          crossAxisSpacing:1.0,
          childAspectRatio: 1.0
        ),
        itemCount: picList.length,
        itemBuilder: (BuildContext context, int index) {
          if(index == picList.length - 1 ){
            _getPicList();
          }
          return buildItem(picList[index]);
        },
      ),
    );
  }
  }
