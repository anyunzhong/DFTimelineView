//
//  CommentInputView.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/10.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "CommentInputView.h"

#define InputViewPadding 8
#define InputSendButtonWidth 60

#define InputViewObserveKeyPath @"inputViewOffsetY"

#define InputViewHeight 50

#define SendButtonColor [UIColor colorWithRed:116/255.0 green:135/255.0 blue:173/255.0 alpha:1.0]

@interface CommentInputView()<UITextFieldDelegate>

@property (strong,nonatomic) UIView *inputView;

@property (strong,nonatomic) UITextField *inputTextView;

@property (strong,nonatomic) UIButton *sendButton;

@property (strong, nonatomic) UIView *maskView;


@property (assign, nonatomic) CGFloat inputViewOffsetY;


@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;


@property (assign, nonatomic) NSTimeInterval keyboardAnimationDuration;
@property (assign, nonatomic) NSUInteger keyboardAnimationCurve;


@end


@implementation CommentInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _keyboardAnimationDuration = 0.25;
        _keyboardAnimationCurve = 7;
        
        [self initView];
    }
    return self;
}


- (void)dealloc
{
    [_maskView removeGestureRecognizer:_panGestureRecognizer];
    [_maskView removeGestureRecognizer:_tapGestureRecognizer];
}




-(void) initView
{
    
    CGFloat x, y, width, height;
    
    
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:self.frame];
        [self addSubview:_maskView];
        _maskView.backgroundColor = [UIColor darkGrayColor];
        _maskView.alpha = 0.4;
        _maskView.hidden = YES;
    }

    
    
    width = CGRectGetWidth(self.frame);
    height = InputViewHeight;
    x= 0;
    y= CGRectGetHeight(self.frame)- height;
    
    _inputView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _inputView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
    _inputView.hidden = YES;
    
    [self addSubview:_inputView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
    line.backgroundColor = [UIColor darkGrayColor];
    [_inputView addSubview:line];
    
    
    if (_sendButton == nil) {
        x = CGRectGetWidth(self.frame) - InputSendButtonWidth - InputViewPadding;
        width = InputSendButtonWidth;
        y = InputViewPadding;
        height = InputViewHeight - 2*InputViewPadding;
        
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _sendButton.layer.cornerRadius = 15;
        _sendButton.clipsToBounds = YES;
        _sendButton.backgroundColor = SendButtonColor;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(onInputSendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_inputView addSubview:_sendButton];
    }
    
    if (_inputTextView == nil) {
        
        x = InputViewPadding;
        y = InputViewPadding;
        width = CGRectGetMinX(_sendButton.frame)-2*InputViewPadding;
        
        
        _inputTextView = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [_inputView addSubview:_inputTextView];
        
        _inputTextView.keyboardType = UIKeyboardTypeDefault;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.layer.borderWidth = 0.5;
        _inputTextView.layer.cornerRadius = 15;
        _inputTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _inputTextView.font = [UIFont systemFontOfSize:15];
        
        _inputTextView.delegate = self;
    }
    
    
    
    
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onTableViewPanAndTap:)];
        [_maskView addGestureRecognizer:_panGestureRecognizer];
        _panGestureRecognizer.maximumNumberOfTouches = 1;
        
    }
    
    if (_tapGestureRecognizer == nil) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTableViewPanAndTap:)];
        [_maskView addGestureRecognizer:_tapGestureRecognizer];
    }

    
}





#pragma mark - Notification

-(void) addNotify

{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboradShow:) name:UIKeyboardWillShowNotification object:nil];
}


-(void) removeNotify

{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];

}



#pragma mark - Keyboard

-(void) onKeyboradShow:(NSNotification *) notify
{
    NSDictionary *info = notify.userInfo;
    CGRect frame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    _keyboardAnimationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [self changeInputViewOffsetY:(frame.origin.y - InputViewHeight) ];
    
}



#pragma mark - Observer

-(void) addObserver
{
    [self addObserver:self forKeyPath:InputViewObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
}


-(void) removeObserver
{
    [self removeObserver:self forKeyPath:InputViewObserveKeyPath];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:InputViewObserveKeyPath]) {
        CGFloat newOffsetY = [[change valueForKey:NSKeyValueChangeNewKey] floatValue];
        
        [self changeInputViewPosition:newOffsetY];
    }
    
}


#pragma mark - UITextFieldDelegate


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendComment];
    
    return YES;
}


#pragma mark - Method

-(void) changeInputViewOffsetY:(CGFloat) offsetY
{
    [self setValue: [NSNumber numberWithDouble:offsetY] forKey:InputViewObserveKeyPath];
    
}

-(void) changeInputViewPosition:(CGFloat) newOffsetY
{
    CGFloat x,y,width,height;
    CGRect frame = _inputView.frame;
    x = frame.origin.x;
    y = newOffsetY;
    width = frame.size.width;
    height = frame.size.height;
    
    _maskView.hidden = !(newOffsetY < (self.frame.size.height - InputViewHeight));
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:_keyboardAnimationDuration];
    [UIView setAnimationCurve:_keyboardAnimationCurve];
    
    _inputView.frame = CGRectMake(x, y, width, height);
    
    [UIView commitAnimations];
}



-(void) onTableViewPanAndTap:(UIGestureRecognizer *) gesture
{
    [self hideInputView];
    
}


-(void) onInputSendButtonClick:(UIButton *) button
{
    
    [self sendComment];
}

-(void) sendComment
{
    [self hideInputView];
    
    NSString *text = _inputTextView.text;
    
    if ([text isEqualToString:@""]) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(onCommentCreate:text:)]) {
        [_delegate onCommentCreate:_commentId text:text];
    }
    
    _inputTextView.text = @"";
}


-(void) hideInputView
{
    
    
    self.hidden = YES;
    
    [_inputTextView resignFirstResponder];
    _inputTextView.placeholder = @"";
    _inputView.hidden = YES;
    
    CGFloat offsetY = CGRectGetHeight(self.frame) - InputViewHeight ;
    [self changeInputViewPosition:offsetY];
}




-(void)show
{
    
    _inputView.hidden = NO;
    [_inputTextView becomeFirstResponder];
}


-(void)setPlaceHolder:(NSString *)text
{
    _inputTextView.placeholder = text;
}


@end
