//
//  DLNAObject.m
//  HsShare3.5
//
//  Created by Lisa Xun on 15/6/23.
//  Copyright (c) 2015年 com.hisense. All rights reserved.
//

#import "DLNAObject.h"
#import "PrivateObject.h"

#import "MqttAndPrivateComu.h"
#import "GlobalUtils.h"
#define VIDAA3_SIGN          @"#CAP#"
#define INPUT_METHOD_SIGN    @"input"
#define VOICE_ASSIST_SIGN    @"voice"
#define RC_SIGN              @"remote"
#define CYRM_SIGN            @"wire"
#define CUT_SCREEN_SIGN      @"cap"
#define EDIT_NAME_SIGN       @"setname"
#define SUI_XIN_SIGN         @"suixin"
#define NUMERIC_KEY          @"numerickey"

//通信协议：mqtt 或者私有协议
#define MQTT                 @"MQTT"
#define PrivateProtocol      @"PrivateProtocol"

#define VOICE_DEF_PORT        20000

//For DLNA tv event
#define UPNP_AVT_VAR_TRANSPORTSTATE "TransportState"
#define UPNP_RC_VAR_VONUME "Volume"
#define UPNP_RC_VAR_MUTE "Mute"

#define UPNP_PLAYING "PLAYING"
#define UPNP_PAUSE "PAUSED_PLAYBACK"
#define UPNP_STOPPED "STOPPED"

@interface DLNAObject () <NSXMLParserDelegate, ConnectResultDelegate> {
    NSMutableArray *blackDevArr;
    
    NSString *xmlNode;
    NSString *xmlBlackDevsValue;
    
    PrivateObject *privateObj;
    NSTimer *readProgressTimer;
    BOOL startConnect;
}

/**
 通信model
 */
@property (nonatomic, strong) MqttAndPrivateComu *mqttAndPrivaComu;

@end

@implementation DLNAObject

+ (DLNAObject *)shareDlnaObj {
    static DLNAObject *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DLNAObject alloc] init];
        [sharedInstance initDlnaObj];
        [sharedInstance initBlackDevArr];
    });
    return sharedInstance;
}

- (void)initDlnaObj {
    _isDlnaStarted = NO;
    _devArr = [[NSMutableArray alloc] init];
    _curDevIndex = -1;
    _voicePort = VOICE_DEF_PORT;
    startConnect=NO;
    [self resetDevAbility];

}


- (void)resetDevAbility {
    _canCutScreen = NO;
    _canCYRM = NO;
    _canEditName = NO;
    _canInputMethod = NO;
    _canNumerickey = NO;
    _canRC = NO;
    _canSUIXIN = NO;
    _canVoiceAssist = NO;
    _canPushLive = NO;
}


- (void)initBlackDevArr {
    NSArray *knownBlackDevArr = [NSArray arrayWithObjects:@"PPTV", @"优酷", @"搜狐", nil];
    NSMutableArray *lastBlackDevArr = [GlobalUtils getLastBlackDevArr];
    
    blackDevArr = [[NSMutableArray alloc] init];
    if (lastBlackDevArr) {
        blackDevArr = [lastBlackDevArr mutableCopy];
    } else {
        blackDevArr = [knownBlackDevArr mutableCopy];
        [GlobalUtils saveBlackDevArr:blackDevArr];
    }
    
    xmlBlackDevsValue = @"";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *blackDevsURLStr = @"http://hiapp.hismarttv.com/down/vidaa3share/deviceavoidlist.xml";
        NSURL *blackDevsURL = [NSURL URLWithString:[blackDevsURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:blackDevsURL];
        request.timeoutInterval = 3.0;
        NSData *blackDevsData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSXMLParser *blackDevsXMLParser = [[NSXMLParser alloc] initWithData:blackDevsData];
        blackDevsXMLParser.delegate = self;
        [blackDevsXMLParser parse];
        
        NSArray *netBlackDevArr = [xmlBlackDevsValue componentsSeparatedByString:@"#"];
        
        for (NSString *netBlackDev in netBlackDevArr) {
            if (![netBlackDev isEqualToString:@""]) {
                BOOL addFlag = YES;
                for (NSString *existBlackDev in blackDevArr) {
                    if ([netBlackDev isEqualToString:existBlackDev]) {
                        addFlag = NO;
                        break;
                    }
                }
                if (addFlag) {
                    [blackDevArr addObject:netBlackDev];
                }
            }
        }
        [GlobalUtils saveBlackDevArr:blackDevArr];
    });
}


