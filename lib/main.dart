import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_taobao/common/style/gzx_style.dart';
import 'package:flutter_taobao/ui/page/gzx_bottom_navigation_bar.dart';

import 'common/utils/provider.dart';
import 'common/utils/shared_preferences.dart';

SpUtil sp;
var db;

void main() async {
  final provider = new Provider();
  ///初始化数据库
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: GZXColors.primarySwatch,
      ),
      home: GZXBottomNavigationBar(),
    );
  }
}
