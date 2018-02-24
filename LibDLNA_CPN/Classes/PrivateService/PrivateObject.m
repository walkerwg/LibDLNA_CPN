//
//  PrivateObject.m
//  HsShare3.5
//
//  Created by Lisa Xun on 15/8/31.
//  Copyright (c) 2015年 com.hisense. All rights reserved.
//
#import "PrivateObject.h"
#import "DLNAObject.h"
#import <arpa/inet.h>
#import <AVFoundation/AVFoundation.h>
#import "HSToast.h"
//#import "AppDelegate.h"
//#import "RCViewController.h"
//#import "UMMobClick.framework/Headers/MobClick.h"
//#import "RCView.h"
#import "GlobalUtils.h"

#define DEF_BUFFER_SIZE       4096
#define DEF_SAMPLE_RATE       8000
#define SOUND_TO_EAR_PORT     54321
#define BUFFER_SIZE_SYMBOL    @"BUFFERSIZE:"
#define SAMPLE_RATE_SYMBOL    @"SAMPLERATE:"

#define CUT_TV_PIC_PORT       36668

#define TEST_SUPPORT_NUM      8

enum ClientSupportIndex {
    SupportScreenCap = (0),
    SupportIME,
    SupportWirelessHeadSet,
    SupportSmartRemote,
    SupportRenameTV,
    SupportVoice,
    SupportAnyView,
    SupportIp = (7)
};

static NSString *TestSupports[TEST_SUPPORT_NUM] = {
    @"screencap=",
    @"ime=",
    @"wirelessheadset=",
    @"smart_remote=",
    @"renametv=",
    @"voice_control=",
    @"anyview=",
    @"ip="
};

@interface PrivateObject () <UpdateCYRMDelegate> {
    DLNAObject *dlnaObj;
    
    int registerCB1_res;
    int registerCB2_res;
    
    int cur_buffer_size;
    int cur_sample_rate;
    
    OpenALPlayer *pOpenAlPlayer;
    BOOL isOpenAlPlayerInitOK;
    BOOL pushSoundDataFlag;
    BOOL isReadyForSound;
    
    BOOL createSocketRepeat;
    
    BOOL newChannelFlag;
}

@end

@implementation PrivateObject

+ (PrivateObject *)sharePrivateObj {
    static PrivateObject *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PrivateObject alloc] init];
        [sharedInstance initPrivateObj];
    });
    return sharedInstance;
}

- (void)initPrivateObj {
    dlnaObj = [DLNAObject shareDlnaObj];
    dlnaObj.updateCYRMDelegate = self;
    
    registerCB1_res = -1;
    registerCB2_res = -1;
    
//    _isClientConnOK = NO;
    _isSoundToEarOpen = NO;
//    _isPreConnOK = NO;
    
    pOpenAlPlayer = [[OpenALPlayer alloc] init];
//    isOpenAlPlayerInitOK = [pOpenAlPlayer initPlayer];
    
    //lastKeyStr = NULL;
}

- (enum ClientType)clientConn {
    if (dlnaObj.curDevIndex != -1 && dlnaObj.curDevIndex != -2) {
        NSString *curIp = [dlnaObj.devArr objectAtIndex:dlnaObj.curDevIndex][kIp];
        int oldConnRes = client_connect((char *)curIp.UTF8String, CHANNEL_OLD_PORT);
        if (oldConnRes == 0) {
            return OldClient;
        }
//        else {
//            int newConnRes = client_connect((char *)curIp.UTF8String, CHANNEL_NEW_PORT);
//            if (newConnRes == 0) {
//                return NewClient;
//            }
//        }
    } else {
        HSLog(@"client can not connect because dlnaObj.curDevIndex = -1 || -2");
    }
    return NoClient;
}

- (void)clientDisConn {
//    if (_isClientConnOK) {
    client_disconnect();
//        _isClientConnOK = NO;
//    }
}

