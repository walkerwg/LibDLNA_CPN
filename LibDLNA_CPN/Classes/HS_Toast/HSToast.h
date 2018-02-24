//
//  HSToast.h
//  HsShare3.5
//
//  Created by 荀晶 on 15/8/18.
//  Copyright (c) 2015年 com.hisense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HSToast : NSObject

+ (void)showWithText:(NSString *)text;
+ (void)showWithText:(NSString *)text duration:(CGFloat)duration;

+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset;
+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration;

+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset;
+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;

+ (void)showAtDefWithText:(NSString *)text;

@end
