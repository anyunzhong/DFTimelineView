//
//  DFTimeLineViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTimeLineViewController.h"
#import "DFLineCellManager.h"

#import "DFBaseLineCell.h"
#import "DFLineLikeItem.h"
#import "DFLineCommentItem.h"
#import "CommentInputView.h"

#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"

#import "TZImagePickerController.h"

#import "DFImagesSendViewController.h"
#import "DFVideoCaptureController.h"

#import <SDCycleScrollView.h>

#import <SKTagView.h>
#import "TENSubjectShowViewController.h"

#import <Masonry.h>

#define TableHeaderHeight 180*([UIScreen mainScreen].bounds.size.width / 375.0)


@interface DFTimeLineViewController ()<DFLineCellDelegate, CommentInputViewDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, DFImagesSendViewControllerDelegate,DFVideoCaptureControllerDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) NSMutableDictionary *itemDic;

@property (nonatomic, strong) NSMutableDictionary *commentDic;


@property (strong, nonatomic) CommentInputView *commentInputView;

@property (nonatomic, strong) SDCycleScrollView *topScrollView;


@property (assign, nonatomic) long long currentItemId;

@property (nonatomic, strong) UIImagePickerController *pickerController;

@property (nonatomic) CGFloat currentSelectedLinkLabelY;
@property (nonatomic) CGFloat keyboardOffsetY;

@end

@implementation DFTimeLineViewController


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        [[MMPopupWindow sharedWindow] cacheWindow];
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        
        MMSheetViewConfig *sheetConfig = [MMSheetViewConfig globalConfig];
        sheetConfig.defaultTextCancel = @"取消";

        _items = [NSMutableArray array];
        
        _itemDic = [NSMutableDictionary dictionary];
        
        _commentDic = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCommentInputView];
    
    switch (self.type) {
        case TimeLineTypeNone:
            self.navigationItem.rightBarButtonItems = @[[self rightBarButtonItem],[self rightBarButtonItemAnotherOne]];
            break;
        case TImeLineTypeSubjectShow:
            self.navigationItem.rightBarButtonItems = @[[self rightBarButtonItemAnotherOne]];
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [_commentInputView addNotify];
    
    [_commentInputView addObserver];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_commentInputView removeNotify];
    
    [_commentInputView removeObserver];
}

-(void) initCommentInputView
{
    if (_commentInputView == nil) {
        _commentInputView = [[CommentInputView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _commentInputView.hidden = YES;
        _commentInputView.delegate = self;
        [self.view addSubview:_commentInputView];
    }
}

- (void)initMyHeader {
    switch (self.type) {
        case TimeLineTypeNone:
            [self initTimelineHeaderWithTitle:nil images:nil tags:nil];
            break;
        case TImeLineTypeSubjectShow:
            [self initSubjectShowHeader];
            break;
    }
}

- (void) initJoinFooter {
    UIView *back = [UIView new];
    [back setBackgroundColor:[UIColor orangeColor]];
    back.tag = 888;
}

- (void) initSubjectShowHeader {
    UIView *back = [[UIView alloc]initWithFrame:CGRectZero];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    
    UIImageView *imageView = [UIImageView new];
    [imageView setBackgroundColor:[UIColor lightGrayColor]];
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    detailLabel.textColor = [UIColor lightGrayColor];
    //!!!!关键,问题6p 上 Margin 值和 6上的值并不一致
    detailLabel.preferredMaxLayoutWidth = [[UIScreen mainScreen]bounds].size.width - 16;
    detailLabel.numberOfLines = 0;
    
    //虚拟数据
    titleLabel.text = @"titleLabel";
    timeLabel.text = @"timeLabel";
    imageView.image = [UIImage imageNamed:@"angle-mask@3x"];
    detailLabel.text = @"“三个代表”思想要求中国共产党：\
    \
    要始终代表中国先进社会生产力的发展要求；\
    要始终代表中国先进文化的前进方向；\
    要始终代表中国最广大人民的根本利益。\
    三个代表中列为第一位的是“先进社会生产力的发展要求的代表”，即进一步推进生产力发展的方针。";

    [back addSubview:titleLabel];
    [back addSubview:timeLabel];
    [back addSubview:imageView];
    [back addSubview:detailLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(titleLabel.superview.mas_leadingMargin);
        make.top.equalTo(titleLabel.superview.mas_topMargin);
        make.trailing.equalTo(titleLabel.superview.mas_trailingMargin);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
//        make.bottom.equalTo(imageView.mas_top).offset(-8);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(titleLabel);
        make.top.equalTo(timeLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(130);
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(titleLabel);
        make.top.equalTo(imageView.mas_bottom).offset(8);
        make.bottom.equalTo(detailLabel.superview.mas_bottomMargin);
    }];
    
    //TODO:!!!!!
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        self.tableView.tableHeaderView = nil;
        self.tableView.tableHeaderView = back;
        [self sizeHeaderToFit];
        [self.tableView endUpdates];
    });
}