//static NSString *ipTest = @"ip=";
////    @"hiservice=",
//static NSString *cutScreenTest = @"screencap=";
//static NSString *inputMethodTest = @"ime=";
////    @"hicloud_update=",
////    @"wechattv=",
//static NSString *cyrmTest = @"wirelessheadset=";
//static NSString *rcTest = @"smart_remote=";
//static NSString *editNameTest = @"renametv=";
////    @"vidaa=",
////    @"airplay=",
////    @"remote=",
////    @"dlna=",
//static NSString *voiceAssistTest = @"voice_control=";
//static NSString *suixinTest = @"anyview=";
void msgCallback(char *svrinfo, int reserved) {
    if (!svrinfo) {
        HSLog(@"no server info");
    } else {
        NSString *info = @(svrinfo);
        HSLog(@"msgCallback info is %@", info);
        NSLog(@"startinputmethod__收到电视信息：%@", info);
        
        //tv device id
        /*if ([info hasPrefix:@(GET_TV_DEVICEID)]) {
            NSString *devId = [info substringFromIndex:(strlen(GET_TV_DEVICEID)+1)];
            PrivateObject *privateObj = [PrivateObject sharePrivateObj];
            dispatch_async(dispatch_get_main_queue(), ^{
                DLNAObject *dlnaObj = [DLNAObject shareDlnaObj];
                dlnaObj.curDevId = devId;
                HSLog(@"callback dev id is %@", devId);
                [privateObj.tvDevIdDelegate tvDevIdCallback];
            });
            [privateObj clientDisConn];
         } else */
        if ([info hasPrefix:@(GET_TV_SUPPORT)]) {
            NSString *clientInfo = [info substringFromIndex:(strlen(GET_TV_SUPPORT)+1)];
            HSLog(@"callback client info is %@", clientInfo);
            dispatch_async(dispatch_get_main_queue(), ^{
                DLNAObject *dlnaObj = [DLNAObject shareDlnaObj];
                if (dlnaObj.curDevIndex != -1 && dlnaObj.curDevIndex != -2) {
                    NSArray *supportArr = [clientInfo componentsSeparatedByString:@";"];
                    BOOL isGetSupportOK = NO;
                    NSMutableArray *tmpSupportArr = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
                    for (int i=0; i<supportArr.count; i++) {
                        NSString *curSupportInfo = [supportArr objectAtIndex:i];
                        
                        //ip
                        NSRange range = [curSupportInfo rangeOfString:TestSupports[SupportIp]];
                        if (range.location != NSNotFound) {
                            NSString *curSupportValue = [curSupportInfo substringFromIndex:(range.location+TestSupports[SupportIp].length)];
                            if (![curSupportValue isEqualToString:[dlnaObj.devArr objectAtIndex:dlnaObj.curDevIndex][kIp]]) {
                                break;
                            } else {
                                isGetSupportOK = YES;
                            }
                            continue;
                        }
                        
                        for (int j=0; j<(TEST_SUPPORT_NUM-1); j++) {
                            range = [curSupportInfo rangeOfString:TestSupports[j]];
                            if (range.location != NSNotFound) {
                                tmpSupportArr[j] = [curSupportInfo substringFromIndex:(range.location+TestSupports[j].length)];
                                break;
                            }
                        }
                    }
                    
                    if (isGetSupportOK) {
                        dlnaObj.canCutScreen = ![[tmpSupportArr objectAtIndex:SupportScreenCap] isEqualToString:@"0"];
                        dlnaObj.canInputMethod = ![[tmpSupportArr objectAtIndex:SupportIME] isEqualToString:@"0"];
                        dlnaObj.canCYRM = ![[tmpSupportArr objectAtIndex:SupportWirelessHeadSet] isEqualToString:@"0"];
                        dlnaObj.canRC = ![[tmpSupportArr objectAtIndex:SupportSmartRemote] isEqualToString:@"0"];
                        dlnaObj.canEditName = ![[tmpSupportArr objectAtIndex:SupportRenameTV] isEqualToString:@"0"];
                        dlnaObj.canVoiceAssist = ![[tmpSupportArr objectAtIndex:SupportVoice] isEqualToString:@"0"];
                        dlnaObj.voicePort = [[tmpSupportArr objectAtIndex:SupportVoice] intValue];
                        dlnaObj.canSUIXIN = ![[tmpSupportArr objectAtIndex:SupportAnyView] isEqualToString:@"0"];
                    }
                }
                
                PrivateObject *privateObj = [PrivateObject sharePrivateObj];
                [privateObj.tvSupportsDelegate tvSupportsCallback];
                [privateObj.tvRenameDelegate tvRenameCallback];
            });
        } else if ([info hasPrefix:@(START_INPUT_METHOD)]) {//tv current text
            NSString *inputText = [info substringFromIndex:(strlen(START_INPUT_METHOD)+1)];
            dispatch_async(dispatch_get_main_queue(), ^{
                PrivateObject *privateObj = [PrivateObject sharePrivateObj];
                //[privateObj.inputMethodDelegate tvCallbackText:inputText];
                [privateObj.prvtRecvTVCmdInputMethodDelegate prvtRecvTVCmdInputMethod:inputText];
            });
        } else if ([info hasPrefix:@(START_VOICE_CONTROL)]) {//voice assistant ready for
            if([info containsString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    PrivateObject *privateObj = [PrivateObject sharePrivateObj];
                    [privateObj.prvtRecvTVCmdVoiceStartControlDelegate prvtRecvTVCmdVoiceStartControl:YES];
                    /*
                    //发送成功后，电视返回准备信息，此时，手机屏幕上显示“请说”
                    [HSToast showAtDefWithText:NSLocalizedString(@"pleaseSay", nil)];
                    

                    if (privateObj.pVoiceAssistant == nil) {
                        privateObj.pVoiceAssistant = [[VoiceAssistant alloc] init];
                    }
                    BOOL isStartOK = [privateObj.pVoiceAssistant startRecorder];
                    if (isStartOK) {
                        //change image
                        [privateObj.voiceAssistDelegate voiceAssistCallback:YES];
                    }*/
                });
            }else{
                PrivateObject *privateObj = [PrivateObject sharePrivateObj];
                [privateObj.prvtRecvTVCmdVoiceStartControlDelegate prvtRecvTVCmdVoiceStartControl:NO];
                //[privateObj.pVoiceAssistant stopRecorder];
                //[privateObj.voiceAssistDelegate voiceAssistCallback:NO];
            }
        } else if ([info hasPrefix:@(START_VOICE_RECOGNITION)]) {//stop recieve voice and start recognize
            dispatch_async(dispatch_get_main_queue(), ^{
                PrivateObject *privateObj = [PrivateObject sharePrivateObj];
                [privateObj.prvtRecvTVCmdVoiceStartRecognitionDelegate prvtRecvTVCmdVoiceStartRecognition:YES];
               /*[HSToast showAtDefWithText:NSLocalizedString(@"recognizing", nil)];
                [privateObj.pVoiceAssistant stopRecorder];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [privateObj sendCtrlKey:CLOSE_VOICE_CONTROL type:MSG_TYPE_VOICE];
                });
                [privateObj.voiceAssistDelegate voiceAssistCallback:NO];*/
            });
        } else if ([info hasPrefix:@(SEND_CHANGE_TVNAME)]) {//change tv name result
            NSString *result = [info substringFromIndex:(strlen(SEND_CHANGE_TVNAME)+1)];
            dispatch_async(dispatch_get_main_queue(), ^{
                PrivateObject *privateObj = [PrivateObject sharePrivateObj];
                //[privateObj.editTVNameDelegate1 tvNameCallback1];
                [privateObj.editTVNameDelegate2 tvNameCallback2:result tvName:privateObj.changedName];
                [privateObj.prvtRecvTVCmdEditTVNameDelegate prvtRecvTVCmdEditTVName:result];
            });
        } else if ([info hasPrefix:@(CLOSE_VOICE_CONTROL)]){
            PrivateObject *privateObj = [PrivateObject sharePrivateObj];
            [privateObj.prvtRecvTVCmdVoiceCloseControlDelegate prvtRecvTVCmdVoiceCloseControl:YES];
            //[privateObj.pVoiceAssistant stopRecorder];
            //[privateObj.voiceAssistDelegate voiceAssistCallback:NO];
        }
    }
}