/**
 自动添加设备进行连接
 */
void dmcStartCB(UpnpDevType *discovery, UPNPDevState state){
    //1.kFriendlyName
    NSString *devName = @(discovery->friendlyName);
    switch (state) {
        case UPNP_DEVADD: {
            HSLog(@"===%@ dev state===/**Online*/", devName);
            
            //2.kUuid
            NSString *devUdn = @(discovery->udn);
            //3.kUri
            NSString *devUri = @(discovery->uri);
            NSLog(@"dlna__uri:%@", devUri);
            //4.kIp
            NSRange httpPreRange = [devUri rangeOfString:@"http://"];
            NSString *tmpIp = [devUri substringFromIndex:(httpPreRange.location+httpPreRange.length)];
            NSRange ipSufRange = [tmpIp rangeOfString:@":"];
            NSString *devIp = [tmpIp substringToIndex:ipSufRange.location];
            //5.kModelDescription discovery->modeldescription maybe is nil
            NSString *devDescription;
            NSString *devTransportProtocol;//设备支持的通信协议，1为mqtt，2为私有协议
            if (discovery->modeldescription == nil) {
                devDescription = @"";
            } else {
                devDescription = @(discovery->modeldescription);
                NSLog(@"devDescription__:%@", devDescription);
                //电视通信协议，1为mqtt，2为私有协议
                if ([devDescription containsString:@"transport_protocol=1"] ) {
                    devTransportProtocol = MQTT;
                } else {
                    devTransportProtocol = PrivateProtocol;
                }
            }
            NSLog(@"transport__:%@",devTransportProtocol);
            
            NSMutableDictionary *devDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:devName, kFriendlyName, devUdn, kUdn, devUri, kUri, devIp, kIp, devDescription, kModelDescription, devTransportProtocol, kTransportProtocol, nil];
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"addDev" object:devDic];
//            });
            DLNAObject *thisObj = [DLNAObject shareDlnaObj];
            [thisObj addDev:devDic];
            
            break;
        }
            
        case UPNP_DEVUPDATE: {
            HSLog(@"===%@ dev state===/**Update*/", devName);
            
            //2.kUuid
            NSString *devUdn = @(discovery->udn);
            //3.kUri
            NSString *devUri = @(discovery->uri);
            //4.kIp
            NSRange httpPreRange = [devUri rangeOfString:@"http://"];
            NSString *tmpIp = [devUri substringFromIndex:(httpPreRange.location+httpPreRange.length)];
            NSRange ipSufRange = [tmpIp rangeOfString:@":"];
            NSString *devIp = [tmpIp substringToIndex:ipSufRange.location];
            //5.kModelDescription
            NSString *devDescription;
            NSString *devTransportProtocol;//设备支持的通信协议，1为mqtt，2为私有协议
            if (discovery->modeldescription == nil) {
                devDescription = @"";
            } else {
                devDescription = @(discovery->modeldescription);
                //电视通信协议，1为mqtt，2为私有协议
                if ([devDescription containsString:@"transport_protocol=1"] ) {
                    devTransportProtocol = MQTT;
                } else {
                    devTransportProtocol = PrivateProtocol;
                }
            }
            NSLog(@"transport__:%@",devTransportProtocol);
            
            NSMutableDictionary *devDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:devName, kFriendlyName, devUdn, kUdn, devUri, kUri, devIp, kIp, devDescription, kModelDescription, devTransportProtocol, kTransportProtocol, nil];
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"addDev" object:devDic];
//            });
            DLNAObject *thisObj = [DLNAObject shareDlnaObj];
            [thisObj addDev:devDic];
            break;
        }
        
        case UPNP_DEVINVALID: {
            HSLog(@"===%@ dev state===/**Invalid*/", devName);
            break;
        }
            
        case UPNP_DEVREMOVE: {
            HSLog(@"===%@ dev state===/**Byebye*/", devName);
//            NSString *devUri = @(discovery->uri);
//            
////            dispatch_async(dispatch_get_main_queue(), ^{
////                [[NSNotificationCenter defaultCenter] postNotificationName:@"removeDev" object:devUri];
////            });
//            DLNAObject *thisObj = [DLNAObject shareDlnaObj];
//            [thisObj removeDev:devUri];
//            
            break;
        }
            
        case UPNP_DEVGETALL: {
            HSLog(@"===%@ dev state===/**For get all, same as online.*/", devName);
            break;
        }
            
        default: {
            break;
        }
    }
}


