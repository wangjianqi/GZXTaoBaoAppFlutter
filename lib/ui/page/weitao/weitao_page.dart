import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_taobao/common/model/image.dart';
import 'package:flutter_taobao/common/model/post.dart';
import 'package:flutter_taobao/common/model/search.dart';
import 'package:flutter_taobao/common/services/meinv.dart';
import 'package:flutter_taobao/common/services/search.dart';
import 'package:flutter_taobao/common/style/gzx_style.dart';
import 'package:flutter_taobao/common/utils/screen_util.dart';
import 'package:flutter_taobao/ui/page/weitao/weitao_list_page.dart';

class WeiTaoPage extends StatefulWidget {
  @override
  _WeiTaoPageState createState() => _WeiTaoPageState();
}

class _WeiTaoPageState extends State<WeiTaoPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<WeiTaoPage> {
  List<PostModel> _postModels = [];
  final postController = StreamController<List<PostModel>>();
  Stream<List<PostModel>> get postItems => postController.stream;

  List _imageCounts = [3, 6, 9];
  List _tabsTitle = [
    '关注',
    '上新',
    '新势力',
    '精选',
    '晒单',
    '时尚',
    '美食',
    '潮sir',
    '生活',
    '明星',
    '品牌'
  ];
  List _topBackgroundImages = [
    '',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558082136524&di=feacbe2ef8a99d19665e04c4b72d2842&imgtype=0&src=http%3A%2F%2Fi1.17173cdn.com%2F2fhnvk%2FYWxqaGBf%2Foutcms%2FmCkIBAbjpEyscFv.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083021447&di=b4d0e0cf24df095303532b2156f995bf&imgtype=0&src=http%3A%2F%2Fp3.pstatp.com%2Flarge%2F109000019f50509ab65',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083021447&di=d7a90850b12b9fe07a4024be742c9dbc&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201603%2F13%2F20160313134239_5WNxA.png',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083412736&di=8fcd16ece63f60c53231e34d7d707564&imgtype=0&src=http%3A%2F%2Fs14.sinaimg.cn%2Fmw690%2F002Y7b5tgy6PyTRlDOZbd%26690',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083463426&di=7f4563d244f278746a8b52b712af1c19&imgtype=0&src=http%3A%2F%2Fs6.sinaimg.cn%2Fmiddle%2F97478a17hc9637acee3c5%26690',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083503297&di=10680297f182bdaa5c5039a0b8693626&imgtype=0&src=http%3A%2F%2Fs1.sinaimg.cn%2Fmw690%2F001LVQHHty6OK05256E70%26690',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083515575&di=d0399c0e4cce6b34e87b1ec2afdcf0e8&imgtype=0&src=http%3A%2F%2Fs6.sinaimg.cn%2Fmw690%2F00330iyazy7cdZAuidD85%26690',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1558073507&di=1e791bf6640d622d8dd26a0f2bba9529&src=http://s16.sinaimg.cn/mw690/4a6e5f25tx6C9p5o4i31f&690',
    'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1611177969,3782045888&fm=26&gp=0.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083648898&di=ce8d7033d1b0ea161fe96ce5ff8b0dac&imgtype=0&src=http%3A%2F%2Fs4.sinaimg.cn%2Fmw600%2F002BHBRBzy6QSpE2Oxlab%26690'
  ];

  static double _topBarDefaultTop = ScreenUtil.statusBarHeight;

