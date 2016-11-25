//
//  DFImagePreviewViewController.h
//  DFTimelineView
//
//  Created by Allen Zhong on 16/11/24.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DFImagePreviewViewControllerDelegate <NSObject>

-(void) onLike:(long long) itemId;

-(void) onComment:(long long) itemId;

@end


@interface DFImagePreviewViewController : UIViewController

@property (nonatomic, weak) id<DFImagePreviewViewControllerDelegate> delegate;

- (instancetype)initWithImageUrl:(NSString *) url itemId:(long long)itemId;
@end