void channelExpCallback(char *exceptinfo, int errnum) {
//    PrivateObject *privateObj = [PrivateObject sharePrivateObj];
//    privateObj.isClientConnOK = NO;
    if (!exceptinfo) {
        HSLog(@"no exception info");
    } else {
        HSLog(@"exceptinfo %s",exceptinfo);
        // reconnect one time
        DLNAObject *dlnaObj = [DLNAObject shareDlnaObj];
        PrivateObject *privateObj = [PrivateObject sharePrivateObj];
        [privateObj clientDisConn];
        int result = client_connect((char *)privateObj.currentIp.UTF8String, CHANNEL_OLD_PORT);
        NSLog(@"__重新连接结果:%d",result);
        if(result == 0) {
            [dlnaObj showPrivateIsConnectView:0];
        }else{
#warning todo:屏蔽了
//            UIViewController *topVC = [GlobalUtils getPresentedViewController];
//            if([topVC isKindOfClass:[RCViewController class]]) {
//                AppDelegate *pAppDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                NSArray *vcArr = pAppDelegate.pNavigationC.viewControllers;
//                UIViewController *curVC = [vcArr objectAtIndex:(vcArr.count-1)];
//                [curVC dismissViewControllerAnimated:YES completion:nil];
//                [MobClick endLogPageView:LOG_REPORT_remoteController];
//                HSLog(@"errnum %d",errnum);
//                [privateObj.finishGameViewDelegate finishGameView];
//            }
            [dlnaObj clearDevArr];
            [privateObj.prvtConnectionLostDelegate prvtConnectionLost];
            [[NSNotificationCenter defaultCenter] postNotificationName:DISCONNECT_NOTIFICATION object:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HSToast showAtDefWithText:NSLocalizedString(@"Disconnect device", nil)];
            });
        }
    }
}

