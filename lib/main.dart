import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_taobao/common/style/gzx_style.dart';
import 'package:flutter_taobao/ui/page/drawer/gzx_filter_goods_page.dart';
import 'package:flutter_taobao/ui/page/gzx_bottom_navigation_bar.dart';
import 'package:flutter_taobao/ui/page/home/searchlist_page.dart';
import 'package:flutter_taobao/ui/page/test/AnimateExpanded.dart';
import 'package:flutter_taobao/ui/page/test/ExpansionList.dart';
import 'package:flutter_taobao/ui/page/test/SliverWithTabBar.dart';
import 'package:flutter_taobao/ui/page/test/act_page.dart';
import 'package:flutter_taobao/ui/page/test/gridview_height_page.dart';
import 'package:flutter_taobao/ui/page/test/gzx_dropdown_menu_test_page.dart';
import 'package:flutter_taobao/ui/page/test/my_home_page.dart';
import 'package:flutter_taobao/ui/page/test/scroll_page.dart';
import 'package:flutter_taobao/ui/page/test/scroll_page1.dart';
import 'package:flutter_taobao/ui/page/test/textfield_test_page.dart';

import 'common/utils/provider.dart';
import 'common/utils/shared_preferences.dart';

SpUtil sp;
var db;

void main() async {
  final provider = new Provider();
  await provider.init(true);
  sp = await SpUtil.getInstance();
  db = Provider.db;
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This ui.widget is the root of your application.
  @override
  Widget build(BuildContext context) {
//    int i = int.parse('84.99998982747397');
    double i = 84.99998982747397;

    print(i.toInt());

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: GZXColors.primarySwatch,
//        primaryColor: GZXColors.primarySwatch,
      ),
      home: GZXBottomNavigationBar(),
//    home:  SliverWithTabBar(),
//      home: GZXDropDownMenuTestPage(),
//    home: TextFieldTestPage(),
//    home: MyHomePage1(),
//    home: GridViewHeightPage(title: '',),
//    home: AnimateExpanded(),
//      home: GZXFilterGoodsPage(),
//      home: ScrollPage(),
//      home: ActPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This ui.widget is the home ui.page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App ui.widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout ui.widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout ui.widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each ui.widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
