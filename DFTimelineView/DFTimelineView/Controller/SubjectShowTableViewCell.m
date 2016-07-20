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
    
    _titleLabel = [self labelWithFontSize:15 color:[UIColor lightGrayColor]];
    _stateLabel = [self labelWithFontSize:13 color:[UIColor lightGrayColor]];
    _itemNumber = [self labelWithFontSize:13 color:[UIColor lightGrayColor]];
    _likeNumber = [self labelWithFontSize:13 color:[UIColor lightGrayColor]];
    _imageContentTitle = [self labelWithFontSize:13 color:[UIColor lightGrayColor]];
    _gridView = [[DFPlainGridImageView alloc]initWithFrame:CGRectZero];
    _gridView.delegate = self;
    
    [self.contentView addSubview:_backView];
    [_backView addSubview:_titleLabel];
    [_backView addSubview:_stateLabel];
    [_backView addSubview:_itemNumber];
    [_backView addSubview:_likeNumber];
    [_backView addSubview:_imageContentTitle];
    [_backView addSubview:_gridView];
}

- (void)setupViewsLayout {
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(8, 0, 0, 0));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backView.mas_centerX);
        make.top.equalTo(_backView.mas_top).offset(8);
        make.baseline.equalTo(_stateLabel.mas_baseline);
    }];
    
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(_titleLabel.mas_baseline);
        make.trailing.equalTo(_backView.mas_trailing).offset(-8);
    }];
    
    [_itemNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
        make.leading.equalTo(_backView.mas_leading);
        make.trailing.equalTo(_likeNumber.mas_leading);
        make.width.equalTo(_likeNumber.mas_width);
    }];
    
    [_likeNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itemNumber.mas_top);
        make.trailing.equalTo(_backView.mas_trailing);
        make.width.equalTo(_itemNumber.mas_width);
    }];
    
    [_imageContentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_itemNumber.mas_leading);
        make.top.equalTo(_itemNumber.mas_bottom).offset(8);
    }];
    
    [_gridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imageContentTitle.mas_leading);
        make.top.equalTo(_imageContentTitle.mas_bottom).offset(8);
        make.trailing.equalTo(_backView.mas_trailing).offset(-8);
        make.bottom.equalTo(_backView.mas_bottom).offset(-8);
        make.height.mas_equalTo(0);
    }];
}

- (void)setData:(NSDictionary *)dictionary {
    _titleLabel.text = dictionary[@"title"];
    _stateLabel.text = dictionary[@"status"];
    _itemNumber.text = [NSString stringWithFormat:@"发布量：%@",dictionary[@"pubishCount"]];
    _likeNumber.text = [NSString stringWithFormat:@"点赞数：%@",dictionary[@"praiseCount"]];
    _imageContentTitle.text = @"精彩show";
    
    CGFloat gridViewHeight = [DFPlainGridImageView getHeight:dictionary[@"picture"] maxWidth:self.contentView.frame.size.width];
    [_gridView updateWithImages:dictionary[@"picture"]];
    [_gridView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(gridViewHeight);
    }];
}


- (UILabel *)labelWithFontSize:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    return label;
}

@end
