//
//  DLNAObject.h
//  HsShare3.5
//
//  Created by Lisa Xun on 15/6/23.
//  Copyright (c) 2015年 com.hisense. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "upnp_common.h"
#include "upnp_server.h"
#include "upnp_control.h"

#define kFriendlyName        @"friendlyName"
#define kUdn                 @"udn"
#define kUri                 @"uri"
#define kIp                  @"ip"
#define kModelDescription    @"modeldescription"
//通信协议mqtt or 私有协议
#define kTransportProtocol   @"transport_protocol"

enum DlnaStartRes{
    UPNPInitFail = (-3),
    UPNPDmsStartFail,
    UPNPDmcStartFail,
    DLNAStartOK,
    DLNAStartRepeat = (1)
};


/**
 电视与手机间的通信协议
 */
typedef NS_ENUM(int, TransportProtocolOption) {
    TransportProtocolOptionMQTT = 1,
    TransportProtocolOptionPrivateObject = 2,
    
};
//typedef NS_ENUM(char, MQTTAppTopicCmd)

typedef NS_ENUM(NSUInteger, DlnaPlayState){
    NONE = 0,
    PLAYING = 1,
    PAUSED = 2,
    STOPPED = 3
};

@protocol CurDevDelegate <NSObject>
@optional
- (void)curDevChangeToIndex:(NSInteger)index;
@end


@protocol UpdateRCViewDelegate <NSObject>
@optional
- (void)updateRCViewWithIndex:(NSInteger)index;
- (void)updateDisConnectStatus;
@end


@protocol UpdateRCVCDelegate <NSObject>
@optional
- (void)updateRCVCWithIndex:(NSInteger)index;
@end

@protocol UpdateConnectStatusDelegate <NSObject>
@optional
- (void)updateConnectStatus:(BOOL)flag;
- (void)reloadDevList;
@end

@protocol UpdateCYRMDelegate <NSObject>
@optional
- (void)updateCYRMWithIndex:(NSInteger)index;
@end


@protocol DevArrDelegate <NSObject>
@optional
- (void)devArrUpdate;
@end

@protocol UpdateCurDevDelegate <NSObject>
@optional
//- (void)updateDevBtnWithIndex:(NSInteger)index;
- (void)tvDevIdCallback;
- (void)curDevChange2Index:(NSInteger)index;
@end

@protocol UpdateEditTVNameAbility <NSObject>
@optional
- (void)updateEditTVNameWithIndex:(NSInteger)index;
@end

@protocol LivePushDelegate <NSObject>
@optional
- (void)tvPushLiveAbilityCallback;
@end

@protocol LoadingViewDelegate <NSObject>
@optional
- (void)showLoadingView;
- (void)dismissLoadingView;
- (void)showRCView;
@end

@protocol DLNAVideoStatusDelegate <NSObject>
@optional
- (void)getStatus:(NSString *)value;
@end

@protocol DlnaPlayDelegate <NSObject>
@optional
- (void)playStateDidChanged:(DlnaPlayState)state;
- (void)progressDidUpdate:(NSString*)progress;
@end

//@protocol TVDevIdDelegate <NSObject>
//@optional
//- (void)tvDevIdCallback;
//@end

@interface DLNAObject : NSObject

@property (assign, nonatomic) BOOL isDlnaStarted;
@property (strong, nonatomic) NSMutableArray *devArr;

@property (assign, nonatomic) NSInteger curDevIndex;


@property (assign, nonatomic) enum ClientType clientConnRes;
//device ability
@property (assign, nonatomic) BOOL canInputMethod;
@property (assign, nonatomic) int voicePort;
@property (assign, nonatomic) BOOL canVoiceAssist;
@property (assign, nonatomic) BOOL canRC;
@property (assign, nonatomic) BOOL canCYRM;
@property (assign, nonatomic) BOOL canCutScreen;
@property (assign, nonatomic) BOOL canNumerickey;
@property (assign, nonatomic) BOOL canEditName;
@property (assign, nonatomic) BOOL canSUIXIN;
@property (assign, nonatomic) BOOL canPushLive;

@property (strong, nonatomic) NSString *curDevId;
@property (nonatomic)enum DlnaPlayState dlnaPlayState;

@property (nonatomic, assign) TransportProtocolOption transportProtocol;//1设备支持mqtt，2为支持私有协议

@property (strong, nonatomic) id<CurDevDelegate> curDevDelegate;
@property (strong, nonatomic) id<DevArrDelegate> devArrDelegate;
@property (strong, nonatomic) id<UpdateRCViewDelegate> updateRCViewDelegate;
@property (strong, nonatomic) id<UpdateRCVCDelegate> updateRCVCDelegate;
@property (strong, nonatomic) id<UpdateCYRMDelegate> updateCYRMDelegate;
@property (strong, nonatomic) id<UpdateCurDevDelegate> updateCurDevDelegate;
@property (strong, nonatomic) id<UpdateEditTVNameAbility> updateEditTVNameDelegate;
@property (strong, nonatomic) id<LivePushDelegate> livePushDelegate;
@property (strong, nonatomic) id<UpdateConnectStatusDelegate> updateConnectStatusDelegate;
@property (strong, nonatomic) id<LoadingViewDelegate> loadingViewDelegate;
@property (strong, nonatomic) id<DLNAVideoStatusDelegate> dlnaVideoStatusDelegate;
@property (weak, nonatomic)   id<DlnaPlayDelegate> dlnaPlayDelegate;

@property (strong, nonatomic) NSData *pushLocalResData;
@property (strong, nonatomic) NSString *pushLocalResMime;//"audio/*" "image/*" "video/*"
@property (strong, nonatomic) NSString *pushLocalResTitle;
@property (strong, nonatomic) NSString *pushLocalResDuration;

+ (DLNAObject *)shareDlnaObj;
- (enum DlnaStartRes)startDLNA;
- (int)finishDLNA;
- (int)researchDlnaDev;
- (void)clearDevArr;
- (void)dlnaPushLocalRes;
- (void)dlnaStop;
- (void)dlnaPushNetResWithUrl:(NSString *)url;
- (void)getCurDevIdWithIndex:(NSInteger)index;
- (void)showPrivateIsConnectView:(int)flag;
- (void)setTvDisconnect;
- (void)setCurDevIndex:(NSInteger)index;
- (void)dlnaPlayVideo;
- (void)dlanPauseVideo;
- (void)dlnaSeekVideo:(const char*)target;
- (void)dlnaGetVideoPosition:(UAVMR_PositionInfo *)info;
@end