- (void)sizeHeaderToFit
{
    UIView *header = self.tableView.tableHeaderView;
    
    [header setNeedsLayout];
    [header layoutIfNeeded];
    
    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = header.frame;
    
    frame.size.height = height;
    header.frame = frame;
    
    self.tableView.tableHeaderView = header;
}


- (void) initTimelineHeaderWithTitle:(NSString *)title images:(NSArray<NSString *> *)images tags:(NSArray<NSString *> *)tags {
    CGFloat x,y,width, height;
    x=0;
    y=0;
    CGFloat moreShowCellHeight = 44;
    CGFloat tagViewHeight = 33;
    width = self.view.frame.size.width;
    height = TableHeaderHeight + moreShowCellHeight + 8;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableHeaderView = header;
    
    if (images.count > 0) {
        _topScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(x, y, width, TableHeaderHeight) imageURLStringsGroup:images];
    } else {
        _topScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(x, y, width, TableHeaderHeight) imageNamesGroup:@[@"u2_state0",@"u2_state0"]];
    }
    _topScrollView.delegate = self;
    _topScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    
    [header addSubview:_topScrollView];
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setFrame:CGRectMake(x, TableHeaderHeight, width, moreShowCellHeight)];
    cell.textLabel.text = @"更多主题秀";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMoreSubjectShowList)];
    [cell addGestureRecognizer:tap];
    [header addSubview:cell];
    
    if (tags.count > 0) {
        height = tagViewHeight + 1;
        SKTagView *tagView = [[SKTagView alloc]initWithFrame:CGRectMake(x, TableHeaderHeight + moreShowCellHeight + 8, width, tagViewHeight)];
        [tagView setBackgroundColor:[UIColor whiteColor]];
        tagView.interitemSpacing = 8;
        tagView.preferredMaxLayoutWidth = width;
        tagView.padding = UIEdgeInsetsMake(4, 8, 4, 8);
        tagView.selectedType = SKTagViewSelectedSingle;
        [tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SKTag *tag = [[SKTag alloc]initWithText:obj];
            tag.textColor = [UIColor lightGrayColor];
            //        tag.bgColor = [UIColor groupTableViewBackgroundColor];
            tag.cornerRadius = 3;
            tag.fontSize = 15;
            tag.borderColor = [UIColor lightGrayColor];
            tag.borderWidth = 1.f;
            tag.padding = UIEdgeInsetsMake(3.5, 10.5, 3.5, 10.5);
            tag.selectedBgColor = [UIColor redColor];
            tag.selectedTextColor = [UIColor whiteColor];
            
            [tagView addTag:tag];
        }];
        [header addSubview:tagView];
    }
}

- (void)setHeaderDataTitle:(NSString *)title images:(NSArray<NSString *> *)images tags:(NSArray<NSString *> *)tags {
    [self initTimelineHeaderWithTitle:title images:images tags:tags];
    //TODO:得到数据后重新生成HeaderView
    
}

- (void)setSubjectHeaderDataTitle:(NSString *)title time:(NSString *)time imageUrl:(NSString *)imageUrl content:(NSString *)content {
    
    //
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - BarButtonItem

- (UIBarButtonItem *)rightBarButtonItemAnotherOne {
    UIBarButtonItem *item = [UIBarButtonItem icon:@"AlbumAddBtn" selector:@selector(onLongPressCamera:) target:self];
    return item;
}

-(UIBarButtonItem *)rightBarButtonItem
{
    UIBarButtonItem *item = [UIBarButtonItem icon:@"Camera" selector:@selector(onClickCamera:) target:self];
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressCamera:)];
    [item.customView addGestureRecognizer:recognizer];
    return item;
}

