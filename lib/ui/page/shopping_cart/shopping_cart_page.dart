import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_taobao/common/data/shopping_cart.dart';
import 'package:flutter_taobao/common/model/conversation.dart';
import 'package:flutter_taobao/common/model/shopping_cart.dart';
import 'package:flutter_taobao/common/style/gzx_style.dart';
import 'package:flutter_taobao/common/utils/common_utils.dart';
import 'package:flutter_taobao/common/utils/screen_util.dart';
import 'package:flutter_taobao/ui/widget/gzx_checkbox.dart';
import 'package:flutter_taobao/ui/widget/gzx_shopping_cart_item.dart';
import 'package:flutter_taobao/ui/widget/pull_load/ListState.dart';
import 'package:flutter_taobao/ui/widget/pull_load/PullLoadWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage>
    with
        AutomaticKeepAliveClientMixin<ShoppingCartPage>,
        ListState<ShoppingCartPage>,
        WidgetsBindingObserver {
  static const Color _backgroundColor = Color(0xFFf3f3f3);
  Gradient _mainGradient =
      const LinearGradient(colors: [_backgroundColor, _backgroundColor]);
  bool _isAllSelected = false;

  GlobalKey _keyFilter = GlobalKey();
  double _firstItemHeight = 0;

  _afterLayout(_) {
    _getPositions('_keyFilter', _keyFilter);
    _getSizes('_keyFilter', _keyFilter);
  }

  _getPositions(log, GlobalKey globalKey) {
    RenderBox renderBoxRed = globalKey.currentContext.findRenderObject();
    var positionRed = renderBoxRed.localToGlobal(Offset.zero);
    print("POSITION of $log: $positionRed ");
  }

  _getSizes(log, GlobalKey globalKey) {
    RenderBox renderBoxRed = globalKey.currentContext.findRenderObject();
    var sizeRed = renderBoxRed.size;
    print("SIZE of $log: $sizeRed");

    setState(() {
      _firstItemHeight = sizeRed.height;
    });
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
//      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    }
    super.didChangeAppLifecycleState(state);
  }

  ///build
  @override
  Widget build(BuildContext context) {
    super.build(context); // 如果不加这句，从子页面回来会重新加载didChangeDependencies()方法

    ///添加或减少
    var firstItemWidget = GZXShoppingCarItemWidget(
      shoppingCartModels[0],
      color: Colors.transparent,
      addTap: (orderModel) {
        if (orderModel.quantity + 1 > orderModel.amountPurchasing) {
          Fluttertoast.showToast(
              msg: '该宝贝不能购买更多哦', gravity: ToastGravity.CENTER);
        } else {
          setState(() {
            orderModel.quantity++;
          });
        }
      },
      removeTap: (orderModel) {
        if (orderModel.quantity == 1) {
          Fluttertoast.showToast(
              msg: '受不了了，宝贝不能再减少了哦', gravity: ToastGravity.CENTER);
        } else {
          setState(() {
            orderModel.quantity--;
          });
        }
      },
      onSelectAllChanged: (value) {
        setState(() {
          shoppingCartModels[0].isSelected = value;
          shoppingCartModels[0].orderModels.forEach((item) {
            item.isSelected = value;
          });
        });
      },
      onSelectChanged: (orderModel, value) {
        setState(() {
          orderModel.isSelected = value;
        });
      },
    );

    var testWidget =
        Container(color: Colors.red, key: _keyFilter, child: firstItemWidget);

    ///刷新控件
    var pullLoadWidget = PullLoadWidget(
      pullLoadWidgetControl,
      (BuildContext context, int index) {
        ShoppingCartModel shoppingCartModel =
            pullLoadWidgetControl.dataList[index];
        print('$index');

        if (index == 0) {
          return Container(
              color: _backgroundColor,
              height: _firstItemHeight + 48 + ScreenUtil.statusBarHeight + 20,
              child: TopItem(
                  topBarOpacity: _topBarOpacity,
                  contentWidgetHeight: _firstItemHeight,
                  contentWidget: Container(
                      child: GZXShoppingCarItemWidget(
                    shoppingCartModels[0],
                    color: Colors.transparent,
                    ///增加
                    addTap: (orderModel) {
                      if (orderModel.quantity + 1 >
                          orderModel.amountPurchasing) {
                        Fluttertoast.showToast(
                            msg: '该宝贝不能购买更多哦', gravity: ToastGravity.CENTER);
                      } else {
                        setState(() {
                          orderModel.quantity++;
                        });
                      }
                    },
                        ///减少
                    removeTap: (orderModel) {
                      if (orderModel.quantity == 1) {
                        Fluttertoast.showToast(
                            msg: '受不了了，宝贝不能再减少了哦',
                            gravity: ToastGravity.CENTER);
                      } else {
                        setState(() {
                          orderModel.quantity--;
                        });
                      }
                    },
                        ///全选
                    onSelectAllChanged: (value) {
                      setState(() {
                        shoppingCartModels[0].isSelected = value;
                        shoppingCartModels[0].orderModels.forEach((item) {
                          item.isSelected = value;
                        });
                      });
                    },
                    onSelectChanged: (orderModel, value) {
                      setState(() {
                        orderModel.isSelected = value;
                      });
                    },
                  ))));
        } else {
          return GZXShoppingCarItemWidget(
            shoppingCartModel,
            addTap: (orderModel) {
              if (orderModel.quantity + 1 > orderModel.amountPurchasing) {
                Fluttertoast.showToast(
                    msg: '该宝贝不能购买更多哦', gravity: ToastGravity.CENTER);
              } else {
                setState(() {
                  orderModel.quantity++;
                });
              }
            },
            removeTap: (orderModel) {
              if (orderModel.quantity == 1) {
                Fluttertoast.showToast(
                    msg: '受不了了，宝贝不能再减少了哦', gravity: ToastGravity.CENTER);
              } else {
                setState(() {
                  orderModel.quantity--;
                });
              }
            },
            onSelectAllChanged: (value) {
              setState(() {
                shoppingCartModel.isSelected = value;
                shoppingCartModel.orderModels.forEach((item) {
                  item.isSelected = value;
                });
              });
            },
            onSelectChanged: (orderModel, value) {
              setState(() {
                orderModel.isSelected = value;
              });
            },
          );
        }
      },
      handleRefresh,
      onLoadMore,
      refreshKey: refreshIndicatorKey,
    );

    // see https://github.com/flutter/flutter/issues/14842
    var body = Container(
      decoration: BoxDecoration(
        gradient: _mainGradient,
      ),
      child: MediaQuery.removePadding(
        removeTop: true,
        child: NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: Scrollbar(
                child: Stack(
              children: <Widget>[
                Container(
                  child: pullLoadWidget,
                ),
                Offstage(
                  offstage: !_isShowFloatingTopBar,
                  child: Container(
                    decoration:
                        BoxDecoration(gradient: GZXColors.primaryGradient),
                    height: 48 + ScreenUtil.statusBarHeight,
                    width: ScreenUtil.screenWidth,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: ScreenUtil.statusBarHeight,
                        ),
                        Container(
                          height: 48,
                          child: _buildFloatingTopBar(),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ))),
        context: context,
      ),
    );

    double totalAmount = 0;
    ///选中的数量
    int settlementCount = 0;
    for (var value1 in shoppingCartModels) {
      for (var value in value1.orderModels) {
        if (value.isSelected) {
          totalAmount += value.price * value.quantity;
          settlementCount++;
        }
      }
    }

    ///build
    return SafeArea(
      child: Column(
        children: <Widget>[
          Offstage(
            child: testWidget,
            offstage: true,
          ),
          Expanded(
            child: body,
          ),
          ///底部
          Container(
            height: 44,
            decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Color(0xFFededed), width: .3)),
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: GZXCheckbox(
                    value: _isAllSelected,
                    onChanged: (value) {
                      setState(() {
                        _isAllSelected = value;
                        ///全选
                        shoppingCartModels.forEach((item) {
                          item.isSelected = value;
                          item.orderModels.forEach((i) {
                            i.isSelected = value;
                          });
                        });
                      });
                    },
                    spacing: 6,
                    descriptionWidget: Text(
                      '全选',
                      style: TextStyle(color: Color(0xFF666666), fontSize: 12),
                    ),
                  ),
                ),
                totalAmount == 0
                    ? Container()
                    : Text(
                        '已包邮',
                        style: TextStyle(color: Color(0xFF666666), fontSize: 9),
                      ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '合计:',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '￥',
                  style: TextStyle(fontSize: 10, color: Color(0xFFff5410)),
                ),
                Text(
                  '${CommonUtils.removeDecimalZeroFormat(totalAmount)}',
                  style: TextStyle(fontSize: 14, color: Color(0xFFff5410)),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  height: 36,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: GZXColors.primaryGradient,
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Text(
                    '结算($settlementCount)',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          )
        ],
      ),
      top: false,
    );
  }

  Widget _buildFloatingTopBar({int productNum = 0}) {
    var list =
        shoppingCartModels.map((item) => item.orderModels.length).toList();
    var count = list.reduce((value, element) {
      print('reduce $value  $element}');
      return value + element;
    });
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              GestureDetector(
                  child: Text(
                '管理',
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
              SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
        Center(
          child: Text(
            count == 0 ? '购物车' : '购物车($count)',
            textAlign: TextAlign.center,
            style: GZXConstant.appBarTitleWhiteTextStyle,
          ),
        ),
      ],
    );
  }

  double _lastScrollPixels = 0;
  bool _isShowFloatingTopBar = false;
  double _topBarOpacity = 1;

  bool _onScroll(ScrollNotification scroll) {
//    if (notification is! ScrollNotification) {
//      // 如果不是滚动事件，直接返回
//      return false;
//    }

//    ScrollNotification scroll = notification as ScrollNotification;
    if (scroll.metrics.axisDirection == AxisDirection.down) {
//      print('down');
    } else if (scroll.metrics.axisDirection == AxisDirection.up) {
//      print('up');
    }
    // 当前滑动距离
    double currentExtent = scroll.metrics.pixels;
    double maxExtent = scroll.metrics.maxScrollExtent;

    print('当前滑动距离 $currentExtent ${currentExtent - _lastScrollPixels}');

    //向下滚动
    if (currentExtent - _lastScrollPixels > 0) {
      if (currentExtent >= 0 && _mainGradient == GZXColors.primaryGradient) {
        setState(() {
          _mainGradient =
              const LinearGradient(colors: [Colors.white, Colors.white]);
        });
      }
      if (currentExtent <= 20) {
        setState(() {
          double opacity = 1 - currentExtent / 20;
          _topBarOpacity = opacity > 1 ? 1 : opacity;
//          if(_topBarOpacity<0.1){
//          }
        });

        print('向下滚动 $currentExtent=>$_topBarOpacity');
      } else {
        if (!_isShowFloatingTopBar) {
          setState(() {
            _isShowFloatingTopBar = true;
          });
        }
      }
    }

    //往上滚动
    if (currentExtent - _lastScrollPixels < 0) {
      if (currentExtent < 0 && _mainGradient != GZXColors.primaryGradient) {
        setState(() {
          _mainGradient = GZXColors.primaryGradient;
        });
      }
      if (currentExtent <= 20) {
        setState(() {
          double opacity = 1 - currentExtent / 20;
          _topBarOpacity = opacity > 1 ? 1 : opacity;
//          if(_topBarOpacity>0.9){
          _isShowFloatingTopBar = false;
//          }
        });
        print('往上滚动 $currentExtent=>$_topBarOpacity');
      } else {}
    }

    _lastScrollPixels = currentExtent;

//    if (maxExtent - currentExtent > widget.startLoadMoreOffset) {
//      // 开始加载更多
//
//    }

    // 返回false，继续向上传递,返回true则不再向上传递
    return false;
  }

  @override
  bool get isRefreshFirst => false;

  // 只会执行一次initState()
  @override
  bool get wantKeepAlive => true;

  @override
  Future<Null> handleRefresh() async {
//    setState(() {
//      _mainGradient = const LinearGradient(colors: [Colors.white, Colors.white]);
//    });
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
////    mockConversation.clear();
//    mockConversation.addAll(preConversation);
////    _conversationControlModel.clear();
    await getIndexListData(page);
    setState(() {
      pullLoadWidgetControl.needLoadMore = false;
    });
    isLoading = false;

    return null;
  }

  // 紧跟在initState之后调用
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  ///加载更多
  @override
  Future<Null> onLoadMore() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page++;
    await getIndexListData(page);
    setState(() {
      // 3次加载数据
      pullLoadWidgetControl.needLoadMore =
          (mockConversation != null && mockConversation.length < 25);
    });
    isLoading = false;
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);

    WidgetsBinding.instance.addObserver(this);

    pullLoadWidgetControl.dataList = shoppingCartModels;
//    getIndexListData(1);
    setState(() {pullLoadWidgetControl.needLoadMore = false;});
    // getIndexListData(1);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  ///加载数据
  getIndexListData(page) async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        pullLoadWidgetControl.dataList = shoppingCartModels;
      });
    } catch (e) {
      print(e);
    }
  }
}

