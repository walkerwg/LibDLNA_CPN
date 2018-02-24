//
//  GlobalUtils.m
//  HsShare3.5
//
//  Created by 荀晶 on 15/6/18.
//  Copyright (c) 2015年 com.hisense. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import "GlobalUtils.h"
#import <AudioToolbox/AudioServices.h>

#define DEVICE_NUM                      20

@implementation GlobalUtils

//get last app version from app library
+ (NSString *)getLastAppVersion {
    NSString *version = [[NSUserDefaults standardUserDefaults] stringForKey:@"versionCode"];
    return version;
}

//set the app version in app library
+ (void)saveAppVersion {
    [[NSUserDefaults standardUserDefaults] setObject:[self getCurAppVersion] forKey:@"versionCode"];
}

//get this app version from bundle
+ (NSString *)getCurAppVersion {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}



//get current wifi ssid
+ (NSString *)getCurWifiSSID
{
    NSString *wifiSSID = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *wifiArr = (__bridge NSArray *)wifiInterfaces;
    for (NSString *wifiObj in wifiArr) {
        CFDictionaryRef networkRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(wifiObj));
        if (networkRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)networkRef;
            //HSLog(@"network info -> %@", networkInfo);
            wifiSSID = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(networkRef);
            
            if (!IS_STR_NONE(wifiSSID)) {
                CFRelease(wifiInterfaces);
                return wifiSSID;
            }
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiSSID;
}


//get ios device id
+ (NSString *)getMobileId {
    NSString *mobileIdSrc = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *mobileIdDst = [mobileIdSrc stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSString *mobileIdDst = [@"862fff02fffefff00000fffe" stringByAppendingString:[mobileIdSrc stringByReplacingOccurrencesOfString:@"-" withString:@""]];

    //HSLog(@"mobile id is %@", mobileIdDst);
    return mobileIdDst;
}

//get ios device type return NSString
+ (NSString*)getDevTypeStr {
    NSString *devTypeStr = nil;
    switch ((NSInteger)SCREEN_HEIGHT) {
        case 480: {
            devTypeStr = @"iPhone4_";
            break;
        }
            
        case 568: {
            devTypeStr = @"iPhone5_";
            break;
        }
            
        case 667: {
            devTypeStr = @"iPhone6_";
            break;
        }
            
        case 736: {
            devTypeStr = @"iPhone6P_";
            break;
        }
            
        case 1024: {
            devTypeStr = @"iPad_";
            break;
        }
            
        default: {
            devTypeStr = @"iPhone5_";
            break;
        }
    }
    return devTypeStr;
}

+ (NSString *)getDevPreStr {
    if ([GlobalUtils isPad]) {
        return @"pad_";
    } else {
        return @"";
    }
}

//get ios device type return NSInteger
+ (enum DevType)getDevTypeInt {
    enum DevType devTypeInt;
    switch ((NSInteger)SCREEN_HEIGHT) {
        case 480: {
            devTypeInt = IPHONE4;
            break;
        }
            
        case 568: {
            devTypeInt = IPHONE5;
            break;
        }
            
        case 667: {
            devTypeInt = IPHONE6;
            break;
        }
            
        case 736: {
            devTypeInt = IPHONE6P;
            break;
        }
            
        case 1024: {
            devTypeInt = IPAD;
            break;
        }
            
        default: {
            devTypeInt = UNKNOWN;
            break;
        }
    }
    return devTypeInt;
}

//get ios device model return NSString
+ (NSString *)getDevModelStr {
    NSString *devModelStr;
    NSString *modelStr = [UIDevice currentDevice].model;
    if ([modelStr rangeOfString:@"iPad"].location != NSNotFound) {
        devModelStr = @"model_iPad";
    } else {
        devModelStr = @"model_iPhone";
    }
    return devModelStr;
}

//ios device model is pad or not
+ (BOOL)isPad {
    NSString *modelStr = [UIDevice currentDevice].model;
    if ([modelStr rangeOfString:@"iPad"].location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

//get black devices from app library
+ (NSMutableArray *)getLastBlackDevArr {
    NSMutableArray *blackDevArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"blackDevArr"];
    return blackDevArr;
}

//save black devices in app library
+ (void)saveBlackDevArr:(NSMutableArray *)blackDevArr {
    [[NSUserDefaults standardUserDefaults] setObject:blackDevArr forKey:@"blackDevArr"];
}

//get last connect dev uri from app library
+ (NSString *)getLastDevUri {
    NSString *lastDevUri = [[NSUserDefaults standardUserDefaults] objectForKey:@"devUri"];
    return lastDevUri;
}

//save dev uri in app library
+ (void)saveDevUri:(NSString *)devUri {
    [[NSUserDefaults standardUserDefaults] setObject:devUri forKey:@"devUri"];
}

//get last connect dev uri from app library
+ (NSString *)getDeviceToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    return token;
}

//save dev uri in app library
+ (void)saveDeviceToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
}