-(void) onLongPressCamera:(UIGestureRecognizer *) gesture
{
    DFImagesSendViewController *controller = [[DFImagesSendViewController alloc] initWithImages:nil];
    controller.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
}

//接受imageUrl or image
- (void)updateRightAvatarWithImage:(id)image {
    if ([image isKindOfClass:[UIImage class]]) {
        
    }
    if ([image isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL URLWithString:image];
        [[NSURLSession sharedSession]dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
        }].resume;
    }
}

-(void) onClickCamera:(id) sender
{
    /**
    MMPopupItemHandler block = ^(NSInteger index){
        switch (index) {
            case 0:
                [self captureViedo];
                break;
            case 1:
                [self takePhoto];
                break;
            case 2:
                [self pickFromAlbum];
                break;
            default:
                break;
        }
    };
    
    
    NSArray *items = @[MMItemMake(@"小视频", MMItemTypeNormal, block),
      MMItemMake(@"拍照", MMItemTypeNormal, block),
      MMItemMake(@"从相册选取", MMItemTypeNormal, block)];
     **/
    MMPopupItemHandler block = ^(NSInteger index){
        switch (index) {
            case 0:
                [self takePhoto];
                break;
            case 1:
                [self pickFromAlbum];
                break;
            default:
                break;
        }
    };
    
    NSArray *items = @[
                       MMItemMake(@"拍照", MMItemTypeNormal, block),
                       MMItemMake(@"从相册选取", MMItemTypeNormal, block)];

    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"" items:items];
    
    [sheetView show];
}


-(void) captureViedo
{
    DFVideoCaptureController *controller = [[DFVideoCaptureController alloc] init];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:^{
        
    }];

}


-(void) takePhoto
{
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.delegate = self;
    _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_pickerController animated:YES completion:nil];
}