- (void) registerMsgCallBack {
    if (registerCB1_res != 0) {
        registerCB1_res = register_message_callback(msgCallback);
    }
    
    if (registerCB2_res != 0) {
        registerCB2_res = register_channelException_callback(channelExpCallback);
    }
}

- (int)sendCtrlKey:(char *)keystr type:(int)type {
    //deviceid = BLACK_GOODS_TV
    //sourceid = MSG_SOURCE_MC
    //key_mode = MSG_KEYMODE_SINGLE;
    //msg_type = MSG_TYPE_KEY
    int reserved = 0;
    int sendKeyRes = send_keystr(BLACK_GOODS_TV, MSG_SOURCE_MC, keystr, MSG_KEYMODE_SINGLE, type, reserved);
    HSLog(@"send %s key result is %d", keystr, sendKeyRes);
//    if(sendKeyRes < 0) {
//        [self clientDisConn];
//        _isClientConnOK = NO;
//        int clientConnTryTimes = 3;
//        while (clientConnTryTimes-- >= 0) {
//            int connResult = [self clientConn];
//            if(connResult >=0) {
//                break;
//            }
//        }
//    }
    return sendKeyRes;
}

static char *SCREENREQUEST = "\x64";//client->server start request
static char *SCREENRESPONSE = "\x65";//server->client start response
//static char *SCREENEND = "\x66";//client->server end request
static int READLENGTH = 5*1024;//read every data length

- (int)recvedIntValueWithBytes:(char *)bytes {
    int tmp0, tmp1, tmp2, tmp3;
    tmp0 = bytes[0]&0xFF;
    tmp1 = bytes[1]&0xFF;
    tmp2 = bytes[2]&0xFF;
    tmp3 = bytes[3]&0xFF;
    
    return ((tmp0 << 24)+(tmp1 << 16)+(tmp2 << 8)+(tmp3 << 0));
}

