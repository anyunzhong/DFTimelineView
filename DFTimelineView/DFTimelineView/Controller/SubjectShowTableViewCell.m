//
//  SubjectShowTableViewCell.m
//  DFTimelineView
//
//  Created by 刘一智 on 16/7/20.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import "SubjectShowTableViewCell.h"
#import <Masonry.h>

@implementation SubjectShowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self setupViewsLayout];
    }
    return self;
}

- (void)setupViews {
    
    _backView = [UIView new];
    [_backView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    _colorView = [UIView new];
    _colorView.backgroundColor = [UIColor orangeColor];
    _colorView.layer.cornerRadius = 4.f;
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    
    _titleLabel = [self labelWithFontSize:15 color:[UIColor lightGrayColor]];
    _detailLabel = [self labelWithFontSize:15 color:[UIColor lightGrayColor]];
    _stateLabel = [self labelWithFontSize:11 color:[UIColor lightGrayColor]];
    _itemNumber = [self labelWithFontSize:11 color:[UIColor lightGrayColor]];
    _likeNumber = [self labelWithFontSize:11 color:[UIColor lightGrayColor]];
    _moreLabel = [self labelWithFontSize:11 color:[UIColor orangeColor]];
    _imageContentTitle = [self labelWithFontSize:13 color:[UIColor lightGrayColor]];
    _gridView = [[DFGridImageView alloc]initWithFrame:CGRectMake(0, 0, 288, 0)];
    
    [self.contentView addSubview:_backView];
    [_backView addSubview:_colorView];
    [_backView addSubview:_lineView];
    [_backView addSubview:_detailLabel];
    [_backView addSubview:_titleLabel];
    [_backView addSubview:_moreLabel];
    [_backView addSubview:_stateLabel];
    [_backView addSubview:_itemNumber];
    [_backView addSubview:_likeNumber];
    [_backView addSubview:_gridView];
}

- (void)setupViewsLayout {
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(8, 8, 0, 8));
    }];
    
    [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleLabel);
        make.trailing.equalTo(_titleLabel.mas_leading).offset(-8);
        make.width.mas_equalTo(4);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_topMargin);
        make.leading.equalTo(_titleLabel.superview.mas_leading).offset(32);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_lineView.superview.mas_leadingMargin);
        make.trailing.equalTo(_lineView.superview.mas_trailingMargin);
        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(1.0f/[[UIScreen mainScreen]scale]);
    }];
    
    [_itemNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.trailing.equalTo(_likeNumber.mas_leading).offset(-8);
    }];
    
    [_likeNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.trailing.equalTo(_moreLabel.mas_leading).offset(-8);
        make.width.equalTo(_itemNumber.mas_width);
    }];

    [_moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.trailing.equalTo(_moreLabel.superview.mas_trailingMargin);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(8);
        make.trailing.equalTo(_detailLabel.superview.mas_trailingMargin);
        make.leading.equalTo(_stateLabel.mas_trailing).offset(8);
        
    }];

    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_detailLabel.mas_centerY);
        make.leading.equalTo(_stateLabel.superview.mas_leadingMargin);
        make.trailing.equalTo(_detailLabel.mas_leading).offset(-8);
    }];
    
    [_gridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_gridView.superview.mas_leadingMargin);
        make.top.equalTo(_detailLabel.mas_bottom).offset(8);
        make.trailing.equalTo(_backView.mas_trailingMargin);
        make.bottom.equalTo(_backView.mas_bottomMargin);
//        make.size.mas_equalTo(CGSizeZero);
    }];
}

- (void)setData:(NSDictionary *)dictionary {
    _titleLabel.text = @"_titleLabel";
    _detailLabel.text = @"_detailLabel";
    _stateLabel.text = @"_stateLabel";
    _itemNumber.text = [NSString stringWithFormat:@"发布量：%@",dictionary[@"pubishCount"]];
    _likeNumber.text = [NSString stringWithFormat:@"点赞数：%@",dictionary[@"praiseCount"]];
    
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:@"http://file-cdn.datafans.net/temp/11.jpg"];
    [array addObject:@"http://file-cdn.datafans.net/temp/12.jpg"];
    [array addObject:@"http://file-cdn.datafans.net/temp/13.jpg"];
    [array addObject:@"http://file-cdn.datafans.net/temp/14.jpg"];
    [array addObject:@"http://file-cdn.datafans.net/temp/15.jpg"];
    [array addObject:@"http://file-cdn.datafans.net/temp/16.jpg"];

    CGFloat gridViewWidth = _backView.frame.size.width - 16;
    CGFloat gridViewHeight = [DFGridImageView getHeight:array maxWidth:gridViewWidth oneImageWidth:80 oneImageHeight:80];
    [_gridView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(gridViewWidth, gridViewHeight));
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_gridView updateWithImages:array srcImages:array oneImageWidth:80 oneImageHeight:80];
    });
}

- (UILabel *)labelWithFontSize:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    return label;
}

@end
