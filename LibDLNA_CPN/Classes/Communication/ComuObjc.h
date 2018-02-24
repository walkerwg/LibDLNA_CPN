//  MQTT
//  ComuObjc.h
//  HsShare3.5
//
//  Created by 尚轩瑕 on 2017/10/26.
//  Copyright © 2017年 com.hisense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VoiceAssistant.h"
#import "MQTTKit.h"


/**
 手机发布topic命令
 */
typedef NS_ENUM(char, MQTTAppTopicCmd) {
    MQTTAppTopicCmdSendKey,//遥控器控制命令
    MQTTAppTopicCmdInput,//输入法控制命令
    MQTTAppTopicCmdScreenshot,//截屏命令
    MQTTAppTopicCmdVoice,//语音控制命令
    MQTTAppTopicCmdChangeTVName,//修改电视名称命令
    MQTTAppTopicCmdDeviceConnect,//连接或断开
};


#pragma mark - 连接丢失相关

@protocol MqttLostconnectionDelegate <NSObject>

- (void)mqttLostConnection:(NSUInteger)code;

@end

#pragma mark - 电视主动截屏

/**
 电视主动截屏委托
 */
@protocol MqttRecvTVCmdTVSendScreenShotDelegate <NSObject>

/**
 接收到电视主动截屏后发送的图片信息

 @param screenShotData 电视截屏图片data
 @param imageName 电视截屏图片名称
 */
- (void)mqttRecvTVCmdTVSendScreenShot:(NSData *)screenShotData imageName:(NSString *)imageName;

@end

#pragma mark - 电视截屏

/**
 通过app手动截屏
 */
@protocol MqttRecvTVCmdScreenShotDataDelegate<NSObject>


/**
 通过app手动截屏得到的截屏图片

 @param screenShotData 图片数据
 */
- (void)mqttRecvTVCmdScreenShotData:(NSData *)screenShotData;

@end

#pragma mark - 更改电视名称

/**
 mqtt接收到了电视返回的关于更改电视名称的命令
 */
@protocol MqttRecvTVCmdEditTVNameDelegate<NSObject>

- (void)mqttRecvTVCmdEditTVName:(NSString *)result;

@end

#pragma mark - 输入法

@protocol MqttRecvTVCmdInputMethodDelegate<NSObject>

- (void)mqttRecvTVCmdInputMethod:(NSString *)inputMsg;

@end

#pragma mark - 语音助手

/**
 START_VOICE_CONTROL
 */
@protocol MqttRecvTVCmdVoiceStartControlDelegate <NSObject>

- (void)mqttRecvTVCmdVoiceStartControl:(BOOL)startResult;

@end

/**
 START_VOICE_RECOGNITION
 */
@protocol MqttRecvTVCmdVoiceStartRecognitionDelegate <NSObject>

- (void)mqttRecvTVCmdVoiceStartRecognition:(BOOL)recognitionResult;

@end

/**
 CLOSE_VOICE_CONTROL
 */
@protocol MqttRecvTVCmdVoiceCloseControlDelegate <NSObject>

- (void)mqttRecvTVCmdVoiceCloseControl:(BOOL)closeResult;

@end

@interface ComuObjc : NSObject

@property (weak, nonatomic) NSObject<MqttLostconnectionDelegate> *mqttLostConnectionDelegate;
/**
 语音助手：START_VOICE_CONTROL
 */
@property (nonatomic, weak) NSObject<MqttRecvTVCmdVoiceStartControlDelegate> *mqttRecvTVCmdVoiceStartControlDelegate;

/**
 语音助手：START_VOICE_RECOGNITION
 */
@property (nonatomic, weak) NSObject<MqttRecvTVCmdVoiceStartRecognitionDelegate> *mqttRecvTVCmdVoiceStartRecognitionDelegate;

/**
 语音助手：CLOSE_VOICE_CONTROL
 */
@property (nonatomic, weak) NSObject<MqttRecvTVCmdVoiceCloseControlDelegate> *mqttRecvTVCmdVoiceCloseControlDelegate;

/**
 通过app手动截屏
 */
@property (nonatomic, weak) NSObject<MqttRecvTVCmdScreenShotDataDelegate> *mqttRecvTVCmdScreenShotDataDelegate;

/**
 电视主动截屏委托
 */
@property (nonatomic, weak) NSObject<MqttRecvTVCmdTVSendScreenShotDelegate> *mqttRecvTVCmdTVSendScreenShotDelegate;

/**
 更改后的电视名称
 */
@property (nonatomic, strong) NSString *changedName;


/**
 电视设备不支持mqtt协议或者没连上mqtt标志。此时“我的设备”页面中已发现设备列表中会显示该设备已经连接上但是不会出现悬浮的遥控器按钮
 */
@property (assign, nonatomic) BOOL isFinalConnected;

@property (assign, nonatomic) BOOL isClientConnected;

/**
 更改电视名称委托
 */
@property (nonatomic, weak) NSObject<MqttRecvTVCmdEditTVNameDelegate> *mqttRecvTVCmdEditTVNameDelegate;

/**
 输入法委托
 */
@property (nonatomic, weak) NSObject<MqttRecvTVCmdInputMethodDelegate> *mqttRecvTVCmdInputMethodDelegate;

+ (ComuObjc *)shareComuObjc;

#pragma mark - Connect

/**
 命令通信mqtt连接到指定的设备上，异步调用

 @param completionHandler 连接完成handler
 */
- (void)cmdMqttClientConnectWithCompletionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler;

/**
 语音数据发送mqtt连接到指定的设备上，异步调用
 
 @param completionHandler 连接完成handler
 */
- (void)voiceMqttClientConnectWithCompletionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler;

#pragma mark - Disconnect

/**
 命令通信mqtt与设备断开连接
 */
- (void)cmdMqttClientDisConnect;

/**
 语音数据发送mqtt与设备断开连接
 */
- (void)voiceMqttClientDisConnect;

#pragma mark - Send Message

/**
 命令通信mqtt向电视发送命令
 
 @param str 命令内容
 @param topic 命令topic
 */
- (void)cmdMqttSendkeyStr:(NSString *)str toTopic:(MQTTAppTopicCmd)topicCmd;

/**
 语音数据发送mqtt发送语音数据
 
 @param voiceData 语音数据
 */
- (void)voiceMqttSendVoiceData:(NSData *)voiceData;

#pragma mark - 电视回调注册函数

/**
 命令通信mqtt订阅电视topic，准备接收电视的信息，接收数据处理函数为didReceiveMsg:
 
 @param topic 待订阅topic
 */
- (void)cmdMqttReadyReceiveDataWithTopic:(NSString *)topic;

/**
 电视回调注册函数，连接成功后接着注册
 topic格式：/remoteapp/mobile/${uuid}/#
 */
- (void)cmdMqttReadyReceiveData;

/**
 命令通信mqtt取消订阅电视topic
 
 @param topic 待取消的topic
 */
- (void)cmdMqttRemoveTopic:(NSString *)topic;

#pragma mark - 主动抓取电视截屏
/**
 刚开机时主动去抓取电视上已有电视截屏
 */
- (void)getTVScreenShot;
















@end