- (BOOL)cutTVPic {
    if (dlnaObj.curDevIndex != -1 && dlnaObj.curDevIndex != -2) {
        //1. create a socket connectiong between client and server
        int sock_fd = socket(AF_INET, SOCK_STREAM, 0);
        
        struct sockaddr_in svr_addr;
        memset(&svr_addr, 0, sizeof(svr_addr));
        svr_addr.sin_family = AF_INET;
        NSString *curIpStr = [dlnaObj.devArr objectAtIndex:dlnaObj.curDevIndex][kIp];
        svr_addr.sin_addr.s_addr = inet_addr(curIpStr.UTF8String);
        svr_addr.sin_port = htons(CUT_TV_PIC_PORT);
        socklen_t socketaddr_in_len = sizeof(struct sockaddr_in);
        
        if (connect(sock_fd, (struct sockaddr *)&svr_addr, sizeof(svr_addr)) == 0) {
            //2. client->server, send cut TV request SCREENREQUEST(byte type)
            sendto(sock_fd, SCREENREQUEST, sizeof(SCREENREQUEST), 1, (struct sockaddr*)&svr_addr, socketaddr_in_len);
            
            //3. server->client send response SCREENRESPONSE(byte type)
            char *recvByte = NULL;
            recvByte = (char *)malloc(1);
            recv(sock_fd, recvByte, 1, 0);//用recv函数从连接的另一端接收数据。
            if (*recvByte != *SCREENRESPONSE) {
                free(recvByte);
                close(sock_fd);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HSToast showWithText:NSLocalizedString(@"connectionClosed", nil) bottomOffset:TOAST_MARGIN_B];
                });
            } else {
                free(recvByte);
                HSLog(@"server is ok will send length and data");
                //4. server->client send length(int type) of img
                char *recvLenData = NULL;
                recvLenData = (char *)malloc(4);
                int recvLenRes = (int)recv(sock_fd, recvLenData, 4, 0);
                if (recvLenRes > 0) {
                    int imgLen = [self recvedIntValueWithBytes:recvLenData];
                    free(recvLenData);
                    HSLog(@"data length is %d", imgLen);
                    
                    //5. server->client send img data(byte type)
                    char *recvImgData = NULL;
                    recvImgData = (char *)malloc(imgLen);
                    int offset = 0;
                    int readLen = 0;
                    int availLen = READLENGTH;
                    if (imgLen < availLen) {
                        readLen = (int)recv(sock_fd, recvImgData, imgLen, 0);
                        if (readLen > 0) {
                            _cutTVShowImgData = [NSData dataWithBytes:recvImgData length:imgLen];
                            NSData *screenShotData = [NSData dataWithBytes:recvImgData length:imgLen];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.prvtRecvTVCmdScreenShotDataDelegate prvtRecvTVCmdScreenShotData:screenShotData];
                            });
                            free(recvImgData);
                            close(sock_fd);
                            _cutTVShowImg = [UIImage imageWithData:_cutTVShowImgData];
                            return YES;
                        } else {
                            free(recvImgData);
                            close(sock_fd);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [HSToast showWithText:NSLocalizedString(@"connectionClosed", nil) bottomOffset:TOAST_MARGIN_B];
                            });
                        }
                        
                    } else {
                        BOOL isRecvImgDataOK = YES;
                        while (1) {
                            readLen = (int)recv(sock_fd, recvImgData+offset, availLen, 0);
                            //HSLog(@"recv img data from (%d) to (%d)", offset, offset+availLen);
                            if (readLen > 0) {
                                offset += readLen;
                                if (offset == imgLen) {
                                    HSLog(@"stop condition --> offset(%d) == imgLen(%d)", offset, imgLen);
                                    break;
                                }
                                
                                if (imgLen-offset < READLENGTH) {
                                    availLen = imgLen-offset;
                                }
                            } else {
                                free(recvImgData);
                                close(sock_fd);
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [HSToast showWithText:NSLocalizedString(@"connectionClosed", nil) bottomOffset:TOAST_MARGIN_B];
                                });
                                isRecvImgDataOK = NO;
                                break;
                            }
                        }
                        //6. client->server send end request
                        //sendto(sock_fd, SCREENEND, sizeof(SCREENEND), 1, (struct sockaddr*)&svr_addr, socketaddr_in_len);
                        
                        if (isRecvImgDataOK) {
                            //_cutTVShowImgData = [NSData dataWithBytes:recvImgData length:imgLen];
                            NSData *screenShotData = [NSData dataWithBytes:recvImgData length:imgLen];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.prvtRecvTVCmdScreenShotDataDelegate prvtRecvTVCmdScreenShotData:screenShotData];
                            });
                            free(recvImgData);
                            close(sock_fd);
                            //_cutTVShowImg = [UIImage imageWithData:_cutTVShowImgData];
                            return YES;
                        }
                    }
                } else {
                    free(recvLenData);
                    close(sock_fd);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HSToast showWithText:NSLocalizedString(@"connectionClosed", nil) bottomOffset:TOAST_MARGIN_B];
                    });
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HSToast showWithText:NSLocalizedString(@"connectionFail", nil) bottomOffset:TOAST_MARGIN_B];
            });
        }
    
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HSToast showWithText:NSLocalizedString(@"noConnectedDev", nil) bottomOffset:TOAST_MARGIN_B];
        });
    }
    
    return NO;
}

