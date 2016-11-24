//
//  DFImagePreviewViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 16/11/24.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import "DFImagePreviewViewController.h"
#import "UIImageView+WebCache.h"

@interface DFImagePreviewViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) NSString *url;

@end

@implementation DFImagePreviewViewController

- (instancetype)initWithImageUrl:(NSString *) url
{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    //_imageView.backgroundColor = [UIColor redColor];
    //_imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_url]];
    
    [self.view addSubview:_imageView];
    
    
    
    
    UIPreviewAction *likeAction=[UIPreviewAction actionWithTitle:@"赞" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * action, UIViewController * previewViewController) {
    }];
    
    UIPreviewAction *commentAction=[UIPreviewAction actionWithTitle:@"评论" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *action, UIViewController * previewViewController) {
    }];
    
    UIPreviewAction *forwardAction=[UIPreviewAction actionWithTitle:@"转发" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction *action, UIViewController * previewViewController) {
    }];

    self.actions=@[likeAction,commentAction, forwardAction];

    
}


-(NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    return self.actions;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
