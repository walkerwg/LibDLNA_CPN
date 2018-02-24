//
//  GlobalUtils.h
//  HsShare3.5
//
//  Created by 荀晶 on 15/6/18.
//  Copyright (c) 2015年 com.hisense. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
#   define HSLog(fmt, ...) NSLog((@"[HS-HCI] %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define HSLog(...)
#endif

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define HTML_PAGE_LOAD_TIME_OUT             10.0
#define TOOLS_BACKGROUND_COLOR      [UIColor colorWithRed:245/255.0 green:245/255.0 blue:248/255.0 alpha:1.0]
#define BACKGROUND_COLOR                    [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]
#define CARD_BACKGROUND_COLOR               [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]
#define THEME_COLOR                         [UIColor colorWithRed:16/255.0 green:123/255.0 blue:215/255.0 alpha:1.0]
#define FONT_BLACK_COLOR                    [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85]
#define FONT_UNFOCUS_BLACK_COLOR            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.51]
#define BACK_LIGHT_GRAY_COLOR               [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]
#define BACK_GRAY_COLOR                     [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0]
#define BORDER_DARK_GRAY_COLOR              [UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1.0]
#define NORMAL_BLACK_COLOR                  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.24]
#define PRESSED_BLACK_COLOR                 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.11]
#define NORMAL_WHITE_COLOR                 [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.85]
#define DISABLE_WHITE_COLOR                 [UIColor colorWithRed:255 green:255 blue:255 alpha:0.51]
#define GET_COLOR(r, g, b, a)               [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a*1.0]
#define MAIN_COLOR_TONE                     [UIColor colorWithRed:70.0/255 green:157.0/255 blue:246.0/255 alpha:1.0]
#define FONT_GRAG_COLOR                     [UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0]

#define SCREEN_WIDTH                        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                       [UIScreen mainScreen].bounds.size.height

#define GET_STATUS_BAR_HEIGHT()             20.0//[[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATION_BAR_HEIGHT               ([GlobalUtils isPad]? 72.0:44.0)
#define NAV_BTN_MARGIN_L                    ([GlobalUtils isPad]? 12.0:8.0)
#define NAV_BTN_SIZE                        ([GlobalUtils isPad]? 48.0:32.0)
#define FONT_SIZE_16                        ([GlobalUtils isPad]? 24.0:16.0)
#define FONT_SIZE_14                        ([GlobalUtils isPad]? 21.0:14.0)
#define FONT_SIZE_12                        ([GlobalUtils isPad]? 20.0:12.0)
#define CONTENT_MARGIN_L                    ([GlobalUtils isPad]? 34.0:14.0)

#define PAD_MID_POP_VIEW_WIDTH              560.0
#define MID_POP_VIEW_WIDTH                  280.0

#define TAG_FLY_BTN_BEGINNER                1000
#define TAG_LOADING_VIEW                    1200
#define TAG_PERSON_FUNC_BTN_BEGINNER        2000
#define TAG_RC_BTN_BEGINNER                 3000
#define TAG_NET_VIDEO_CTRL_BTN_BEGINNER     4000
#define TAG_SHARE_BTN_BEGINNER              5000
#define TAG_THIRD_BTN_BEGINNER              6000
#define TAG_CATEGORY_BTN_BEGINNER           7000
#define TAG_PROGRAM_TABLEVIEW_TAG           7100

#define kWeixiAppId     @"wx0df865f991292dcb"
#define kWeixiSecret    @"d4624c36b6795d1d99dcf0547af5443d"

#define kQQAppId        @"1105034787"

#define CIBN_APP_KEY    @"YWI2MTBmNWZiMmUy"
#define CIBN_VERION     @"1.0"

#define DEVICE_SSID                     @"device_ssid"
#define DEVICE_IP                       @"device_ip"
#define DEVICE_SOUND                    @"device_sound"
#define DEVICE_EAR                      @"device_ear"
#define DEVICE_CUT                      @"device_cut"

#define LOG_REPORT_imageShare          @"imageShare"
#define LOG_REPORT_videoShare          @"videoShare"
#define LOG_REPORT_netVideoShare       @"netVideoShare"
#define LOG_REPORT_voiceAssistant      @"voiceAssistant"
#define LOG_REPORT_soundToEar          @"soundToEar"
#define LOG_REPORT_cutScreenShare      @"cutScreenShare"
#define LOG_REPORT_inputMethod         @"inputMethod"

#define MAIN_LOG_REPORT_ARR            @[@"flyVideo", @"flyLive", @"flyPhoto", @"flyApp"]
#define MAIN_BTN_TITLE_ARR             @[NSLocalizedString(@"flyVideo", nil), NSLocalizedString(@"flyLive", nil), NSLocalizedString(@"tools", nil)]

