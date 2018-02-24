//
//  PrivateObject.h
//  HsShare3.5
//
//  Created by Lisa Xun on 15/8/31.
//  Copyright (c) 2015年 com.hisense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "HSPrivateKey.h"
#include "hs_adaptation_client.h"
#import "OpenALPlayer.h"
#import "VoiceAssistant.h"

#define TOAST_MARGIN_B        ([GlobalUtils isPad]? 180:100)
#define CHANNEL_OLD_PORT      60030
#define CHANNEL_NEW_PORT      61061

enum ClientType {
    NoClient = (-1),
    OldClient,
    NewClient = (1)
};

@protocol PrvtConnectionLostDelegate <NSObject>

- (void)prvtConnectionLost;

@end

@protocol PrvtRecvTVCmdScreenShotDataDelegate<NSObject>

- (void)prvtRecvTVCmdScreenShotData:(NSData *)screenShotData;

@end

@protocol InputMethodDelegate <NSObject>
@optional
- (void)tvCallbackText:(NSString *)text;
@end

@protocol PrvtRecvTVCmdInputMethodDelegate<NSObject>

- (void)prvtRecvTVCmdInputMethod:(NSString *)inputMsg;

@end

@protocol VoiceAssistantDelegate <NSObject>
@optional
- (void)voiceAssistCallback:(BOOL)isOpen;
@end

/**
 START_VOICE_CONTROL
 */
@protocol PrvtRecvTVCmdVoiceStartControlDelegate <NSObject>

- (void)prvtRecvTVCmdVoiceStartControl:(BOOL)startResult;

@end

//START_VOICE_RECOGNITION
@protocol PrvtRecvTVCmdVoiceStartRecognitionDelegate <NSObject>

- (void)prvtRecvTVCmdVoiceStartRecognition:(BOOL)recognitionResult;

@end

//CLOSE_VOICE_CONTROL
@protocol PrvtRecvTVCmdVoiceCloseControlDelegate <NSObject>

- (void)prvtRecvTVCmdVoiceCloseControl:(BOOL)closeResult;

@end

//@protocol TVDevIdDelegate <NSObject>
//@optional
//- (void)tvDevIdCallback;
//@end

@protocol TVSupportsDelegate <NSObject>
@optional
- (void)tvSupportsCallback;
@end

@protocol TVRenameDelegate <NSObject>
@optional
- (void)tvRenameCallback;
@end

@protocol EditTVNameDelegate1 <NSObject>
@optional
- (void)tvNameCallback1;
@end

@protocol EditTVNameDelegate2 <NSObject>
@optional
- (void)tvNameCallback2:(NSString *)result tvName:(NSString *)tvName;
@end

/**
 私有协议接收到了电视返回的关于更改电视名称的命令
 */
@protocol PrvtRecvTVCmdEditTVNameDelegate<NSObject>

- (void)prvtRecvTVCmdEditTVName:(NSString *)result;

@end

@protocol StopCYRMDelegate <NSObject>
@optional
- (void)stopCYRM;
@end

@protocol FinishGameViewDelegate <NSObject>
@optional
- (void)finishGameView;
@end

@interface PrivateObject : NSObject

@property (weak, nonatomic) NSObject<PrvtConnectionLostDelegate> *prvtConnectionLostDelegate;

//@property (assign, nonatomic) BOOL isClientConnOK;
//@property (assign, nonatomic) BOOL isPreConnOK;
@property (assign, nonatomic) BOOL isClientConnected;
//一些电视设备有dlna功能，没有私有协议或者mqtt，NO，显示悬浮遥控器视图，YES，不显示悬浮遥控器视图
// For some tv has dlna but not private.
@property (assign, nonatomic) BOOL isFinalConnected;

@property (strong, nonatomic) id<InputMethodDelegate> inputMethodDelegate;
@property (nonatomic, weak) NSObject<PrvtRecvTVCmdInputMethodDelegate> *prvtRecvTVCmdInputMethodDelegate;

@property (assign, nonatomic) BOOL isSoundToEarOpen;
@property (strong, nonatomic) id<StopCYRMDelegate> stopCYRMDelegate;

@property (strong, nonatomic) VoiceAssistant *pVoiceAssistant;
@property (strong, nonatomic) id<VoiceAssistantDelegate> voiceAssistDelegate;
@property (nonatomic, weak) NSObject<PrvtRecvTVCmdVoiceStartControlDelegate> *prvtRecvTVCmdVoiceStartControlDelegate;
@property (nonatomic, weak) NSObject<PrvtRecvTVCmdVoiceStartRecognitionDelegate> *prvtRecvTVCmdVoiceStartRecognitionDelegate;
@property (nonatomic, weak) NSObject<PrvtRecvTVCmdVoiceCloseControlDelegate> *prvtRecvTVCmdVoiceCloseControlDelegate;

//@property (strong, nonatomic) id<TVDevIdDelegate> tvDevIdDelegate;
@property (strong, nonatomic) id<TVSupportsDelegate> tvSupportsDelegate;
@property (strong, nonatomic) id<TVRenameDelegate> tvRenameDelegate;

@property (strong, nonatomic) id<EditTVNameDelegate1> editTVNameDelegate1;
@property (strong, nonatomic) id<EditTVNameDelegate2> editTVNameDelegate2;
@property (nonatomic, weak) NSObject<PrvtRecvTVCmdEditTVNameDelegate> *prvtRecvTVCmdEditTVNameDelegate;

@property (strong, nonatomic) id<FinishGameViewDelegate> finishGameViewDelegate;
@property (strong, nonatomic) NSString *changedName;

@property (strong, nonatomic) UIImage *cutTVShowImg;
@property (strong, nonatomic) NSData *cutTVShowImgData;
@property (nonatomic, weak) NSObject<PrvtRecvTVCmdScreenShotDataDelegate> *prvtRecvTVCmdScreenShotDataDelegate;

@property (strong, nonatomic) NSString *currentIp;

+ (PrivateObject *)sharePrivateObj;
- (enum ClientType)clientConn;
- (void)clientDisConn;
- (int)sendCtrlKey:(char *)keystr type:(int)type;

- (void)playSoundToEar;
- (void)stopSoundToEar;

- (BOOL)cutTVPic;
- (void)registerMsgCallBack;
@end
