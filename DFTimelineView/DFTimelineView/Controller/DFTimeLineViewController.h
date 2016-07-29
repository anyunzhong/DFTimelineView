//
//  DFTimeLineViewController.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"

#import "DFLineLikeItem.h"
#import "DFLineCommentItem.h"

#import "DFBaseTimeLineViewController.h"


typedef enum : NSUInteger {
    TimeLineTypeNone,   //
    TImeLineTypeSubjectShow,  //单个subject秀列表
} DFTimeLineViewControllerType;

@interface DFTimeLineViewController : DFBaseTimeLineViewController

//添加到末尾
-(void) addItem:(DFBaseLineItem *) item;

//添加到头部
-(void) addItemTop:(DFBaseLineItem *) item;

//根据ID删除
-(void) deleteItem:(long long) itemId;

//赞
-(void) addLikeItem:(DFLineLikeItem *) likeItem itemId:(long long) itemId;

//评论
-(void) addCommentItem:(DFLineCommentItem *) commentItem itemId:(long long) itemId replyCommentId:(long long) replyCommentId;


//发送图文
-(void)onSendTextImage:(NSString *)text images:(NSArray *)images;

//发送视频消息
-(void)onSendVideo:(NSString *)text videoPath:(NSString *)videoPath screenShot:(UIImage *) screenShot;

//点击更多
- (void)clickMoreSubjectShowList;
//点击滚动图片
- (void)onClickScrollView:(UIView *)cycleScrollView index:(NSInteger)index;
//
- (void)updateRightAvatarWithImage:(id)image;

- (void)setHeaderDataTitle:(NSString *)title images:(NSArray<NSString *> *)images tags:(NSArray<NSString *> *)tags;
- (void)setHeaderForTopicDataTitle:(NSString *)title time:(NSString *)time imageUrl:(NSString *)imageUrl content:(NSString *)content;

@property (nonatomic) DFTimeLineViewControllerType type;

@end
