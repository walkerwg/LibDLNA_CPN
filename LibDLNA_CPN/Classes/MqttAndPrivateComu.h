//
//  MqttAndPrivateComu.h
//  HsShare3.5
//
//  Created by 尚轩瑕 on 2017/11/8.
//  Copyright © 2017年 com.hisense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HSPrivateKey.h"

@class VoiceAssistant;

typedef NS_ENUM(int, TransportProtocol) {
    TransportProtocolMQTT = 1,
    TransportProtocolPrivateObject = 2,
    
};

typedef NS_ENUM(int, MqttAndPrivateCmd) {
    MqttAndPrivateCmdChangeTVName,//修改电视名称命令
    MqttAndPrivateCmdSendKey,//遥控器控制命令
    MqttAndPrivateCmdInput,//输入法控制命令
    MqttAndPrivateCmdScreenshot,//截屏命令
    MqttAndPrivateCmdVoice,//语音控制命令
};

#pragma mark - Connect相关

/**
 客户端连接委托，连接结果在委托函数中获得
 */
@protocol ConnectResultDelegate <NSObject>


/**
 客户端连接结果

 @param tranport 私有协议or mqtt
 
 @param result 连接结果
 */
- (void)clientConnectResult:(BOOL)connectResult;

@end

@protocol VoiceConnectResultDelegate <NSObject>

- (void)voiceClientConnect:(TransportProtocol)transport Result:(BOOL)result;

@end

#pragma mark - 连接丢失

@protocol MqttAndPrvtConnectionLostDelegate <NSObject>


/**
 连接丢失
 */
- (void)mqttAndPrvtConnectionLost;

@end

#pragma mark - 更改电视名称
/**
 电视收到更改电视名称指令委托，用在EditNameVC页面
 */
@protocol MqttAndPrvtRecvTVCmdEditTVNameDelegate1<NSObject>

/**
 电视接收到更改名称指令
 */
- (void)mqttAndPrvtRecvTVCmdCallBack1;

@end

/**
 电视执行更改电视名称指令委托，用在MyDev更新设备列表
 */
@protocol MqttAndPrvtRecvTVCmdEditTVNameDelegate2<NSObject>

- (void)mqttAndPrvtRecvTVCmdCallBack2:(NSString *)TVName Result:(NSString *)result;

@end

#pragma mark - 输入法

/**
 电视输入法页面输入框内容委托
 */
@protocol MqttAndPrvtRecvTVCmdInputMethodDelegate <NSObject>


/**
 电视输入法委托

 @param inputMsg 电视输入框内的内容
 */
- (void)mqttAndPrvtRecvTVCmdInputMsg:(NSString *)inputMsg;

@end

#pragma mark - 电视主动截屏

/**
 电视主动截屏委托
 */
@protocol MqttAndPrvtRecvTVCmdTVSendScreenShotDelegate <NSObject>

/**
 接收到电视主动截屏后发送的图片信息

 @param screenShot 电视截屏图片data
 @param imageName 电视截屏图片名称
 */
- (void)mqttAndPrvtRecvTVCmdTVSendScreenShot:(NSData *)screenShot imageName:(NSString *)imageName;

@end

#pragma mark - 电视截屏

/**
 通过app手动截屏委托
 */
@protocol MqttAndPrvtRecvTVCmdScreenShotDataDelegate <NSObject>


/**
 通过app手动截屏获取到截屏数据

 @param screenShotData 截屏图片数据
 */
- (void)MqttAndPrvtRecvTVCmdScreenShotData:(NSData *)screenShotData;

@end

#pragma mark - 语音助手
@protocol MqttAndPrvtVoiceAssistantDelegate <NSObject>

- (void)mqttAndPrvtVoiceAssistCallback:(BOOL)isOpen;

@end

@interface MqttAndPrivateComu : NSObject


/**
 连接丢失
 */
@property (weak, nonatomic) NSObject<MqttAndPrvtConnectionLostDelegate> *mqttAndPrvtConnectionLostDelegate;

#pragma mark - Property

@property (nonatomic, weak) NSObject<ConnectResultDelegate> *connectResultDelegate;
@property (nonatomic, weak) NSObject<VoiceConnectResultDelegate> *voiceConnectResultDelegate;

@property (nonatomic, weak) NSObject<MqttAndPrvtRecvTVCmdInputMethodDelegate> *inputMethodDelegate;

/**
 通信方式：TransportProtocolMQTT或者TransportProtocolPrivateObject
 */
@property (nonatomic, assign) TransportProtocol devTransportProtocol;

@property (strong, nonatomic) NSString *currentIp;


/**
 部分电视有dlna，但是没有私有协议或者mqtt，YES，即没有私有协议或者mqtt；NO：有私有协议或者mqtt
 */
@property (assign, nonatomic) BOOL isFinalConnected;


@property (assign, nonatomic) BOOL isClientConnected;


/**
 更改后的电视名称
 */
@property (strong, nonatomic) NSString *changedName;
@property (weak, nonatomic) NSObject<MqttAndPrvtRecvTVCmdEditTVNameDelegate1> *editTVNameDelegate1;
@property (weak, nonatomic) NSObject<MqttAndPrvtRecvTVCmdEditTVNameDelegate2> *editTVnameDelegate2;

/**
 电视截屏的图片
 */
@property (nonatomic, strong) UIImage *cutTVShowImg;

/**
 电视截屏的图片数据
 */
@property (nonatomic, strong) NSData *cutTVShowImgData;


/**
 是否接收电视主动截屏的消息
 */
@property (assign, nonatomic) BOOL canRecvTVScreenShot;

@property (nonatomic, weak) NSObject<MqttAndPrvtRecvTVCmdScreenShotDataDelegate> *screenShotDelegate;

@property (nonatomic, weak) NSObject<MqttAndPrvtRecvTVCmdTVSendScreenShotDelegate> *mqttAndPrvtRecvTVCmdTVSendScreenShotDelegate;

/**
 语音助手
 */
@property (nonatomic, strong) VoiceAssistant *pVoiceAssistant;
@property (nonatomic, weak) NSObject<MqttAndPrvtVoiceAssistantDelegate> *mqttAndPrvtVoiceAssistantDelegate;

+ (MqttAndPrivateComu *)shareMqttAndPrivateComu;

#pragma mark - Connect and Disconnect
/**
 连接到dlna.curDev上，连接之前需要指定devTransportProtocol是Mqtt还是PrivateProtocol
 */
- (void)clientConnect;

- (void)clientDisconnect;

- (void)voiceClientConnect;

- (void)voiceClientDisconnect;

#pragma mark - Send

- (void)sendKeyStr:(NSString *)keyStr type:(MqttAndPrivateCmd)type;

- (void)sendVoiceData:(NSData *)voiceData;






















@end
