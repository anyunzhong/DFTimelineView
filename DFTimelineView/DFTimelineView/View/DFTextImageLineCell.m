//
//  DFTextImageLineCell.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTextImageLineCell.h"
#import "DFTextImageLineItem.h"

#import "MLLinkLabel.h"

#import "DFGridImageView.h"


#define TextFont [UIFont systemFontOfSize:14]

#define TextLineHeight 1.2f

#define TextImageSpace 10

@interface DFTextImageLineCell()

@property (strong, nonatomic) MLLinkLabel *textContentLabel;

@property (strong, nonatomic) DFGridImageView *gridImageView;

@end


@implementation DFTextImageLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initCell];
    }
    return self;
}


-(void) initCell
{
    
    if (_textContentLabel == nil) {
        
        _textContentLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _textContentLabel.font = TextFont;
        _textContentLabel.numberOfLines = 0;
        _textContentLabel.adjustsFontSizeToFitWidth = NO;
        _textContentLabel.textInsets = UIEdgeInsetsZero;
        
        _textContentLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _textContentLabel.allowLineBreakInsideLinks = NO;
        _textContentLabel.linkTextAttributes = nil;
        _textContentLabel.activeLinkTextAttributes = nil;
        _textContentLabel.lineHeightMultiple = TextLineHeight;
        
        [self.bodyView addSubview:_textContentLabel];
    }
    
    if (_gridImageView == nil) {
        
        CGFloat x, y , width, height;
        
        x = 0;
        y = 0;
        width = BodyMaxWidth;
        height = width;
        
        _gridImageView = [[DFGridImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.bodyView addSubview:_gridImageView];
    }

}


-(void)updateWithItem:(DFTextImageLineItem *)item
{
    [super updateWithItem:item];
    
    
    NSAttributedString *text  = [[NSAttributedString alloc] initWithString:item.text];
    
    CGSize textSize = [MLLinkLabel getViewSize:text maxWidth:BodyMaxWidth font:TextFont lineHeight:TextLineHeight lines:0];

    _textContentLabel.attributedText = text;
    [_textContentLabel sizeToFit];
    
    _textContentLabel.frame = CGRectMake(0, 0, BodyMaxWidth, textSize.height);
    
    CGFloat gridHeight = [_gridImageView getHeight:item.thumbImages oneImageWidth:item.width oneImageHeight:item.height];
    
    CGFloat x, y, width, height;
    x = _gridImageView.frame.origin.x;
    y = CGRectGetMaxY(_textContentLabel.frame)+TextImageSpace;
    width = _gridImageView.frame.size.width;
    height = gridHeight;
    _gridImageView.frame = CGRectMake(x, y, width, height);
    
    [_gridImageView updateWithImages:item.thumbImages srcImages:item.srcImages oneImageWidth:item.width oneImageHeight:item.height];
    
    [self updateBodyView:(textSize.height+gridHeight+TextImageSpace)];
    
}


+(CGFloat)getCellHeight:(DFTextImageLineItem *)item
{
    
    NSAttributedString *text  = [[NSAttributedString alloc] initWithString:item.text];
    
    CGSize textSize = [MLLinkLabel getViewSize:text maxWidth:BodyMaxWidth font:TextFont lineHeight:TextLineHeight lines:0];
    
    CGFloat height = [DFBaseLineCell getCellHeight:item];
    
    CGFloat gridHeight = [DFGridImageView getHeight:item.thumbImages maxWidth:BodyMaxWidth oneImageWidth:item.width oneImageHeight:item.height];

    return height+textSize.height + gridHeight+TextImageSpace;
}

@end
