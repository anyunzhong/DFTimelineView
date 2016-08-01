//
//  DFImagesSendViewController.h
//  DFTimelineView
//
//  Created by Allen Zhong on 16/2/15.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import <DFCommon/DFCommon.h>

typedef enum : NSUInteger {
    DFImagesSendViewControllerTypeNone,
    DFImagesSendViewControllerTypeTopic,
} DFImagesSendViewControllerType;

@protocol DFImagesSendViewControllerDelegate <NSObject>

@optional

-(void) onSendTextImage:(NSString *) text images:(NSArray *)images;
-(void) onSendTextImage:(NSString *) text images:(NSArray *)images tags:(NSArray<NSString *> *)tags;
- (DFImagesSendViewControllerType)imagesSendViewControllerType;
- (NSString *)topicTitle;
- (NSArray<NSString *> *)tagsArray;

@end
@interface DFImagesSendViewController : DFBaseViewController

@property (nonatomic, weak) id<DFImagesSendViewControllerDelegate> delegate;

- (instancetype)initWithImages:(NSArray *) images;

@end