- (enum DlnaStartRes)startDLNA {
    if (!_isDlnaStarted) {
        NSString *mediaserverPath = [[NSBundle mainBundle] resourcePath];
        int res1 = UPNP_Init(mediaserverPath.UTF8String, NULL);
        if (0 == res1) {
            int res2 = UPNP_DmsStart(NO);
            if (res2 != 0) {
                return UPNPDmsStartFail;
            }
            
            int res3 = UPNP_DmcStart(NO, YES, dmcStartCB);
            if (res3 != 0) {
                return UPNPDmcStartFail;
            }
        } else {
            return UPNPInitFail;
        }
        
        self.mqttAndPrivaComu = [MqttAndPrivateComu shareMqttAndPrivateComu];
        self.mqttAndPrivaComu.connectResultDelegate = self;
        
        _isDlnaStarted = YES;
        return DLNAStartOK;
    }
    return DLNAStartRepeat;
}


- (int)finishDLNA {
    if (_isDlnaStarted) {
        int res = UPNP_Finish();
        if (res == 0) {
            _isDlnaStarted = NO;
            
            [self setCurDevIndex:-1];
            
            [self clearDevArr];
        }
        return res;
    }
    return 0;
}


- (int)researchDlnaDev {
    int res = UPNP_DmcResearch();
    if (res == 0) {
        [self setCurDevIndex:-1]; //断开连接
        [self clearDevArr]; //清空设备列表
    }
    return res;
}


- (void)clearDevArr {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_devArr removeAllObjects];
        [_devArrDelegate devArrUpdate];
    });
}


/**
 向设备列表中添加设备
 
 @param thisDevDic 待添加的设备的字典，字典内为设备的各种信息
 */
- (void)addDev:(NSMutableDictionary *)thisDevDic {
    BOOL addFlag1 = YES;
    //如果发现的设备是黑名单中的设备，如pptv等，则不添加
    for (NSString *blackDevName in blackDevArr) {
        if ([thisDevDic[kFriendlyName] rangeOfString:blackDevName].location != NSNotFound) {
            addFlag1 = NO;
            break;
        }
    }
    if (addFlag1) {
        BOOL addFlag2 = YES;
        //如果已经存在某个设备了，就不添加该设备了，使用kUri的原因应该是设备的名字可能一样但是uri不会一样。
        for (NSMutableDictionary *devDic in _devArr) {
            if ([devDic[kUri] isEqualToString:thisDevDic[kUri]]) {
                addFlag2 = NO;
                break;
            }
        }
        
        if (addFlag2) {
            [_devArr addObject:thisDevDic];
            [_devArrDelegate devArrUpdate];//设备数组更新
            NSString *lastDevUri = [GlobalUtils getLastDevUri];
            
            if ([thisDevDic[kUri] isEqualToString:lastDevUri]) {
                /**临时注释
                [self setCurDevIndex:(_devArr.count-1)];
                 */
            }
            
            if (!startConnect) {
                /**临时注释
                [self setCurDevIndex:0];
                 */
                if (lastDevUri == nil) {
                    [GlobalUtils saveDevUri:thisDevDic[kUri]];
                    self.mqttAndPrivaComu.currentIp = thisDevDic[kIp];
                }
            }
        }
    }
}

    
/**
 获取指定设备的ID
 
 @param index 指定设备的索引
 */