class TopItem extends StatelessWidget {
  final bool isShowFloatingTopBar;
  final double topBarOpacity;
  final int productNum;
  final Widget contentWidget;
  final double contentWidgetHeight;
  double _topBarHeight = 48;

  TopItem(
      {Key key,
      this.isShowFloatingTopBar = false,
      this.topBarOpacity = 1,
      this.productNum = 0,
      this.contentWidget,
      this.contentWidgetHeight})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: <Widget>[
      Container(
        child: Container(
          decoration: new BoxDecoration(
            gradient: GZXColors.primaryGradient,
          ),
          width: ScreenUtil.screenWidth,
          height: ScreenUtil.screenHeight / 4,
        ),
      ),
      Opacity(
        opacity: topBarOpacity,
        child: Container(
          height: _topBarHeight,
          margin: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
          child: _buildTopBar(),
        ),
      ),
      Positioned(
          top: _topBarHeight + ScreenUtil.statusBarHeight,
          child: Opacity(
            opacity: topBarOpacity,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 8,
                ),
                Text(
                  '共$productNum件宝贝',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          )),
      Positioned(
          top: _topBarHeight + ScreenUtil.statusBarHeight + 30,
          height: contentWidgetHeight,
          width: ScreenUtil.screenWidth,
          child: contentWidget)
    ]));
  }

  Widget _buildTopBar() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            '购物车',
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        GestureDetector(
            onTap: () {
            },
            child: Text(
              '管理',
              style: TextStyle(
                color: Colors.white,
              ),
            )),
        SizedBox(
          width: 8,
        ),
      ],
    );
  }
}