-(void) pickFromAlbum
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DFBaseLineItem *item = [_items objectAtIndex:indexPath.row];
    DFBaseLineCell *typeCell = [self getCell:[item class]];
    return [typeCell getReuseableCellHeight:item];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFBaseLineItem *item = [_items objectAtIndex:indexPath.row];
    DFBaseLineCell *typeCell = [self getCell:[item class]];
    
    NSString *reuseIdentifier = NSStringFromClass([typeCell class]);
    DFBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier];
    if (cell == nil ) {
        cell = [[[typeCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }else{
        NSLog(@"重用Cell: %@", reuseIdentifier);
    }

    cell.delegate = self;
    
    cell.separatorInset = UIEdgeInsetsZero;
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    [cell updateWithItem:item];
    
    return cell;
}


#pragma mark - TabelViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击所有cell空白地方 隐藏toolbar
    NSInteger rows =  [tableView numberOfRowsInSection:0];
    for (int row = 0; row < rows; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        DFBaseLineCell *cell  = (DFBaseLineCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell hideLikeCommentToolbar];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_commentInputView hideInputView];
}

#pragma mark - Method

-(DFBaseLineCell *) getCell:(Class)itemClass
{
    DFLineCellManager *manager = [DFLineCellManager sharedInstance];
    return [manager getCell:itemClass];
}

-(void)addItem:(DFBaseLineItem *)item
{
    [self insertItem:item index:_items.count];
}

-(void) addItemTop:(DFBaseLineItem *) item
{
    [self insertItem:item index:0];
}

-(void) insertItem:(DFBaseLineItem *) item index:(NSUInteger)index
{
    [self genLikeAttrString:item];
    [self genCommentAttrString:item];
    
    [_items insertObject:item atIndex:index];
    
    
    [_itemDic setObject:item forKey:[NSNumber numberWithLongLong:item.itemId]];
    
    [self.tableView reloadData];
}


-(void)deleteItem:(long long)itemId
{
    DFBaseLineItem *item = [self getItem:itemId];
    [_items removeObject:item];
    [_itemDic removeObjectForKey:[NSNumber numberWithLongLong:item.itemId]];
}

-(DFBaseLineItem *) getItem:(long long) itemId
{
    return [_itemDic objectForKey:[NSNumber numberWithLongLong:itemId]];
    
}

-(void)addLikeItem:(DFLineLikeItem *)likeItem itemId:(long long)itemId
{
    DFBaseLineItem *item = [self getItem:itemId];
    [item.likes insertObject:likeItem atIndex:0];
    
    item.likesStr = nil;
    item.cellHeight = 0;
    
    [self genLikeAttrString:item];
    
    [self.tableView reloadData];
}


-(void)addCommentItem:(DFLineCommentItem *)commentItem itemId:(long long)itemId replyCommentId:(long long)replyCommentId

{
    DFBaseLineItem *item = [self getItem:itemId];
    [item.comments addObject:commentItem];
    
    if (replyCommentId > 0) {
        DFLineCommentItem *replyCommentItem = [self getCommentItem:replyCommentId];
        commentItem.replyUserId = replyCommentItem.userId;
        commentItem.replyUserNick = replyCommentItem.userNick;
    }
    
    item.cellHeight = 0;
    [self genCommentAttrString:item];
    [self.tableView reloadData];
    
}

-(DFLineCommentItem *)getCommentItem:(long long)commentId
{
    return [_commentDic objectForKey:[NSNumber numberWithLongLong:commentId]];
}





#pragma mark - DFLineCellDelegate

/**
-(void)onComment:(long long)itemId
{
    _currentItemId = itemId;
    
    _commentInputView.commentId = 0;
    
    _commentInputView.hidden = NO;
    
    [_commentInputView show];
}
 **/

- (void)onComment:(long long)itemId cell:(DFBaseLineCell *)cell {
    _currentItemId = itemId;
    
    _commentInputView.commentId = 0;
    
    _commentInputView.hidden = NO;
    
    [_commentInputView show];
    
    CGPoint linkLabelPoint = [self.view.window convertPoint:cell.bounds.origin fromView:cell];
    CGFloat tableViewMovingDistance = (self.keyboardOffsetY - (linkLabelPoint.y + cell.frame.size.height));
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - tableViewMovingDistance) animated:YES];
}

-(void)onLike:(long long)itemId
{
    
}

-(void)onClickUser:(NSUInteger)userId
{
    
}


/**
-(void)onClickComment:(long long)commentId itemId:(long long)itemId
{
    
    _currentItemId = itemId;
    
    _commentInputView.hidden = NO;
    
    _commentInputView.commentId = commentId;
    
    [_commentInputView show];
    
    DFLineCommentItem *comment = [_commentDic objectForKey:[NSNumber numberWithLongLong:commentId]];
    [_commentInputView setPlaceHolder:[NSString stringWithFormat:@"  回复: %@", comment.userNick]];
    
}
 **/

- (void)onClickComment:(long long)commentId itemId:(long long)itemId linkLabel:(UIView *)linkLabel {
    _currentItemId = itemId;
    
    _commentInputView.hidden = NO;
    
    _commentInputView.commentId = commentId;
    
    [_commentInputView show];
    
    DFLineCommentItem *comment = [_commentDic objectForKey:[NSNumber numberWithLongLong:commentId]];
    [_commentInputView setPlaceHolder:[NSString stringWithFormat:@"  回复: %@", comment.userNick]];

    CGPoint linkLabelPoint = [self.view.window convertPoint:linkLabel.bounds.origin fromView:linkLabel];
    CGFloat tableViewMovingDistance = (self.keyboardOffsetY - (linkLabelPoint.y + linkLabel.frame.size.height));
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - tableViewMovingDistance) animated:YES];
}

- (void)commentInputViewDidChangeOffsetY:(CGFloat)currentOffsetY {
    self.keyboardOffsetY = currentOffsetY;
}

-(void)onCommentCreate:(long long)commentId text:(NSString *)text
{
    [self onCommentCreate:commentId text:text itemId:_currentItemId];
}