- (void)getCurDevIdWithIndex:(NSInteger)index {
    NSString *getDevIdURLStr = [NSString stringWithFormat:@"http://%@:7778/..deviceid", [_devArr objectAtIndex:index][kIp]];
    NSURL *getDevIdURL = [NSURL URLWithString:[getDevIdURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:getDevIdURL];
    request.timeoutInterval = 3.0;
    NSData *getDevIdData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *devId = [[NSString alloc] initWithData:getDevIdData encoding:NSUTF8StringEncoding];
        //HSLog(@"wexin app return devId is %@", devId);
    //HSLog(@"curindex IS %ld",(long)index);
    NSRange htmlRange = [devId rangeOfString:@"<html>"];
    if (htmlRange.location != NSNotFound) {
        _curDevId = @"";
    } else {
        _curDevId = devId;
    }
}

- (void)getPushLiveAbility:(NSInteger)index {
    if (_devArr.count>index) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@:7778/..pushcibnsupport", [_devArr objectAtIndex:index][kIp]];
        NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.timeoutInterval = 3.0;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *abilityStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //HSLog(@"wexin app return push live ability is %@", abilityStr);
        
        //    NSRange htmlRange = [abilityStr rangeOfString:@"<html>"];
        //    if (htmlRange.location != NSNotFound) {
        //        _canPushLive = NO;
        //    } else {
        _canPushLive = [abilityStr isEqualToString:@"true"];
        //    }
    }

}

/**
 获取指定设备的通信方式，mqtt还是私有协议，或者其它

 @param index 指定设备
 */
- (void)getDevTransportProtocol:(NSInteger)index {
    NSString *transportProtocolStr = [_devArr objectAtIndex:index][kTransportProtocol];
    if ([transportProtocolStr isEqualToString:MQTT]) {
        self.mqttAndPrivaComu.devTransportProtocol = TransportProtocolMQTT;
    } else if ([transportProtocolStr isEqualToString:PrivateProtocol]){
        self.mqttAndPrivaComu.devTransportProtocol = TransportProtocolPrivateObject;
    }
}

/**
 设置当前设备的索引，在设置索引时，启动私有协议连接设备，并根据设备的能力更新model中各种设备能力标志如canCutScreen等
 
 @param index 设备页面，连接了哪台设备，index就是该设备在_devArr数组中的索引;-1或-2为断开连接
 */
- (void)setCurDevIndex:(NSInteger)index {
    startConnect=YES;
    self.mqttAndPrivaComu.isFinalConnected = NO;//默认电视有私有协议or mqtt
    [self resetDevAbility];//重置设备的各项能力
    
    if (index != -1 && index != -2) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _curDevIndex = index;
            // 1.
            [self getCurDevIdWithIndex:index];//获取当前索引设备的ID
            dispatch_async(dispatch_get_main_queue(), ^{
                //[_loadingViewDelegate dismissLoadingView];
                [_loadingViewDelegate showLoadingView];
                [_updateCurDevDelegate tvDevIdCallback];//并发送广播：设备ID改变
            });
            // 2.
            [self getPushLiveAbility:index];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设备直播推送能力改变
                [_livePushDelegate tvPushLiveAbilityCallback];
            });
            // 3.
            if(YES) {
                [self getDevTransportProtocol:index];//获取当前指定索引的通信方式
                [self.mqttAndPrivaComu clientConnect];//iPhone与电视开启连接
                //连接结果在ConnectResultDelegate委托函数中获取
            }
        });
    } else {//-1表示没有设备，-2表示主动断开连接。
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.mqttAndPrivaComu clientDisconnect];
        });
        _curDevId = @"";
        dispatch_async(dispatch_get_main_queue(), ^{
            [_updateRCViewDelegate updateRCViewWithIndex:index];//更新悬浮遥控器按钮的状态
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_curDevDelegate curDevChangeToIndex:index];
        [_updateRCVCDelegate updateRCVCWithIndex:index];
        [_updateCYRMDelegate updateCYRMWithIndex:index];
    });
}

