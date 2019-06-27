import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taobao/common/model/image.dart';
import 'package:flutter_taobao/common/model/post.dart';
import 'package:flutter_taobao/common/model/search.dart';
import 'package:flutter_taobao/common/services/meinv.dart';
import 'package:flutter_taobao/common/services/search.dart';
import 'package:flutter_taobao/common/style/gzx_style.dart';

class WeiTaoListPage<T extends ScrollNotification> extends StatefulWidget {
  final NotificationListenerCallback<T> onNotification;

  const WeiTaoListPage({Key key, this.onNotification}) : super(key: key);

  @override
  _WeiTaoListPageState createState() => _WeiTaoListPageState();
}

class _WeiTaoListPageState extends State<WeiTaoListPage>
    with AutomaticKeepAliveClientMixin<WeiTaoListPage> {
  List<PostModel> _postModels = [];

  ///Profile
  Widget profileColumn(BuildContext context, PostModel post) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          post.logoImage == null || post.toString().length == 0
              ? Container()
              : CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: Image.network(
                    post.logoImage,
                    fit: BoxFit.fill,
                  ).image,
                ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  post.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  post.postTime,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .apply(color: Colors.grey),
                )
              ],
            ),
          ))
        ],
      );

  ///点赞和评论
  Widget actionColumn(PostModel post) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Text(
          '${post.readCout}万阅读',
          style: TextStyle(
            color: Colors.grey,
          ),
        )),
        GestureDetector(
          onTap: () {
            setState(() {
              ///点赞
              post.isLike = !post.isLike;
              if (post.isLike) {
                post.likesCount++;
              } else {
                post.likesCount--;
              }
            });
          },
          child: Row(
            children: <Widget>[
              Icon(
                post.isLike
                    ? GZXIcons.appreciate_fill_light
                    : GZXIcons.appreciate_light,
                color: post.isLike ? Colors.red : Colors.black,
              ),
              Text(
                post.likesCount.toString(),
                style:
                    TextStyle(color: post.isLike ? Colors.red : Colors.black),
              )
            ],
          ),
        ),
        SizedBox(
          width: 25,
        ),
        GestureDetector(
          onTap: () {
            ///评论
          },
          child: Row(
            children: <Widget>[
              Icon(
                GZXIcons.message,
                color: Colors.black,
              ),
              Text(
                post.commentsCount.toString(),
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        )
      ],
    );
  }

  ///图片
  Widget _buildPhotosWidget(PostModel post) {
    return GridView.builder(
        padding: const EdgeInsets.all(0),
        primary: false,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          crossAxisCount: 3,
        ),
        itemCount: post.photos.length,
        itemBuilder: (BuildContext context, int index) {
          var item = post.photos[index];
          return CachedNetworkImage(
            fadeInDuration: Duration(milliseconds: 0),
            fadeOutDuration: Duration(milliseconds: 0),
            imageUrl: item,
            fit: BoxFit.fill,
          );
        });
  }

  //post cards
  ///card
  Widget postCard(BuildContext context, PostModel post) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 0),
            child: profileColumn(context, post),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 0),
            child: Text(
              post.message,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 0),
            child: Stack(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: _buildPhotosWidget(post),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: actionColumn(post),
          ),
        ],
      ),
    );
  }

  //allposts dropdown
  Widget bottomBar() => PreferredSize(
      preferredSize: Size(double.infinity, 50.0),
      child: Container(
          color: Colors.black,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "All Posts",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          )));

  Widget appBar() => SliverAppBar(
        backgroundColor: Colors.black,
        elevation: 2.0,
        centerTitle: false,
        title: Text("Feed"),
        forceElevated: true,
        pinned: true,
        floating: true,
//        snap: false,
        bottom: bottomBar(),
      );

  Widget bodyList(List<PostModel> posts) => SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          if (index + 3 == posts.length) {
            print(
                'weitao,current data count ${posts.length},current index $index');
            _getDynamic();
          }
          return Padding(
            padding:
                const EdgeInsets.only(left: 6, top: 3, right: 6, bottom: 3),
            child: postCard(context, posts[index]),
          );
        }, childCount: posts.length),
      );

  Widget bodySliverList() {
    return StreamBuilder<List<PostModel>>(
        stream: postItems,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? NotificationListener<ScrollNotification>(
                  onNotification: widget.onNotification,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      bodyList(snapshot.data),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator());
        });
  }

  final postController = StreamController<List<PostModel>>();
  Stream<List<PostModel>> get postItems => postController.stream;
  List _imageCounts = [3, 6, 9];

  @override
  void initState() {
    super.initState();

    _getDynamic();
  }

  void _getDynamic() async {
    List querys = await getHotSugs();

    for (var value in querys) {
      PostModel postModel = PostModel(
          name: value,
          logoImage: '',
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
      _getMessage(value.toString()).then((value) {
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
    if (list.data == null || list.data.length == 0) {
      return SearchResultItemModal(
        wareName: '华为 P30',
      );
    } else {
      return list.data.first;
    }
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
    return bodySliverList();
  }

  @override
  bool get wantKeepAlive => true;
}