#define LOG_REPORT_remoteController    @"remoteController"

//live
#define CATEGORY_BTN_DEF_NUM           4
#define DATE_CELL_WIDTH                ([GlobalUtils isPad]? 216:90)
#define PROGRAM_CELL_HEIGHT            ([GlobalUtils isPad]? 108.0:60.0)

#define IS_STR_NONE(str)               (str == nil || [str isEqual:[NSNull null]] || [str isEqualToString:@""])
#define IS_VALUE_NONE(id)               (id == nil || [id isEqual:[NSNull null]])

#define DISCONNECT_NOTIFICATION         @"disconnect_notification"
#define REMOVE_VOICE_NOTIFICATION       @"remove_voice_notification"
#define DISCONNECT_AND_BACK_RIGHT       @"disconnect_and_back_orientation_right"
#define DEFAULT_LOGIN_NOTIFICATION      @"default_login_notification"
#define LOGIN_NOTIFICATION_NAME         @"EDULauncherNotifName"
#define LOGIN_NOTIFICATION_UPDATE       @"EduUserInfoUpdated"

//UserInfo key

#define KEY_TOKEN           @"token"
#define KEY_FRESH_TOKEN     @"refreshToken"
#define KEY_CUS_NAME        @"customerName"
#define KEY_CUS_ID          @"customerId"

// Tools
#define TOOL_PICTURE                    @"TOOL_PICTURE"//图片投影
#define TOOL_VIDEO                      @"TOOL_VIDEO"//视频投影
#define TOOL_APP                        @"TOOL_APP"//应用管理
#define TOOL_LEBO                       @"TOOL_LEBO"//乐播镜像
#define TOOL_CUT                        @"TOOL_CUT"//电视截屏
#define TOOL_VOICE                      @"TOOL_VOICE"//传音入密
#define TOOL_CLEAR                      @"TOOL_CLEAR"//清除缓存
#define TOOL_REMOTE                     @"TOOL_REMOTE"//遥控器
#define TOOL_HELP                       @"TOOL_HELP"//帮助与反馈
#define TOOL_MUSIC                      @"TOOL_MUSIC" //音乐投屏
#define CELL_WIDTH                  0.448*SCREEN_WIDTH
#define CELL_HEIGHT                 CELL_WIDTH*1/1.75
#define CELL_MARGIN                 0.016*SCREEN_WIDTH
#define TOP_MARGIN                  0.043*SCREEN_WIDTH
#define LINE_MARGIN                  0.035*SCREEN_WIDTH
#define COLUMN_MARGIN                0.032*SCREEN_WIDTH
#define BRODER_COLOR                [UIColor colorWithRed:231/255.0 green:232/255.0 blue:237/255.0 alpha:1.0]
#define NAMETEXT_COLOR              [UIColor colorWithRed:76/255.0 green:81/255.0 blue:87/255.0 alpha:1.0]
#define IMAGE_SIZE  0.075*SCREEN_WIDTH
#define SUBNAME_TEXTCOLOR           [UIColor colorWithRed:133/255.0 green:142/255.0 blue:152/255.0 alpha:1.0]
#define ICON_IMAGE_WIDTH            0.072*SCREEN_WIDTH
#define ICON_IMAGE_HEIGHT           0.085*SCREEN_WIDTH
#define HEADER_LEFT_MARGIN          0.01*SCREEN_WIDTH
#define ARROW_WIDTH                 0.024 *SCREEN_WIDTH
#define ARROW_HEIGHT                ARROW_WIDTH*2
#define HEADER_VIEW_HEIGHT          0.32*SCREEN_WIDTH
#define MUSIC_TOPMARGIN             0.02*SCREEN_WIDTH
#define MUSIC_CELL_HEIGHT           0.16*SCREEN_WIDTH

#define HOME_LAST_DATA                  @"home_last_data"//上一次主页数据
#define LIVE_LAST_DATA                  @"live_last_data"//上一次直播数据
#define LIVE_CATEGORY_DATA              @"live_category_data"//上一次分类数据
#define HOME_CATEGORY_DATA              @"home_category_data"//上一次分类数据


#define SHOWTYPE0         0 //-- 模板
#define SHOWTYPE1         1 //-- 单行轮播     首页轮转图片（首页）
#define SHOWTYPE2         2 //-- 一行一列    活动（无）
#define SHOWTYPE3         3 // -- 一行两列   今日热点／热门综艺 （首页＋频道）
#define SHOWTYPE4         4 //-- 一行三列   电影／电视剧／少儿动漫（电视剧／少儿动漫有阴影显示更新到多少）（首页）
#define SHOWTYPE5         5 //-- 一行半列(聚好看)	首页即将上线（首页）
#define SHOWTYPE6         6 //-- 引导栏展示方式	首页历史等标签（首页）
#define SHOWTYPE7         7 //-- 一行半列（频道）	经典频道 （频道）
#define SHOWTYPE8         8 //-- 一行半列(直播节目)  精彩预约 （频道）
#define SHOWTYPE9         9 // -- 一行两列   今日热点／热门综艺 （首页＋频道）?