- (void)playSoundToEar {
    if (dlnaObj.curDevIndex != -1 && dlnaObj.curDevIndex != -2) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:YES error:nil]; //激活当前的AudioSession
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];//设置调用的category类型，AVAudioSessionCategoryPlayback为停止其他音频播放，能在后台播放，锁屏and静音模式下均可。
        
        if (!createSocketRepeat) {
            [self sendCtrlKey:DEVICE_KEY_MUTE type:MSG_TYPE_KEY]; //传音入秘开启后电视静音
        }
        
        cur_buffer_size = DEF_BUFFER_SIZE;
        cur_sample_rate = DEF_SAMPLE_RATE;
        
        isOpenAlPlayerInitOK = [pOpenAlPlayer initPlayer];
        if (isOpenAlPlayerInitOK) {
            HSLog(@"openal player initial OK");
            
            int sock_fd = socket(AF_INET, SOCK_STREAM, 0);
            
            struct sockaddr_in svr_addr;
            memset(&svr_addr, 0, sizeof(svr_addr));
            svr_addr.sin_family = AF_INET;
            NSString *curIpStr = [dlnaObj.devArr objectAtIndex:dlnaObj.curDevIndex][kIp];
            svr_addr.sin_addr.s_addr = inet_addr(curIpStr.UTF8String);
            svr_addr.sin_port = htons(SOUND_TO_EAR_PORT);

            if (connect(sock_fd, (struct sockaddr *)&svr_addr, sizeof(svr_addr)) == 0) {
                int buff_size = 0;
                char *buff = NULL;
                pushSoundDataFlag = YES;
                isReadyForSound = NO;
                
                while (1) {
                    if (!_isSoundToEarOpen || !pushSoundDataFlag) {
                        //[self stopSoundToEar];
                        HSLog(@"#####!_isSoundToEarOpen || !pushSoundDataFlag#####");
                        break;
                    }
                    
                    if (buff != NULL || buff_size != cur_buffer_size) {
                        if (buff) {
                            free(buff);
                        }
                        
                        buff_size = cur_buffer_size;
                        buff = (char *)malloc(cur_buffer_size);
                    }
                    
                    int socketRes = (int)recv(sock_fd, buff, buff_size, 0);
                    if (socketRes > 0) {
                        HSLog(@"sound to ear buff is %@", @(buff));
                        NSRange range0 = [@(buff) rangeOfString:@"ERROR0"];
                        NSRange range1 = [@(buff) rangeOfString:@"ERROR1"];
                        NSRange range2 = [@(buff) rangeOfString:@"ERROR2"];
                        if (isReadyForSound) {
                            [pOpenAlPlayer openPlayerWithBuff:buff length:socketRes sampleRate:cur_sample_rate];
                        } else if (range0.location != NSNotFound || range2.location != NSNotFound) {
                            [self CheckSampleAndBuffer:buff];
                        } else if (range1.location != NSNotFound) {
                            //[self stopSoundToEar];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [_stopCYRMDelegate stopCYRM];
                                [HSToast showAtDefWithText:NSLocalizedString(@"TVBusying", nil)];
                            });
                            
                            break;
                        } else {
                            isReadyForSound = YES;
                            [pOpenAlPlayer openPlayerWithBuff:buff length:socketRes sampleRate:cur_sample_rate];
                        }
                    } else {
                        HSLog(@"recv(sock_fd, buff, buff_size, 0) < 0");
                        createSocketRepeat = YES;
                        
                        break;
                    }
                    
                }
                
                if (buff) {
                    free(buff);
                }
                close(sock_fd);
                
                if (createSocketRepeat) {
                    [self playSoundToEar];
                    createSocketRepeat = NO;
                }
            } else {
                HSLog(@"#####connect(sock_fd, (struct sockaddr *)&svr_addr, sizeof(svr_addr)) != 0#####");
                
                //[self stopSoundToEar];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_stopCYRMDelegate stopCYRM];
                    [HSToast showAtDefWithText:NSLocalizedString(@"connectionFail", nil)];
                });
                
                close(sock_fd);
            }
        } else {
            HSLog(@"openal player initial failed");
            dispatch_async(dispatch_get_main_queue(), ^{
                [_stopCYRMDelegate stopCYRM];
            });
        }
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_stopCYRMDelegate stopCYRM];
            [HSToast showAtDefWithText:NSLocalizedString(@"noConnectedDev", nil)];
        });
    }
}

