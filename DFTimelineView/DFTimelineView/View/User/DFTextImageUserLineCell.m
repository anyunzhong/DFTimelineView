//
//  DFTextImageUserLineCell.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTextImageUserLineCell.h"

#define TextImageCellHeight 70

#define ImageTxtPadding 10

@interface DFTextImageUserLineCell()

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UILabel *txtLabel;

@property (nonatomic, strong) UILabel *photoCountLabel;

@end


@implementation DFTextImageUserLineCell


#pragma mark - Lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubView];
    }
    return self;
}


-(void) initSubView
{
    
    if (_coverView == nil) {
        _coverView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _coverView.backgroundColor = [UIColor lightGrayColor];
        [self.bodyView addSubview:_coverView];
    }
    
    if (_txtLabel == nil) {
        _txtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _txtLabel.font = [UIFont systemFontOfSize:14];
        _txtLabel.numberOfLines = 3;
        [self.bodyView addSubview:_txtLabel];
    }
    
    if (_photoCountLabel == nil) {
        _photoCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _photoCountLabel.font = [UIFont systemFontOfSize:11];
        _photoCountLabel.textColor = [UIColor lightGrayColor];
        [self.bodyView addSubview:_photoCountLabel];
    }
}


-(void) updateWithItem:(DFTextImageUserLineItem *) item
{
    [super updateWithItem:item];
    
    [self updateBodyWithHeight:TextImageCellHeight];
    
    
    CGFloat x, y, width, height;
    
    x = 0;
    y = 0;
    width= TextImageCellHeight;
    height = width;
    _coverView.frame  = CGRectMake(x, y, width, height);
    if (item.cover != nil) {
        _coverView.hidden = NO;
        [_coverView sd_setImageWithURL:[NSURL URLWithString:item.cover]];
    }else{
        _coverView.hidden = YES;
    }
    
    if (item.cover != nil) {
        x = CGRectGetMaxX(_coverView.frame) + ImageTxtPadding;
        _txtLabel.backgroundColor = [UIColor clearColor];
        _txtLabel.numberOfLines = 3;
    }else{
        _txtLabel.backgroundColor = [UIColor colorWithWhite:245/255.0 alpha:1.0];
        _txtLabel.numberOfLines = 4;
    }
    
    width = CGRectGetWidth(self.bodyView.frame) - x;
    height = CGRectGetHeight(self.bodyView.frame) - 20;
    _txtLabel.frame = CGRectMake(x, y, width, height);
    _txtLabel.text = item.text;
    [_txtLabel sizeToFit];
    
    if (item.photoCount > 1) {
        _photoCountLabel.hidden = NO;
        x = CGRectGetMaxX(_coverView.frame) + ImageTxtPadding;
        width = 30;
        height = 12;
        y = CGRectGetMaxY(_coverView.frame)-height;
        _photoCountLabel.frame = CGRectMake(x, y, width, height);
        _photoCountLabel.text = [NSString stringWithFormat:@"%ld张", item.photoCount];
    }else{
        _photoCountLabel.hidden = YES;
    }
    
    
    
}



+(CGFloat) getCellHeight:(DFTextImageUserLineItem *) item
{
    return [DFBaseUserLineCell getCellHeight:item] + TextImageCellHeight;
}

@end
