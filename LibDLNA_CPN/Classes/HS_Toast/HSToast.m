//
//  HSToast.m
//  HsShare3.5
//
//  Created by 荀晶 on 15/8/18.
//  Copyright (c) 2015年 com.hisense. All rights reserved.
//

#import "HSToast.h"
#import "GlobalUtils.h"

#define DEFAULT_DISPLAY_DURATION    1.5
#define DEFAULT_DISPLAY_MARGIN_B    ([GlobalUtils isPad]? 145.0:80.0)

@interface HSToast () {
    UIButton *contentView;
    CGFloat  duration;
}

@end

@implementation HSToast

- (id)initWithText:(NSString *)text{
    if (self = [super init]) {
        NSInteger textLen = [text length];
        CGFloat textLabelWidth;
        if (textLen>20) {
            textLabelWidth = 292.0;
        } else {
            textLabelWidth = textLen*14.0+12.0;
        }
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textLabelWidth, 14.0*(textLen/21+1)+12.0)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = text;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        textLabel.numberOfLines = 0;
        
        contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        contentView.layer.cornerRadius = 5.0f;
        contentView.layer.borderWidth = 0.5f;
        contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        contentView.backgroundColor = GET_COLOR(0.2, 0.2, 0.2, 0.75);
        [contentView addSubview:textLabel];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [contentView addTarget:self action:@selector(toastTaped) forControlEvents:UIControlEventTouchDown];
        contentView.alpha = 0.0f;
        
        duration = DEFAULT_DISPLAY_DURATION;
        
    }
    return self;
}

-(void)toastTaped{
    [self hideAnimation];
}

-(void)hideAnimation{
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 0.0f;
    [UIView commitAnimations];
}

-(void)dismissToast{
    [contentView removeFromSuperview];
}

- (void)setDuration:(CGFloat)showDuration{
    duration = showDuration;
}

-(void)showAnimation{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)show{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    contentView.center = window.center;
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

- (void)showFromTopOffset:(CGFloat)top{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    contentView.center = CGPointMake(window.center.x, top + contentView.frame.size.height/2);
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

- (void)showFromBottomOffset:(CGFloat)bottom{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    contentView.center = CGPointMake(window.center.x, SCREEN_HEIGHT - (bottom + contentView.frame.size.height/2));
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

+ (void)showWithText:(NSString *)text{
    [HSToast showWithText:text duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text duration:(CGFloat)duration{
    HSToast *toast = [[HSToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast show];
}

+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset{
    [HSToast showWithText:text  topOffset:topOffset duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration{
    HSToast *toast = [[HSToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast showFromTopOffset:topOffset];
}

+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset{
    [HSToast showWithText:text  bottomOffset:bottomOffset duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration{
    HSToast *toast = [[HSToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast showFromBottomOffset:bottomOffset];
}

+ (void)showAtDefWithText:(NSString *)text {
    [HSToast showWithText:text bottomOffset:DEFAULT_DISPLAY_MARGIN_B duration:DEFAULT_DISPLAY_DURATION];
}

@end