enum DevType {
    UNKNOWN = (-1),
    IPHONE4,
    IPHONE5,
    IPHONE6,
    IPHONE6P,
    IPAD = (4)
};

typedef enum _HomeStencil {
    HOME_FIRST = (1), //新闻／直播类 今日热点
    HOME_SECOND,//综艺／新闻类 热门综艺
    HOME_THIRD,//电视剧／动漫／少儿类 热播电视剧
    HOME_FOUR,//电影／动漫／少儿类 热门电影
    HOME_FIVE,//综艺动漫类 少儿动漫
    HOME_SIX,//即将上线
    LIVE_FIRST,//直播 经典频道
    LIVE_SECOND,//直播 今日热点
    LIVE_THIRD = (9)//直播 热门综艺
}HomeStencil;

typedef enum _DetailStencil {
    DETAIL_MOVIE = (1004), //电影
    DETAIL_MUSIC = (1006), //音乐

    DETAIL_TV = (1001),//电视剧
    DETAIL_ANIME = (1005),//动漫

    DETAIL_VARIETY = (1002),//综艺
    DETAIL_S_D = (1003),//体育 纪录片

    DETAIL_NEWS = (1009),//新闻

    DETAIL_OTHER = (1100), //其他

    DETAIL_KIDS = (1012), //少儿
}DetailStencil;

@interface GlobalUtils : NSObject

//get last app version from app library
+ (NSString *)getLastAppVersion;

//save the app version in app library
+ (void)saveAppVersion;

//get this app version from bundle
+ (NSString *)getCurAppVersion;

//whether should show guide page or not
+ (BOOL)shouldShowGuidePage:(UIView *)pView;

//get net state
//typedef enum : NSInteger {
//    NotReachable = 0,
//    ReachableViaWiFi,
//    ReachableViaWWAN
//} NetworkStatus;

//get current wifi ssid
+ (NSString *)getCurWifiSSID;

//get net url reachability
+ (BOOL)pingNetWithUrl:(NSString*)url;

//get ios device id
+ (NSString *)getMobileId;

//get ios device type return NSString
//@"iPhone4"
//@"iPhone5"
//@"iPhone6"
//@"iPhone6P"
//@"iPad"
//@"unknown"
+ (NSString*)getDevTypeStr;

+ (NSString *)getDevPreStr;

//get ios device type return NSInteger
+ (enum DevType)getDevTypeInt;

//get ios device model return NSString
//@"model_iPhone"
//@"model_iPad"
+ (NSString *)getDevModelStr;

//ios device model is pad or not
+ (BOOL)isPad;

//get black devices from app library
+ (NSMutableArray *)getLastBlackDevArr;

//save black devices in app library
+ (void)saveBlackDevArr:(NSMutableArray *)blackDevArr;

//get last connect dev uri from app library
+ (NSString *)getLastDevUri;

//save dev uri in app library
+ (void)saveDevUri:(NSString *)devUri;

//save dev in app library
+ (void)saveConnectedDeviceWithSSID:(NSString *)ssid ip:(NSString *)ip sound:(NSString *)isSound ear:(NSString *)isEar cut:(NSString *)isCut;

//get connected dev from app library
+ (NSMutableArray *)getConnectedDeviceWithSSID:(NSString *)ssid;

//save remote type in app library
+ (void)saveRemoteType:(NSString *)type;

//get remote type from app library
+ (NSString *)getRemoteType;

//add seperator line
+ (void)addLineWithMarginT:(CGFloat)marginT superView:(UIView *)superView;

//set webview cache property
+ (void)setWebViewCacheProperty;

//get time with interval string
+ (NSString *)getTimeWithIntervalStr:(NSString *)interval;

//get time with interval
+ (NSString *)getTimeWithInterval:(NSTimeInterval)interval;

+ (void)deleteCookie;
//get current Presented viewcontroller
+ (UIViewController *)getPresentedViewController;
//color to image
+ (UIImage*) imageWithColor:(UIColor*)color;

//save home/live cloud data
+ (void)saveHomeLiveCloudDataWithKey:(NSString *)key andArray:(NSArray *)array;

//get home/live cloud data
+ (NSArray *)getHomeLiveCloudDataWithKey:(NSString *)key;
+ (void)pressVibrate;
+ (NSString *)getDeviceToken;
+ (void)saveDeviceToken:(NSString *)token;
+ (void)saveUserInfo:(NSDictionary *)dic;
+ (NSDictionary *)getUserInfo;
@end
