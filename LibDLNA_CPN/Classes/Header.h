//
//  Header.h
//  HsShare3.5
//
//  Created by 尚轩瑕 on 2017/11/23.
//  Copyright © 2017年 com.hisense. All rights reserved.
//

#ifndef Header_h
#define Header_h
#import <UIKit/UIKit.h>
/**
 以下所有的尺寸是在屏幕宽度为750的屏幕上的尺寸，在真机上的尺寸需要乘以真机的比例因子DivisSwift Language Versionor
 */

#define SCREEN_WIDTH                        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                       [UIScreen mainScreen].bounds.size.height

//真机与切图尺寸的比例因数，切图上给出的尺寸乘以该因数即为真正的尺寸
#define Divisor (SCREEN_WIDTH / 750.0)

#pragma mark - 影视页
#define movieBackgroundColor [UIColor whiteColor];//首页背景色

extern CGFloat const tabBarHeight;//tabBar高度

#pragma mark - 导航栏

#define NAVIGATION_BACKGROUND_COLOR                         [UIColor colorWithRed:16/255.0 green:123/255.0 blue:215/255.0 alpha:1.0]

extern CGFloat const statusBarHeight;//状态栏高度

extern CGFloat const navigationBarHeight;//导航栏高度

extern CGFloat const navigationBarBackButtonWith;//导航栏返回按钮宽度

#define navigationTextColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.85]//导航栏标题字体颜色

#pragma mark - 顶部带有巨好看logo的导航栏
extern CGFloat const logoNavigationBarHeight;//顶部带有巨好看logo的导航栏高度

extern CGFloat const logoLeftLength;//logo距离左边框距离

extern CGFloat const logoWith;//logo宽度

extern CGFloat const logoHeight;//logo高度

extern CGFloat const sideToSideLength;//搜索框与两边控件的距离

extern CGFloat const searchTextFieldWith;//搜索框宽度

extern CGFloat const searchTextFieldHeight;//搜索框高度

extern CGFloat const connectTVButtonWith;//右边我的设备按钮宽度和长度

extern CGFloat const connectTVButtonRightLength;//我的设备按钮距离右边框距离

extern CGFloat const photoButtonWith;//右边我的设备按钮宽度和长度

extern CGFloat const leftImageWith;;//中间搜索框左侧的搜索图标宽度

extern CGFloat const leftImageHeight;//中间搜索框左侧的搜索图标高度

//搜索框背景色
#define searchFieldColor [UIColor colorWithRed:231/255.0 green:232/255.0 blue:237/255.0 alpha:1.0]

#pragma mark - 电视主动截屏：TVCutScreenView

#define TVCutScreenView_BackgroundColor [UIColor colorWithRed:0x4c/255.0 green:0x51/255.0 blue:0x57/255.0 alpha:0.7]

extern CGFloat const tvScreenImageViewWidth;//电视截屏imageView宽度

extern CGFloat const tvScreenImageViewHeight;//电视截屏imageView高度

extern CGFloat const screenImageButtonInterval;//电视截屏imageView与按钮间隔

extern CGFloat const cancelButtonWith;//取消button宽度

extern CGFloat const cancelButtonHeight;//取消button宽度

extern CGFloat const buttonsInterval;//按钮左右间隔

extern CGFloat const buttonFontSize;//按钮字体大小

extern CGFloat const buttonBorderWidth;//按钮边框宽度

extern CGFloat const tvCutScreenCornerRadius;//电视主动截屏页所有控件的圆角

extern CGFloat const TVCutScreenViewTag;//电视主动截屏的提示view的tag

#define CancelButton_BackgroundColor [UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1]//取消button颜色

#define CancelButton_Pressed_BackgroundColor [UIColor colorWithRed:0xe7/255.0 green:0xe8/255.0 blue:0xed/255.0 alpha:1]//取消button按下后颜色

#define CheckButton_BackgroundColor [UIColor colorWithRed:0xce/255.0 green:0x09/255.0 blue:0x28/255.0 alpha:1]//查看button颜色

#define CheckButton_Pressed_BackgroundColor [UIColor colorWithRed:0xca/255.0 green:0x06/255.0 blue:0x21/255.0 alpha:1]//查看button按下后颜色

#define CancelButton_Font_Color [UIColor colorWithRed:0x4c/255.0 green:0x51/255.0 blue:0x57/255.0 alpha:1]//取消button字体颜色

#define CheckButton_Font_Color [UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1]//查看button字体颜色

#define Button_Border_Color [UIColor colorWithRed:0xe7/255.0 green:0xe8/255.0 blue:0xed/255.0 alpha:1]//button边框颜色

#pragma mark - mqtt
#import "GlobalUtils.h"
#define CMD_MQTT_ID  [GlobalUtils getMobileId]

#define VOICE_MQTT_ID  [[GlobalUtils getMobileId] stringByAppendingString:@"01"]

#endif /* Header_h */