  double _topBarHeight = 48;
  double _topBarTop = _topBarDefaultTop;
  static double _tabControllerDefaultTop = ScreenUtil.statusBarHeight + 48;
  double _tabControllerTop = _tabControllerDefaultTop;
  double _tabBarHeight = 48;
  double _topBackgroundHeight = ScreenUtil.screenHeight / 4;
  static double _topBackgroundDefaultTop = 0;
  double _topBackgroundTop = _topBackgroundDefaultTop;
  int _selectedTabBarIndex = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: _tabsTitle.length);
    _tabController.addListener(_handleTabSelection);

    _getDynamic();
  }

  void _getDynamic() async {
    List querys = await getHotSugs();
    for (var value in querys) {
      PostModel postModel = PostModel(
          name: value,
          logoImage:
              'https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2094939883,1219286755&fm=179&app=42&f=PNG?w=121&h=140',
          address: '999万粉丝',
          message: '',
          messageImage:
              'https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D220/sign=a70945e5c51349547a1eef66664f92dd/fd039245d688d43f7e426c96731ed21b0ff43bef.jpg',
          readCout: _randomCount(),
          isLike: false,
          likesCount: _randomCount(),
          commentsCount: _randomCount(),
          postTime: '${_randomCount()}粉丝',
          photos: []);
      _postModels.add(postModel);
      print('_postModels.length ' + _postModels.length.toString());

      _getMessage(value.toString()).then((value) {
        print('postModel.message ${value}');

        setState(() {
          postModel.message = value.wareName;
          postModel.logoImage = value.imageUrl;
        });
      });

      _getPhotos(value.toString()).then((value) {
        setState(() {
          postModel.photos = value.map((item) => item.thumb).toList();
        });
      });

      ///添加数据
      postController.add(_postModels);
    }
  }

  Future<List<ImageModel>> _getPhotos(keyword) async {
    var data = await getGirlList(keyword);
    List images = data.map((i) => ImageModel.fromJSON(i)).toList();
    return images
        .take(_imageCounts[Random().nextInt(_imageCounts.length)])
        .toList();
  }

  Future<SearchResultItemModal> _getMessage(String keyword) async {
    var data = await getSearchResult(keyword, 0);
    SearchResultListModal list = SearchResultListModal.fromJson(data);
    return list.data.first;
  }

  int _randomCount() {
    return Random().nextInt(1000);
  }

  @override
  void dispose() {
    postController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    var firstTopBackgroundWidget = Container(
        decoration: new BoxDecoration(
          gradient:
              const LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
        ),
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight / 4);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedPositioned(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 500),
            left: 0,
            top: _topBackgroundTop,
            child:
                _topBackgroundImages[_selectedTabBarIndex].toString().length ==
                        0
                    ? firstTopBackgroundWidget
                    : CachedNetworkImage(
                        fadeInDuration: Duration(milliseconds: 0),
                        fadeOutDuration: Duration(milliseconds: 0),
                        placeholder: (context, url) {
                          return _selectedTabBarIndex == 1
                              ? firstTopBackgroundWidget
                              : CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 0),
                                  fadeOutDuration: Duration(milliseconds: 0),
                                  imageUrl: _topBackgroundImages[
                                      _selectedTabBarIndex - 1],
                                  width: ScreenUtil.screenWidth,
                                  height: ScreenUtil.screenHeight / 4,
                                  fit: BoxFit.fill);
                        },
                        imageUrl: _topBackgroundImages[_selectedTabBarIndex],
                        width: ScreenUtil.screenWidth,
                        height: ScreenUtil.screenHeight / 4,
                        fit: BoxFit.fill,
                      ),
          ),
          AnimatedPositioned(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 500),
            left: 0,
            top: _topBarTop,
            width: ScreenUtil.screenWidth,
            child: Container(
              height: _topBarHeight,
              child: _buildTopBar(),
            ),
          ),
          AnimatedPositioned(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 500),
            top: _tabControllerTop,
            left: 0,
            width: ScreenUtil.screenWidth,
            height: ScreenUtil.screenHeight - (ScreenUtil.screenHeight / 4) / 2,
            child: Container(
              child: DefaultTabController(
                  length: _tabsTitle.length, child: _buildContentWidget()),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContentWidget() {
    return Column(
      children: <Widget>[
        Container(
          height: _tabBarHeight,
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 14),
              onTap: (i) {},
              tabs: _tabsTitle
                  .map((i) => Text(
                        i,
                      ))
                  .toList()),
        ),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: _tabsTitle.map((value) {
            return WeiTaoListPage(
              onNotification: _onScroll,
            );
          }).toList(),
        ))
      ],
    );
  }

  _handleTabSelection() {
    print('_handleTabSelection:${_tabController.index}');
    if (_selectedTabBarIndex == _tabController.index) {
      return;
    }
    setState(() {
      _selectedTabBarIndex = _tabController.index;
    });
  }

  double _lastScrollPixels = 0;

  bool _onScroll(ScrollNotification scroll) {
//    if (notification is! ScrollNotification) {
//      // 如果不是滚动事件，直接返回
//      return false;
//    }

    if (scroll.metrics.axisDirection == AxisDirection.down) {
//      print('down');
    } else if (scroll.metrics.axisDirection == AxisDirection.up) {
//      print('up');
    }
    // 当前滑动距离
    double currentExtent = scroll.metrics.pixels;
    double maxExtent = scroll.metrics.maxScrollExtent;
    //向下滚动
    if (currentExtent - _lastScrollPixels > 0 &&
        _topBarTop > 0 &&
        currentExtent > 0) {
      print('hide');
      setState(() {
        _topBarTop = -_topBarHeight;
        _tabControllerTop = _topBarDefaultTop;
        _topBackgroundTop =
            -(_topBackgroundHeight - _tabBarHeight - _tabControllerTop);
      });
    }

    //向上滚动
    if (currentExtent - _lastScrollPixels < 0 &&
        _topBarTop < 0 &&
        currentExtent.toInt() <= 0) {
      print('show');
      setState(() {
        _topBackgroundTop = 0;
        _topBarTop = _topBarDefaultTop;
        _tabControllerTop = _tabControllerDefaultTop;
      });
    }

    _lastScrollPixels = currentExtent;
    // 返回false，继续向上传递,返回true则不再向上传递
    return false;
  }

  ///顶部tabBar
  Widget _buildTopBar() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            '微淘',
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        GestureDetector(
          child: Icon(
            GZXIcons.search_light,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 16,
        ),
        GestureDetector(
          child: Icon(GZXIcons.people_list_light, color: Colors.white),
        ),
        SizedBox(
          width: 8,
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
