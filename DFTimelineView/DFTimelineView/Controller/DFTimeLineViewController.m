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

@interface DFTimeLineViewController ()<DFLineCellDelegate, CommentInputViewDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, DFImagesSendViewControllerDelegate,DFVideoCaptureControllerDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) NSMutableDictionary *itemDic;

@property (nonatomic, strong) NSMutableDictionary *commentDic;


@property (strong, nonatomic) CommentInputView *commentInputView;


@property (assign, nonatomic) long long currentItemId;

@property (nonatomic, strong) UIImagePickerController *pickerController;

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - BarButtonItem


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



-(void) onClickCamera:(id) sender
{
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

-(void)onComment:(long long)itemId
{
    _currentItemId = itemId;
    
    _commentInputView.commentId = 0;
    
    _commentInputView.hidden = NO;
    
    [_commentInputView show];
}


-(void)onLike:(long long)itemId
{
    
}

-(void)onClickUser:(NSUInteger)userId
{
    
}


-(void)onClickComment:(long long)commentId itemId:(long long)itemId
{
    
    _currentItemId = itemId;
    
    _commentInputView.hidden = NO;
    
    _commentInputView.commentId = commentId;
    
    [_commentInputView show];
    
    DFLineCommentItem *comment = [_commentDic objectForKey:[NSNumber numberWithLongLong:commentId]];
    [_commentInputView setPlaceHolder:[NSString stringWithFormat:@"  回复: %@", comment.userNick]];
    
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


#pragma mark - TZImagePickerControllerDelegate


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *) photos sourceAssets:(NSArray *)assets
{
    NSLog(@"%@", photos);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        DFImagesSendViewController *controller = [[DFImagesSendViewController alloc] initWithImages:photos];
        controller.delegate = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navController animated:YES completion:nil];
    });
   
    
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *) photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos
{

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

@end
