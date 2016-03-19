//
//  DFImagesSendViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 16/2/15.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import "DFImagesSendViewController.h"
#import "DFPlainGridImageView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"

#import "TZImagePickerController.h"

#import <AssetsLibrary/AssetsLibrary.h>

#define ImageGridWidth [UIScreen mainScreen].bounds.size.width*0.7

@interface DFImagesSendViewController()<DFPlainGridImageViewDelegate,TZImagePickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) UITextView *contentView;

@property (nonatomic, strong) UIView *mask;

@property (nonatomic, strong) UILabel *placeholder;

@property (nonatomic, strong) DFPlainGridImageView *gridView;

@property (nonatomic, strong) UIImagePickerController *pickerController;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation DFImagesSendViewController

- (instancetype)initWithImages:(NSArray *) images
{
    self = [super init];
    if (self) {
        _images = [NSMutableArray array];
        if (images != nil) {
            [_images addObjectsFromArray:images];
            [_images addObject:[UIImage imageNamed:@"AlbumAddBtn"]];
        }
    }
    return self;
}

- (void)dealloc
{
    
    [_mask removeGestureRecognizer:_panGestureRecognizer];
    [_mask removeGestureRecognizer:_tapGestureRecognizer];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    
}

-(void) initView
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat x, y, width, heigh;
    x=10;
    y=74;
    width = self.view.frame.size.width -2*x;
    heigh = 100;
    _contentView = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, heigh)];
    _contentView.scrollEnabled = YES;
    _contentView.delegate = self;
    _contentView.font = [UIFont systemFontOfSize:17];
    //_contentView.layer.borderColor = [UIColor redColor].CGColor;
    //_contentView.layer.borderWidth =2;
    [self.view addSubview:_contentView];
    
    //placeholder
    _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(x+5, y+5, 150, 25)];
    _placeholder.text = @"这一刻的想法...";
    _placeholder.font = [UIFont systemFontOfSize:14];
    _placeholder.textColor = [UIColor lightGrayColor];
    _placeholder.enabled = NO;
    [self.view addSubview:_placeholder];
    
    
    _gridView = [[DFPlainGridImageView alloc] initWithFrame:CGRectZero];
    _gridView.delegate = self;
    [self.view addSubview:_gridView];
    
    
    _mask = [[UIView alloc] initWithFrame:self.view.bounds];
    _mask.backgroundColor = [UIColor clearColor];
    _mask.hidden = YES;
    [self.view addSubview:_mask];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAndTap:)];
    [_mask addGestureRecognizer:_panGestureRecognizer];
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAndTap:)];
    [_mask addGestureRecognizer:_tapGestureRecognizer];
    
    
    
    [self refreshGridImageView];
}

-(void) refreshGridImageView
{
    CGFloat x, y, width, heigh;
    x=10;
    y = CGRectGetMaxY(_contentView.frame)+10;
    width  = ImageGridWidth;
    heigh = [DFPlainGridImageView getHeight:_images maxWidth:width];
    _gridView.frame = CGRectMake(x, y, width, heigh);
    [_gridView updateWithImages:_images];
}

-(UIBarButtonItem *)leftBarButtonItem
{
    return [UIBarButtonItem text:@"取消" selector:@selector(cancel) target:self];
}

-(UIBarButtonItem *)rightBarButtonItem
{
    return [UIBarButtonItem text:@"发送" selector:@selector(send) target:self];
}

-(void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) send
{
    if (_delegate && [_delegate respondsToSelector:@selector(onSendTextImage:images:)]) {
        
        [_images removeLastObject];
        [_delegate onSendTextImage:_contentView.text images:_images];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void) onPanAndTap:(UIGestureRecognizer *) gesture
{
    _mask.hidden = YES;
    [_contentView resignFirstResponder];
}



#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""])
    {
        _placeholder.hidden = YES;
    }else if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        _placeholder.hidden = NO;
        
    }
//    if ([text isEqualToString:@"\n"]){
//        _mask.hidden = YES;
//        [_contentView resignFirstResponder];
//        if (range.location == 0)
//        {
//            _placeholder.hidden = NO;
//        }
//        return NO;
//    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _mask.hidden = NO;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    _mask.hidden = YES;
}

#pragma mark - DFPlainGridImageViewDelegate

-(void)onClick:(NSUInteger)index
{
    
    if (_images.count <9 && index == _images.count-1) {
        [self chooseImage];
    }else{
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        
        NSMutableArray *photos = [NSMutableArray array];
        NSUInteger count;
        if (_images.count > 9)  {
            count = 9;
        }else{
            count = _images.count - 1;
        }
        for (int i=0; i<count; i++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.image = [_images objectAtIndex:i];
            [photos addObject:photo];
        }
        browser.photos = photos;
        browser.currentPhotoIndex = index;
        
        [browser show];
        
    }
}


-(void)onLongPress:(NSUInteger)index
{
    
    if (_images.count <9 && index == _images.count-1) {
        return;
    }
    
    MMPopupItemHandler block = ^(NSInteger i){
        switch (i) {
            case 0:
                [_images removeObjectAtIndex:index];
                [self refreshGridImageView];
                break;
            default:
                break;
        }
    };
    
    NSArray *items = @[MMItemMake(@"删除", MMItemTypeNormal, block)];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"" items:items];
    [sheetView show];
    
}

-(void) chooseImage
{
    
    
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
    
    NSArray *items = @[MMItemMake(@"拍照", MMItemTypeNormal, block),
                       MMItemMake(@"从相册选取", MMItemTypeNormal, block)];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"" items:items];
    
    [sheetView show];
    
    
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
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(10-_images.count) delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *) photos sourceAssets:(NSArray *)assets
{
    NSLog(@"%@", photos);
    
    for (UIImage *image in photos) {
        [_images insertObject:image atIndex:(_images.count-1)];
    }
    
    [self refreshGridImageView];
    
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *) photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos
{
    
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [_images insertObject:image atIndex:(_images.count-1)];
    
    [self refreshGridImageView];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