//save remote type in app library
+ (void)saveRemoteType:(NSString *)type{
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"remotetype"];
}

+ (void)saveUserInfo:(NSDictionary *)dic {
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userinfodic"];
}

+ (NSDictionary *)getUserInfo {
    NSDictionary *dir = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfodic"];
    return dir;
}

//get remote type from app library
+ (NSString *)getRemoteType{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"remotetype"];
}

//add seperator line
+ (void)addLineWithMarginT:(CGFloat)marginT superView:(UIView *)superView {
    UIView *lineImgView = [[UIView alloc] initWithFrame:CGRectMake(0, marginT, SCREEN_WIDTH, 0.5)];
    lineImgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.19];
    [superView addSubview:lineImgView];
}

//set webview cache property
+ (void)setWebViewCacheProperty {
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

//get time with interval string
+ (NSString *)getTimeWithIntervalStr:(NSString *)interval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[interval longLongValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

//get time with interval
+ (NSString *)getTimeWithInterval:(NSTimeInterval)interval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (void)deleteCookie {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    
    for (NSHTTPCookie *tempCookie in cookies) {
        [cookieStorage deleteCookie:tempCookie];
    }
}

+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

+ (NSString *)dataFilePath {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"device_connect_function.plist"];
}

+ (NSMutableArray *)getConnectedDeviceWithSSID:(NSString *)ssid{
    NSMutableArray *values = [[NSMutableArray alloc]init];
    NSMutableArray *devices;
    NSString *filePath = [self dataFilePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        devices = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    if(devices !=nil) {
        for(long i= ([devices count]-1);i>=0;i--){
            NSDictionary *dic = [devices objectAtIndex:i];
            if([[dic objectForKey:DEVICE_SSID] isEqualToString:ssid]){
                [values addObject:dic];
            }
        }
    }
    return values;
}

+ (void)saveConnectedDeviceWithSSID:(NSString *)ssid ip:(NSString *)ip sound:(NSString *)isSound ear:(NSString *)isEar cut:(NSString *)isCut{
    NSMutableArray *devices;
    NSString *filePath = [self dataFilePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        devices = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }else{
        devices = [[NSMutableArray alloc]init];
    }
    if([devices count] == DEVICE_NUM) {
        [devices removeObjectAtIndex:0];
    }
    
    for(NSDictionary *dic in devices){
        if([[dic objectForKey:DEVICE_SSID] isEqualToString:ssid] && [[dic objectForKey:DEVICE_IP] isEqualToString:ip]){
            [devices removeObject:dic];
            break;
        }
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:ssid forKey:DEVICE_SSID];
    [dic setValue:ip forKey:DEVICE_IP];
    [dic setValue:isSound forKey:DEVICE_SOUND];
    [dic setValue:isEar forKey:DEVICE_EAR];
    [dic setValue:isCut forKey:DEVICE_CUT];
    [devices addObject:dic];
    [devices writeToFile:filePath atomically:YES];
}

+ (UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSArray *)getHomeLiveCloudDataWithKey:(NSString *)key {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSArray *values = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return values;
}

+ (void)saveHomeLiveCloudDataWithKey:(NSString *)key andArray:(NSArray *)array{
    NSData *array2data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:array2data forKey:key];
}

+ (void)pressVibrate{
//    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
//    NSMutableArray* arr = [NSMutableArray array ];
//    
//    [arr addObject:[NSNumber numberWithBool:YES]]; //vibrate for 2000ms
//    [arr addObject:[NSNumber numberWithInt:2000]];
//    
//    
//    [dict setObject:arr forKey:@"VibePattern"];
//    [dict setObject:[NSNumber numberWithFloat:0.3] forKey:@"Intensity"];
//    
//    AudioServicesStopSystemSound(kSystemSoundID_Vibrate);
//    
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//    NSArray *pattern = @[@YES, @30, @NO, @1];
//    dictionary[@"VibePattern"] = pattern;
//    dictionary[@"Intensity"] = @1;
//    
//      AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, dictionary);
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}
@end
