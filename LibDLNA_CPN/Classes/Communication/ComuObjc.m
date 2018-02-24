//
//  ComuObjc.m
//  HsShare3.5
//
//  Created by 尚轩瑕 on 2017/10/26.
//  Copyright © 2017年 com.hisense. All rights reserved.
//

#import "ComuObjc.h"
#import "ComuObjcPrivateKey.h"
#import "DLNAObject.h"
#import "Header.h"

@interface ComuObjc ()


/**
 命令通信mqttclient
 */
@property (nonatomic, strong) MQTTClient *cmdMqttClient;


/**
 语音数据发送专用mqttclient
 */
@property (nonatomic, strong) MQTTClient *voiceMqttClient;

@property (nonatomic, strong) DLNAObject *dlnaObj;

@end

@implementation ComuObjc

+ (ComuObjc *)shareComuObjc {
    static ComuObjc *comuObjc = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        comuObjc = [[ComuObjc alloc] init];
        [comuObjc initCmdMqttClient];
        [comuObjc initVoiceMqttClient];
    });
    
    return comuObjc;
}


/**
 初始化命令通信mqtt
 */
- (void)initCmdMqttClient {
    self.cmdMqttClient = [[MQTTClient alloc] initWithClientId:CMD_MQTT_ID];
    self.cmdMqttClient.port = MQTT_PORT;
    self.cmdMqttClient.username = MQTT_USER;
    self.cmdMqttClient.password = MQTT_PWD;
    
    __block ComuObjc *weak_self = self;
    self.cmdMqttClient.messageHandler = ^(MQTTMessage *message) {
        [weak_self cmdMqttDidReceiveMsg:message];
    };
    self.cmdMqttClient.connectionLostHandler = ^(NSUInteger code) {
        [weak_self mqttLostTheConnection:code];
    };
    NSLog(@"内存地址__mqttClient:%p", self.cmdMqttClient);
}

/**
 初始化语音数据通信mqtt
 */
- (void)initVoiceMqttClient {
    self.voiceMqttClient = [[MQTTClient alloc] initWithClientId:VOICE_MQTT_ID];
    self.voiceMqttClient.port = MQTT_PORT;
    self.voiceMqttClient.username = MQTT_USER;
    self.voiceMqttClient.password = MQTT_PWD;
    
    NSLog(@"内存地址__voiceMqttClient:%p", self.voiceMqttClient);
}

/**
 初始化各种变量
 */
- (void)initOtherPrams {
    self.dlnaObj = [DLNAObject shareDlnaObj];
}

#pragma mark - Connect

/**
 命令通信mqtt连接到指定host的设备，内部调用的'connectToHost'函数为异步调用（在多线程中执行），不能立刻获得连接结果，需要延迟一段时间才会获得，因此在验证连接成功与否时通过delegate进行连接成功后的处理。

 @param completionHandler 连接结果处理函数
 */
- (void)cmdMqttClientConnectWithCompletionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler {
    DLNAObject *dlnaOb = [DLNAObject shareDlnaObj];
    NSString *currentIp = [dlnaOb.devArr objectAtIndex:dlnaOb.curDevIndex][kIp];
    NSLog(@"comuObj当前IP__：%@", currentIp);
    [self.cmdMqttClient connectToHost:currentIp completionHandler:completionHandler];
}

- (void)voiceMqttClientConnectWithCompletionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler {
    DLNAObject *dlnaOb = [DLNAObject shareDlnaObj];
    NSString *currentIp = [dlnaOb.devArr objectAtIndex:dlnaOb.curDevIndex][kIp];
    NSLog(@"comuObj当前IP__：%@", currentIp);
    [self.voiceMqttClient connectToHost:currentIp completionHandler:completionHandler];
}

#pragma mark - Disconnect
/**
 命令通信mqtt与设备断开连接
 */
- (void)cmdMqttClientDisConnect {
    [self clientDisConnect:self.cmdMqttClient];
}

/**
 语音数据发送mqtt与设备断开连接
 */
- (void)voiceMqttClientDisConnect {
    [self clientDisConnect:self.voiceMqttClient];
}


/**
 client断开连接

 @param client 要断开连接的client
 */
- (void)clientDisConnect:(MQTTClient *)client {
    [client disconnectWithCompletionHandler:^(NSUInteger code) {
        if (client == self.cmdMqttClient) {
            NSLog(@"disconnect__通信mqttClient断开连接成功");
        } else if (client == self.voiceMqttClient) {
            NSLog(@"disconnect__语音数据发送mqttClient断开连接成功");
        }
    }];
}

#pragma mark - mqtt lost connection


/**
 mqtt连接丢失

 @param code 代码
 */
- (void)mqttLostTheConnection:(NSUInteger)code {
    [self.mqttLostConnectionDelegate mqttLostConnection:code];
}