#pragma mark - ConnectResultDelegate

/**
 客户端连接结果，可以在此委托中刷新被连接设备的info

 @param connectResult 连接结果
 */
- (void)clientConnectResult:(BOOL)connectResult {
    if (connectResult) {
        NSInteger index = self.curDevIndex;
        if (_devArr.count > index) {//防止在连接时dlna设备突然下线
            //获取设备的各项能力
            NSString *modelDesc = [_devArr objectAtIndex:index][kModelDescription];
            HSLog(@"current dev modelDesc is %@", modelDesc);
            NSRange range = [modelDesc rangeOfString:VIDAA3_SIGN];
            if (range.location != NSNotFound) {
                _canInputMethod = [self getDevAbility:INPUT_METHOD_SIGN];
                _canVoiceAssist = [self getDevAbility:VOICE_ASSIST_SIGN];
                _canNumerickey = [self getDevAbility:NUMERIC_KEY];
                _canRC = [self getDevAbility:RC_SIGN];
                _canCYRM = [self getDevAbility:CYRM_SIGN];
                _canCutScreen = [self getDevAbility:CUT_SCREEN_SIGN];
                _canEditName = [self getDevAbility:EDIT_NAME_SIGN];
                _canSUIXIN = [self getDevAbility:SUI_XIN_SIGN];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_updateRCVCDelegate updateRCVCWithIndex:index];
                    [_updateEditTVNameDelegate updateEditTVNameWithIndex:index];
                });
                self.mqttAndPrivaComu.currentIp = [_devArr objectAtIndex:index][kIp];
                _curDevIndex = index;
                [GlobalUtils saveConnectedDeviceWithSSID:[GlobalUtils getCurWifiSSID] ip:self.mqttAndPrivaComu.currentIp sound:_canVoiceAssist?@"1":@"0" ear:_canCYRM?@"1":@"0" cut:_canCutScreen?@"1":@"0"];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_updateRCVCDelegate updateRCVCWithIndex:index];
                    _curDevIndex = index;
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mqttAndPrivaComu.isFinalConnected = NO;
            [_loadingViewDelegate dismissLoadingView];
            [_loadingViewDelegate showRCView];
            [_updateRCViewDelegate updateRCViewWithIndex:index];
            _curDevIndex = index;
            //  [_updateConnectStatusDelegate updateConnectStatus:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLoading" object:nil userInfo:nil];
        });
    } else {//如果连接失败
        dispatch_async(dispatch_get_main_queue(), ^{
            privateObj.isFinalConnected = YES;
            [_loadingViewDelegate dismissLoadingView];
            [_updateConnectStatusDelegate updateConnectStatus:NO];
            [_updateRCViewDelegate updateDisConnectStatus];
            [_updateConnectStatusDelegate reloadDevList];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLoading" object:nil userInfo:nil];
        });
    }
}

/**
 根据标志位获取设备的能力
 
 @param sign 标志位
 @return YES如果能，否则NO
 */
- (BOOL)getDevAbility:(NSString *)sign {
    NSString *modelDesc = [_devArr objectAtIndex:self.curDevIndex][kModelDescription];
    NSRange abilityRange = [modelDesc rangeOfString:sign];
    return (abilityRange.location != NSNotFound);
    
}

- (void)removeDev:(NSString *)thisDevUri {
    for (int i=0; i<_devArr.count; i++) {
        NSMutableDictionary *devDic = [_devArr objectAtIndex:i];
        if ([devDic[kUri] isEqualToString:thisDevUri]) {
            [_devArr removeObject:devDic];
            [_devArrDelegate devArrUpdate];
            if (i == _curDevIndex) {
                [self setCurDevIndex:-1];
            }
            break;
        }
    }
}