//  ERROR0#SAMPLERATE:48000#BUFFERSIZE:2048#
//  ERROR2#SAMPLERATE:48000#BUFFERSIZE:2048#
- (void)CheckSampleAndBuffer:(const char*)buff {
    NSString *buffStr = @(buff);
    
    NSRange error0Range = [buffStr rangeOfString:@"ERROR0"];
    NSRange error2Range = [buffStr rangeOfString:@"ERROR2"];
    if (error0Range.location == NSNotFound && error2Range.location == NSNotFound){
        cur_buffer_size = DEF_BUFFER_SIZE;
        cur_sample_rate = DEF_SAMPLE_RATE;
    } else{
        NSArray *buffArr = [buffStr componentsSeparatedByString:@"#"];
        for (NSString *tmp in buffArr) {
            NSRange bufferSizeRange = [tmp rangeOfString:BUFFER_SIZE_SYMBOL];
            NSRange sampleRateRange = [tmp rangeOfString:SAMPLE_RATE_SYMBOL];
            if (bufferSizeRange.location != NSNotFound) {
                cur_buffer_size = [[tmp substringFromIndex:(BUFFER_SIZE_SYMBOL.length)] intValue];
            }
            
            if (sampleRateRange.location != NSNotFound) {
                cur_sample_rate = [[tmp substringFromIndex:(SAMPLE_RATE_SYMBOL.length)] intValue];
            }
        }
    }
    
    HSLog(@"BUFFERSIZE is %d", cur_buffer_size);
    HSLog(@"SAMPLERATE is %d", cur_sample_rate);
}

- (void)stopSoundToEar {
    //[self sendCtrlKey:DEVICE_KEY_MUTE type:MSG_TYPE_KEY];
    [pOpenAlPlayer stopSound];
}

#pragma UpdateCYRMDelegate
- (void)updateCYRMWithIndex:(NSInteger)index {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (_isSoundToEarOpen) {
            pushSoundDataFlag = NO;
            //[self stopSoundToEar];
        }
        
        if (index != -1 && index != -2) {  
            if (_isSoundToEarOpen) {
                pushSoundDataFlag = YES;
                [self playSoundToEar];
            }
        }
    });
}

@end
