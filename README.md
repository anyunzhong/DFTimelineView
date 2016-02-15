DFTimelineView
=============
[![Version](https://img.shields.io/cocoapods/v/DFTimelineView.svg?style=flat)](http://cocoapods.org/pods/DFTimelineView)
[![License](https://img.shields.io/cocoapods/l/DFTimelineView.svg?style=flat)](http://cocoapods.org/pods/DFTimelineView)
[![Platform](https://img.shields.io/cocoapods/p/DFTimelineView.svg?style=flat)](http://cocoapods.org/pods/DFTimelineView)

仿微信朋友圈 支持图文和短视频

[![Alt][screenshot1_thumb]][screenshot1]    [![Alt][screenshot2_thumb]][screenshot2]    [![Alt][screenshot3_thumb]][screenshot3]    [![Alt][screenshot4_thumb]][screenshot4]    [![Alt][screenshot5_thumb]][screenshot5]    [![Alt][screenshot6_thumb]][screenshot6]    [![Alt][screenshot7_thumb]][screenshot7]    [![Alt][screenshot8_thumb]][screenshot8]    [![Alt][screenshot9_thumb]][screenshot9]

[screenshot1_thumb]: http://file-cdn.datafans.net/github/dftimelineview/1.jpg_250.jpeg
[screenshot1]: http://file-cdn.datafans.net/github/dftimelineview/1.jpg
[screenshot2_thumb]: http://file-cdn.datafans.net/github/dftimelineview/2.jpg_250.jpeg
[screenshot2]: http://file-cdn.datafans.net/github/dftimelineview/2.jpg
[screenshot3_thumb]: http://file-cdn.datafans.net/github/dftimelineview/3.jpg_250.jpeg
[screenshot3]: http://file-cdn.datafans.net/github/dftimelineview/3.jpg
[screenshot4_thumb]: http://file-cdn.datafans.net/github/dftimelineview/4.jpg_250.jpeg
[screenshot4]: http://file-cdn.datafans.net/github/dftimelineview/4.jpg
[screenshot5_thumb]: http://file-cdn.datafans.net/github/dftimelineview/5.jpg_250.jpeg
[screenshot5]: http://file-cdn.datafans.net/github/dftimelineview/5.jpg
[screenshot6_thumb]: http://file-cdn.datafans.net/github/dftimelineview/6.jpg_250.jpeg
[screenshot6]: http://file-cdn.datafans.net/github/dftimelineview/6.jpg
[screenshot7_thumb]: http://file-cdn.datafans.net/github/dftimelineview/7.jpg_250.jpeg
[screenshot7]: http://file-cdn.datafans.net/github/dftimelineview/7.jpg
[screenshot8_thumb]: http://file-cdn.datafans.net/github/dftimelineview/8.jpg_250.jpeg
[screenshot8]: http://file-cdn.datafans.net/github/dftimelineview/8.jpg
[screenshot9_thumb]: http://file-cdn.datafans.net/github/dftimelineview/9.jpg_250.jpeg
[screenshot9]: http://file-cdn.datafans.net/github/dftimelineview/9.jpg


Installation
============

```ruby
pod 'DFTimelineView'
```

Usage
===============

```obj-c
#import "DFTimelineView.h"
```

###### 主时间轴 直接继承 DFTimeLineViewController

###### 添加图文
```obj-c
    DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
    textImageItem.itemId = 10000000; //随便设置一个 待服务器生成
    textImageItem.userId = 10018;
    textImageItem.userAvatar = @"http://file-cdn.datafans.net/avatar/1.jpeg";
    textImageItem.userNick = @"富二代";
    textImageItem.title = @"发表了";
    textImageItem.text = text;
    
    
    NSMutableArray *srcImages = [NSMutableArray array];
    textImageItem.srcImages = srcImages; //大图 可以是本地路径 也可以是网络地址 会自动判断
    
    NSMutableArray *thumbImages = [NSMutableArray array];
    textImageItem.thumbImages = thumbImages; //小图 可以是本地路径 也可以是网络地址 会自动判断
    
    
    for (id img in images) {
        [srcImages addObject:img];
        [thumbImages addObject:img];
    }
    
    textImageItem.location = @"广州信息港";
    [self addItemTop:textImageItem];
    
```


###### 添加小视频
```obj-c
    DFVideoLineItem *videoItem = [[DFVideoLineItem alloc] init];
    videoItem.itemId = 10000000; //随便设置一个 待服务器生成
    videoItem.userId = 10018;
    videoItem.userAvatar = @"http://file-cdn.datafans.net/avatar/1.jpeg";
    videoItem.userNick = @"富二代";
    videoItem.title = @"发表了";
    videoItem.text = @"新年过节 哈哈"; //这里需要present一个界面 用户填入文字后再发送 场景和发图片一样
    videoItem.location = @"广州";
    
    videoItem.localVideoPath = videoPath;
    videoItem.videoUrl = @""; //网络路径
    videoItem.thumbUrl = @"";
    videoItem.thumbImage = screenShot; //如果thumbImage存在 优先使用thumbImage
    
    [self addItemTop:videoItem];

```


###### 发送图文后回调
```obj-c
-(void)onSendTextImage:(NSString *)text images:(NSArray *)images;
```

###### 发送视频后回调
```obj-c
-(void)onSendTextImage:(NSString *)text images:(NSArray *)images;
```

###### 插入到头部和尾部
```obj-c
//添加到末尾
-(void) addItem:(DFBaseLineItem *) item;

//添加到头部
-(void) addItemTop:(DFBaseLineItem *) item;
```