int localResPushCallback(IOSCMD cmd, IOSCMDPara* param) {
    DLNAObject *thisObj = [DLNAObject shareDlnaObj];
    int iRet = -222;
    switch (cmd) {
        case GET_MEDIAINFO: {
            if(thisObj != nil) {
                if ([thisObj isKindOfClass:DLNAObject.class]) {
                    
                    if (thisObj.pushLocalResData != nil) {
                        param->info->size = thisObj.pushLocalResData.length;
                        param->info->title = strdup(thisObj.pushLocalResTitle.UTF8String);
                        param->info->mime = strdup(thisObj.pushLocalResMime.UTF8String);
                        param->info->duration = strdup(thisObj.pushLocalResDuration.UTF8String);
                        
                        HSLog(@"1======GET_MEDIAINFO (%s) size:%lld ,mime:%s ,duration:%s======", param->info->title, param->info->size, param->info->mime, param->info->duration);
                        iRet = 0;
                    } else {
                        iRet = -1;
                    }
                    
                } else {
                    iRet = -1;
                }
            } else {
                iRet = -1;
            }
            break;
        }
            
        case OPEN_STREAM: {
            HSLog(@"2======OPEN_STREAM (%@) ======", thisObj.pushLocalResTitle);
            iRet = 0;
            break;
        }
            
        case READ_STREAM: {
            if (thisObj != nil) {
                if ([thisObj isKindOfClass:DLNAObject.class]) {
                    
                    if (thisObj.pushLocalResData != nil) {
                        long long readSize = param->size;
                        long long offset = param->offset;
                        long long sendSize;
                        if (thisObj.pushLocalResData.length < offset) {
                            sendSize = 0;
                        } else if (thisObj.pushLocalResData.length-offset >= readSize) {
                            sendSize = readSize;
                        } else {
                            sendSize = thisObj.pushLocalResData.length-offset;
                        }
                        
                        if (sendSize > 0) {
                            NSRange sendRange = NSMakeRange((NSUInteger)offset, (NSUInteger)sendSize);
                            [thisObj.pushLocalResData getBytes:param->buf range:sendRange];
                            HSLog(@"3======READ_STREAM (%@) from (%lld) to (%lld) ======", thisObj.pushLocalResTitle, offset, (offset+sendSize-1));
                        }
                        
                        iRet = (int)sendSize;
                    } else {
                        iRet = -1;
                    }
                    
                } else {
                    iRet = -1;
                }
            } else {
                iRet = -1;
            }
            
            break;
        }
            
        case CLOSE_STREAM: {
            HSLog(@"4======CLOSE_STREAM (%@) ======", thisObj.pushLocalResTitle);
            iRet = 0;
            break;
        }
            
        default: {
            break;
        }
    }
    
    return iRet;
}

int remoteTVEventCallback (char* renderer, const char *variableName,
                           const char* value, const char* additionalInfo)
{
    DLNAObject* dlnaObj = [DLNAObject shareDlnaObj];
    NSLog(@"remoteTVEventCallback:%s, %s", variableName, value);
    if (strcmp(variableName, UPNP_AVT_VAR_TRANSPORTSTATE) == 0) {
        dlnaObj.dlnaPlayState = NONE;
        if (strcmp(value, UPNP_PLAYING) == 0) {
            NSLog(@"playing......");
            [dlnaObj startReadPlayProgress];
            dlnaObj.dlnaPlayState = PLAYING;

        } else if (strcmp(value, UPNP_PAUSE) == 0) {
            NSLog(@"paused......");
            [dlnaObj stopReadPlayProgress];
            dlnaObj.dlnaPlayState = PAUSED;
        } else if (strcmp(value, UPNP_STOPPED) == 0) {
            [dlnaObj stopReadPlayProgress];
            dlnaObj.dlnaPlayState = STOPPED;
        }
        if (dlnaObj.dlnaPlayDelegate != nil && [dlnaObj.dlnaPlayDelegate respondsToSelector:@selector(playStateDidChanged:)]) {
            [dlnaObj.dlnaPlayDelegate playStateDidChanged: dlnaObj.dlnaPlayState];
        }
    }
    return 1;
}

- (void)dlnaPushLocalRes {
    NSString *curDevUdnStr = [_devArr objectAtIndex:_curDevIndex][kUdn];
    UAV_SetRendererEventCallback(curDevUdnStr.UTF8String,remoteTVEventCallback);
    IOS_Play_LocalRes(curDevUdnStr.UTF8String, _pushLocalResTitle.UTF8String, localResPushCallback);
}