#pragma mark - cmdMqtt Send Message

/**
 命令通信mqtt向电视发送命令
 
 @param str 命令内容
 @param topic 命令topic
 */
- (void)cmdMqttSendkeyStr:(NSString *)str toTopic:(MQTTAppTopicCmd)topicCmd {
    NSLog(@"send__curDevID = %@", CMD_MQTT_ID);
    
    //topic格式参考文档“topic定义.numbers”
    NSString *topicType;
    switch (topicCmd) {
        case MQTTAppTopicCmdSendKey:
            topicType = @"sendkey";
            break;
        case MQTTAppTopicCmdInput:
            topicType = @"input";
            break;
        case MQTTAppTopicCmdScreenshot:
            topicType = @"screenshot";
            break;
        case MQTTAppTopicCmdVoice:
            topicType = @"voice";
            break;
        case MQTTAppTopicCmdChangeTVName:
            topicType = @"changetvname";
            break;
        case MQTTAppTopicCmdDeviceConnect:
            topicType = @"deviceconnect";
            break;
    }
    NSString *topic = [NSString stringWithFormat:@"/remoteapp/tv/hiservice_cmd/${%@}/actions/%@", CMD_MQTT_ID, topicType];
    
    //Qos:稳定性，ExactlyOnce表示最高级别的服务质量，消息丢失和重复都是不可接受的。
    //retain:设置是否在服务器中保存消息体
    [self.cmdMqttClient publishString:str toTopic:topic withQos:ExactlyOnce retain:NO completionHandler:^(int mid) {
        NSLog(@"send__消息发送成功");
    }];
}

#pragma mark - cmdMqtt Receieve Message
/**
 命令通信mqtt准备接收电视的信息，接收数据处理函数为didReceiveMsg:
 topic格式：/remoteapp/mobile/${uuid}/#
 */
- (void)cmdMqttReadyReceiveData {
    NSString *subscribeTopic = [NSString stringWithFormat:@"/remoteapp/mobile/${%@}/#", CMD_MQTT_ID];
    //电视给手机回复数据的消息主题：/remoteapp/mobile/${uuid}/${appname}/data/${actionname}
    [self.cmdMqttClient subscribe:subscribeTopic withCompletionHandler:^(NSArray *grantedQos) {
        //do something
        NSLog(@"receive__订阅信息成功，当前订阅topic:%@", subscribeTopic);
    }];
    
    NSString *subScribeScreenShotTopic = [NSString stringWithFormat:@"/remoteapp/mobile/broadcast/#"];
    [self.cmdMqttClient subscribe:subScribeScreenShotTopic withCompletionHandler:^(NSArray *grantedQos) {
        NSLog(@"receive__订阅信息成功，当前订阅topic:%@", subScribeScreenShotTopic);
    }];
}

/**
 命令通信mqtt订阅电视topic，准备接收电视的信息，接收数据处理函数为didReceiveMsg:

 @param topic 待订阅topic
 */
- (void)cmdMqttReadyReceiveDataWithTopic:(NSString *)topic {
    [self.cmdMqttClient subscribe:topic withCompletionHandler:^(NSArray *grantedQos) {
        NSLog(@"receive__订阅信息成功，当前订阅topic:%@", topic);
    }];
}


/**
 命令通信mqtt取消订阅电视topic

 @param topic 待取消的topic
 */
- (void)cmdMqttRemoveTopic:(NSString *)topic {
    [self.cmdMqttClient unsubscribe:topic withCompletionHandler:^{
        NSLog(@"receive__取消订阅信息成功，当前订阅topic:%@", topic);
    }];
}

/**
 mqtt处理接收到的电视端发送的信息，此函数不在主线程中，需要注意接收信息时线程的问题，如图片的赋值
 
 @param msg 接收到的信息
 */
