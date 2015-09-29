//
//  ViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "ViewController.h"

#import "DFTextImageLineItem.h"


@interface ViewController ()

@end

@implementation ViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"朋友圈";
    
    [self initData];
    
}


-(void) initData
{
    DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
    textImageItem.itemType = LineItemTypeTextImage;
    textImageItem.userId = 10086;
    textImageItem.userAvatar = @"http://file-cdn.datafans.net/avatar/1.jpeg";
    textImageItem.userNick = @"Allen";
    textImageItem.title = @"";
    textImageItem.text = @"你是我的小苹果 小苹果 我爱你 就像老鼠爱大米 18680551720 [亲亲]";
    
    NSMutableArray *srcImages = [NSMutableArray array];
    [srcImages addObject:@"http://file-cdn.datafans.net/avatar/20150922172455735824.jpeg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg"];
    [srcImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg"];
    
    
    
    textImageItem.srcImages = srcImages;
    
    
    NSMutableArray *thumbImages = [NSMutableArray array];
    [thumbImages addObject:@"http://file-cdn.datafans.net/avatar/20150922172455735824.jpeg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg_160x160.jpeg"];
    [thumbImages addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg_160x160.jpeg"];
    textImageItem.thumbImages = thumbImages;
    
    textImageItem.location = @"凯旋新世界";
    
    NSMutableArray *likes = [NSMutableArray array];
    [likes addObject:@"Allen"];
    [likes addObject:@"奥巴马"];
    [likes addObject:@"梅长舒"];
    [likes addObject:@"胡八一"];
    [likes addObject:@"Jack"];
    [likes addObject:@"小王八"];
    [likes addObject:@"一起👌"];
    [likes addObject:@"神经病"];
    [likes addObject:@"💐love"];
    textImageItem.likes = likes;
    
    
    
    NSMutableArray *comments = [NSMutableArray array];
    [comments addObject:@"决战紫禁之巅: hello world"];
    [comments addObject:@"妖神: 出世 哈哈"];
    [comments addObject:@"但愿人长久: 千里共婵娟"];
    textImageItem.comments = comments;
    [self addItem:textImageItem];


    DFTextImageLineItem *textImageItem2 = [[DFTextImageLineItem alloc] init];
    textImageItem2.itemType = LineItemTypeTextImage;
    textImageItem2.userId = 10088;
    textImageItem2.userAvatar = @"http://file-cdn.datafans.net/avatar/2.jpg";
    textImageItem2.userNick = @"烟花易冷&柳暗花明又一村";
    textImageItem2.title = @"发表了";
    textImageItem2.text = @"京东JD.COM-专业的综合网上购物商城，销售超数万品牌、4020万种商品，http://jd.com 囊括家电、手机、电脑、服装、图书、母婴、个护、食品、旅游等13大品类。秉承客户为先的理念，京东所售商品为正品行货、全国联保、机打发票。@刘强东";
    
    NSMutableArray *srcImages2 = [NSMutableArray array];
    [srcImages2 addObject:@"http://file-cdn.datafans.net/avatar/20150922172455735824.jpeg"];
    [srcImages2 addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg"];
    [srcImages2 addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg"];
    [srcImages2 addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg"];
    textImageItem2.srcImages = srcImages2;
    
    
    NSMutableArray *thumbImages2 = [NSMutableArray array];
    [thumbImages2 addObject:@"http://file-cdn.datafans.net/avatar/20150922172455735824.jpeg_160x160.jpeg"];
    [thumbImages2 addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg_160x160.jpeg"];
    [thumbImages2 addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg_160x160.jpeg"];
    [thumbImages2 addObject:@"http://file-cdn.datafans.net/avatar/20150922171658733807.jpeg_160x160.jpeg"];
    textImageItem2.thumbImages = thumbImages2;
    
    
    NSMutableArray *likes2 = [NSMutableArray array];
    [likes2 addObject:@"Allen"];
    [likes2 addObject:@"Yanhuahuang"];
    //textImageItem2.likes = likes2;
    
    
    NSMutableArray *comments2 = [NSMutableArray array];
    [comments2 addObject:@"小苹果: hello world"];
    [comments2 addObject:@"妖神: 出世 哈哈"];
    textImageItem2.comments = comments2;
    
    [self addItem:textImageItem2];

    
    
    
    DFTextImageLineItem *textImageItem3 = [[DFTextImageLineItem alloc] init];
    textImageItem3.itemType = LineItemTypeTextImage;
    textImageItem3.userId = 10088;
    textImageItem3.userAvatar = @"http://file-cdn.datafans.net/avatar/2.jpg";
    textImageItem3.userNick = @"烟花易冷&柳暗花明又一村";
    textImageItem3.title = @"发表了";
    textImageItem3.text = @"京东JD.COM-专业的综合网上购物商城";
    
    NSMutableArray *srcImages3 = [NSMutableArray array];
    [srcImages3 addObject:@"http://file-cdn.datafans.net/avatar/20150922172455735824.jpeg"];
    textImageItem3.srcImages = srcImages3;
    
    
    NSMutableArray *thumbImages3 = [NSMutableArray array];
    [thumbImages3 addObject:@"http://file-cdn.datafans.net/avatar/20150922172455735824.jpeg_600x420.jpeg"];
    textImageItem3.thumbImages = thumbImages3;
    
    
    textImageItem3.width = 300;
    textImageItem3.height = 210;
    
    textImageItem3.location = @"广州信息港";
    
    [self addItem:textImageItem3];

    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

@end