- (void)dlnaStop {
    NSString *curDevUdnStr = [_devArr objectAtIndex:_curDevIndex][kUdn];
    int result = UAV_Stop(curDevUdnStr.UTF8String);
    NSLog(@"stop share reslt %d", result);
}

- (void)dlnaPushNetResWithUrl:(NSString *)url {
    NSString *curDevUdnStr = [_devArr objectAtIndex:_curDevIndex][kUdn];
    IOS_Play_LocalRes(curDevUdnStr.UTF8String, url.UTF8String, nil);
}

#pragma NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    xmlNode = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([xmlNode isEqualToString:@"deviceinfo"]) {
        if (![string isEqualToString:@"\n"]) {
            xmlBlackDevsValue = [xmlBlackDevsValue stringByAppendingString:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
}

- (void)showPrivateIsConnectView:(int)flag{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_updateRCViewDelegate updateRCViewWithIndex:flag];
    });
}

- (void)setTvDisconnect {
    _curDevIndex = -1;
}

- (void)dlnaPlayVideo{
    NSString *curDevUdnStr = [_devArr objectAtIndex:_curDevIndex][kUdn];
    UAV_Play(nil,curDevUdnStr.UTF8String,nil,nil);
}

- (void)dlanPauseVideo{
    NSString *curDevUdnStr = [_devArr objectAtIndex:_curDevIndex][kUdn];
    UAV_Pause(curDevUdnStr.UTF8String);
}

- (void)dlnaSeekVideo:(const char*)target{
    NSString *curDevUdnStr = [_devArr objectAtIndex:_curDevIndex][kUdn];
    UAV_Seek(curDevUdnStr.UTF8String, @"REL_TIME".UTF8String, target);
}

- (void)dlnaGetVideoPosition:(UAVMR_PositionInfo *)info{
    NSString *curDevUdnStr = [_devArr objectAtIndex:_curDevIndex][kUdn];
    UPNP_GetPositionInfo(curDevUdnStr.UTF8String, info);
}

- (void)startReadPlayProgress {
//    if (![_pushLocalResMime containsString:@"video"]) {
//        return;
//    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@" start read play progress");
        if (readProgressTimer != nil && readProgressTimer.isValid) {
            [readProgressTimer invalidate];
            readProgressTimer = nil;
        }
        readProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(readPrgress) userInfo:nil repeats:YES];
    });
}

- (void)stopReadPlayProgress
{
    NSLog(@" stop to read play progress");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (readProgressTimer != nil && readProgressTimer.isValid) {
            [readProgressTimer invalidate];
            readProgressTimer = nil;
        }
    });
}

- (void)readPrgress {
    NSString * time;
    NSString *curDevUdnStr = [_devArr objectAtIndex:_curDevIndex][kUdn];
    UAVMR_PositionInfo* positionInfo=(UAVMR_PositionInfo*)malloc(sizeof(UAVMR_PositionInfo));
    int successGetPositionInfo = UPNP_GetPositionInfo(curDevUdnStr.UTF8String,positionInfo);
    NSLog(@"successGetPositionInfo:%d",successGetPositionInfo);
    if (!successGetPositionInfo) {
        NSString * relTime;
        if (positionInfo->RelTime) {
            relTime=[[NSString alloc] initWithUTF8String:positionInfo->RelTime];
        }else{
            return;
        }
//        time=[[NSString alloc] initWithString:[relTime substringFromIndex:3]];
//        NSLog(@"time:%@",relTime);
        positionInfo=nil;

        if ([time isEqualToString: @"NOT_IMPLEMENTED"]||[time isEqualToString: @"_IMPLEMENTED"]) {
            return ;
        }
        if (_dlnaPlayDelegate != nil && [_dlnaPlayDelegate respondsToSelector:@selector(progressDidUpdate:)]) {
            [_dlnaPlayDelegate progressDidUpdate:relTime];  //手机上的进度条跟随电视播放进度移动
        }
    }
}
    

@end