- (void)cmdMqttDidReceiveMsg:(MQTTMessage *)msg {
    NSLog(@"receive__MQTT Receive Msg_topic:%@", msg.topic);
    NSLog(@"receive__MQTT Receive Msg_mid:%d", msg.mid);
    NSLog(@"receive__MQTT Receive Msg_playloadString: %@", [msg payloadString]);
    NSLog(@"receive__MQTT receive Msg_payloadData:%luld", (unsigned long)msg.payload.length);
    
    if ([msg.topic hasSuffix:@"/hiservice/data/input"]) {//输入法
        //获取电视文本框中的信息并更新到app页面编辑textField中
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mqttRecvTVCmdInputMethodDelegate mqttRecvTVCmdInputMethod:[msg payloadString]];
        });
    } else if ([msg.topic hasSuffix:@"/hiservice/data/screenshot"]) {//截屏
        dispatch_async(dispatch_get_main_queue(), ^{
            //接收到电视截屏图片数据
            [self.mqttRecvTVCmdScreenShotDataDelegate mqttRecvTVCmdScreenShotData:msg.payload];
        });
    } else if ([msg.topic hasSuffix:@"/hiservice/data/changetvname"]) {//更改电视名称
        NSString *result = [msg payloadString];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mqttRecvTVCmdEditTVNameDelegate mqttRecvTVCmdEditTVName:result];
        });
    } else if ([msg.topic hasSuffix:@"/hiservice/data/voice"]) {
        if ([[msg payloadString] hasSuffix:@"$0"]) {//开启语音控制结果：成功
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mqttRecvTVCmdVoiceStartControlDelegate mqttRecvTVCmdVoiceStartControl:YES];
            });
        }else if ([[msg payloadString] hasSuffix:@"START_VOICE_RECOGNITION"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mqttRecvTVCmdVoiceStartRecognitionDelegate mqttRecvTVCmdVoiceStartRecognition:YES];
            });
        } else if ([[msg payloadString] hasSuffix:@"CLOSE_VOICE_CONTROL"]) {
            [self.mqttRecvTVCmdVoiceCloseControlDelegate mqttRecvTVCmdVoiceCloseControl:YES];
        } else {//开启语音控制结果：失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mqttRecvTVCmdVoiceStartControlDelegate mqttRecvTVCmdVoiceStartControl:NO];
            });
        }
    } else if ([msg.topic hasSuffix:@"/AIVirtualAssistant/data/screenshot"]) {//电视主动截屏分享
        NSLog(@"__电视主动截屏分享收到信息");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getImageInfo:msg.payload];
        });
    }
}


/**
 解析出截屏图片数据。电视传来的截屏信息包含：4个字节的图片名字长度+图片名字+4个字节的图片长度+图片信息

 @param imageData 电视传来的截屏信息
 */
- (void)getImageInfo:(NSData *)imageData {
    Byte imageNameLengthBytes[4];
    [imageData getBytes:imageNameLengthBytes length:4];//获取存储图片名称长度的字节
    
    int imageNameLenth = (int)((imageNameLengthBytes[0]&0xff) | ((imageNameLengthBytes[1] << 8)&0xff00) | ((imageNameLengthBytes[2]<<16)&0xff0000) | ((imageNameLengthBytes[3]<<24)&0xff000000));//解析出存储图片名称的字节数
    
    Byte newByte[imageNameLenth];
    [imageData getBytes:newByte range:NSMakeRange(4, imageNameLenth)];//获取存储图片名称的字节
    NSString *imageName = [[NSString alloc] initWithBytes:newByte length:imageNameLenth encoding:NSUTF8StringEncoding];//解析出图片名称
    
    Byte imageLengthBytes[4];
    [imageData getBytes:imageLengthBytes range:NSMakeRange((4 + imageNameLenth), 4)];//获取存储图片长度的字节
    int imageLength = ((imageLengthBytes[0]&0xff) | ((imageLengthBytes[1] << 8)&0xff00) | ((imageLengthBytes[2] << 16)&0xff0000) | ((imageLengthBytes[3] << 24)&0xff000000));//解析出存储图片长度的字节数

    NSData *data = [imageData subdataWithRange:NSMakeRange((8 + imageNameLenth), imageLength)];//获取图片数据
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mqttRecvTVCmdTVSendScreenShotDelegate mqttRecvTVCmdTVSendScreenShot:data imageName:imageName];
    });
    
}

#pragma mark - VoiceMqtt Send Message

/**
 语音数据发送mqtt发送语音数据
 
 @param voiceData 语音数据
 */
- (void)voiceMqttSendVoiceData:(NSData *)voiceData {
    ///remoteapp/tv/hiservice_voicedata/${uuid}/data/voice
    NSString *topic = [NSString stringWithFormat:@"/remoteapp/tv/hiservice_voicedata/${%@}/data/voice", VOICE_MQTT_ID];
    
    //Qos:稳定性，ExactlyOnce表示最高级别的服务质量，消息丢失和重复都是不可接受的。
    //retain:设置是否在服务器中保存消息体
    [self.voiceMqttClient publishData:voiceData toTopic:topic withQos:ExactlyOnce retain:NO completionHandler:^(int mid) {
        NSLog(@"voiceData__send__消息发送成功");
    }];
}

#pragma mark - 刚打开app时抓取电视主动截屏


/**
 刚开机时主动去抓取电视上已有电视截屏
 */
- (void)getTVScreenShot {
    NSString *topic = [NSString stringWithFormat:@"/remoteapp/tv/AIVirtualAssistant/actions/screenshot"];
    [self.cmdMqttClient publishString:@"" toTopic:topic withQos:ExactlyOnce retain:NO completionHandler:^(int mid) {
        NSLog(@"__主动抓取电视截屏成功");
    }];
}


@end