-(void)onCommentCreate:(long long)commentId text:(NSString *)text itemId:(long long) itemId
{
    
}

-(void) genLikeAttrString:(DFBaseLineItem *) item
{
    if (item.likes.count == 0) {
        return;
    }
    
    if (item.likesStr == nil) {
        NSMutableArray *likes = item.likes;
        NSString *result = @"";
        
        for (int i=0; i<likes.count;i++) {
            DFLineLikeItem *like = [likes objectAtIndex:i];
            if (i == 0) {
                result = [NSString stringWithFormat:@"%@",like.userNick];
            }else{
                result = [NSString stringWithFormat:@"%@, %@", result, like.userNick];
            }
        }
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:result];
        NSUInteger position = 0;
        for (int i=0; i<likes.count;i++) {
            DFLineLikeItem *like = [likes objectAtIndex:i];
            [attrStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)like.userId] range:NSMakeRange(position, like.userNick.length)];
            position += like.userNick.length+2;
        }
        
        item.likesStr = attrStr;
    }
    
}

-(void) genCommentAttrString:(DFBaseLineItem *)item
{
    NSMutableArray *comments = item.comments;
    
    [item.commentStrArray removeAllObjects];
    
    for (int i=0; i<comments.count;i++) {
        DFLineCommentItem *comment = [comments objectAtIndex:i];
        [_commentDic setObject:comment forKey:[NSNumber numberWithLongLong:comment.commentId]];
        
        NSString *resultStr;
        if (comment.replyUserId == 0) {
            resultStr = [NSString stringWithFormat:@"%@: %@",comment.userNick, comment.text];
        }else{
            resultStr = [NSString stringWithFormat:@"%@回复%@: %@",comment.userNick, comment.replyUserNick, comment.text];
        }
        
        NSMutableAttributedString *commentStr = [[NSMutableAttributedString alloc]initWithString:resultStr];
        if (comment.replyUserId == 0) {
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.userId] range:NSMakeRange(0, comment.userNick.length)];
        }else{
            NSUInteger localPos = 0;
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.userId] range:NSMakeRange(localPos, comment.userNick.length)];
            localPos += comment.userNick.length + 2;
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)comment.replyUserId] range:NSMakeRange(localPos, comment.replyUserNick.length)];
        }
        
        NSLog(@"ffff: %@", resultStr);
        
        [item.commentStrArray addObject:commentStr];
    }
}

- (void)clickMoreSubjectShowList {
    
}


#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSLog(@"%@", photos);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        DFImagesSendViewController *controller = [[DFImagesSendViewController alloc] initWithImages:photos];
        controller.delegate = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navController animated:YES completion:nil];
    });
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    DFImagesSendViewController *controller = [[DFImagesSendViewController alloc] initWithImages:@[image]];
    controller.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];

    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - DFImagesSendViewControllerDelegate

-(void)onSendTextImage:(NSString *)text images:(NSArray *)images
{
    
}

- (DFImagesSendViewControllerType)imagesSendViewControllerType {
    switch (self.type) {
        case TimeLineTypeNone:
            return DFImagesSendViewControllerTypeNone;
            break;
        case TImeLineTypeSubjectShow:
            return DFImagesSendViewControllerTypeTopic;
    }
}

- (NSString *)topicTitle {
    return @"本期主题：机器人大赛";
}

#pragma mark - DFVideoCaptureControllerDelegate
-(void)onCaptureVideo:(NSString *)filePath screenShot:(UIImage *)screenShot
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self onSendVideo:@"" videoPath:filePath screenShot:screenShot];
    });
}

-(void)onSendVideo:(NSString *)text videoPath:(NSString *)videoPath screenShot:(UIImage *)screenShot
{
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    [self onClickScrollView:cycleScrollView index:index];
}

//复写
- (void)onClickScrollView:(UIView *)cycleScrollView index:(NSInteger)index {
    
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //没用到，join活动右上角
    NSLog(@"contentOffsetyyy%f",scrollView.contentOffset.y);
    CGFloat fixContentOffset = scrollView.contentOffset.y + 64;
    UIView *footer = [self.view viewWithTag:888];
    if (footer) {
//        footer.alpha = 1.0/
    }
}

@end
