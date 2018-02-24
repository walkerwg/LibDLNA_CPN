//
//  MqttAndPrivateComu.m
//  HsShare3.5
//
//  Created by 尚轩瑕 on 2017/11/8.
//  Copyright © 2017年 com.hisense. All rights reserved.
//

#import "MqttAndPrivateComu.h"
#import "PrivateObject.h"
#import "ComuObjc.h"
#import "VoiceAssistant.h"

#import "DLNAObject.h"
#import "Header.h"
#include "hs_adaptation_client.h"
#import "HS_Toast/HSToast.h"
@interface MqttAndPrivateComu ()<MqttRecvTVCmdEditTVNameDelegate, PrvtRecvTVCmdEditTVNameDelegate, MqttRecvTVCmdInputMethodDelegate, PrvtRecvTVCmdInputMethodDelegate, MqttRecvTVCmdScreenShotDataDelegate, PrvtRecvTVCmdScreenShotDataDelegate, MqttRecvTVCmdVoiceStartControlDelegate, PrvtRecvTVCmdVoiceStartControlDelegate, MqttRecvTVCmdVoiceStartRecognitionDelegate, MqttRecvTVCmdVoiceCloseControlDelegate, PrvtRecvTVCmdVoiceStartRecognitionDelegate, PrvtRecvTVCmdVoiceCloseControlDelegate, MqttRecvTVCmdTVSendScreenShotDelegate, MqttLostconnectionDelegate, PrvtConnectionLostDelegate>

@property (nonatomic, strong) ComuObjc      *mqttObj;
@property (nonatomic, strong) PrivateObject *privaObj;
//@property (nonatomic, strong) DLNAObject    *dlnaObj;

@end

@implementation MqttAndPrivateComu

+ (MqttAndPrivateComu *)shareMqttAndPrivateComu {
    static MqttAndPrivateComu *mqttAndPrivComuObj = nil;
    static dispatch_once_t once;
    _dispatch_once(&once, ^{
        mqttAndPrivComuObj = [[MqttAndPrivateComu alloc] init];
        
        [mqttAndPrivComuObj initMqttObject];
        [mqttAndPrivComuObj initPrivateObject];
        
    });
    
    return mqttAndPrivComuObj;
}

- (void)initMqttObject {
    self.mqttObj = [ComuObjc shareComuObjc];
    self.mqttObj.mqttRecvTVCmdEditTVNameDelegate = self;
    self.mqttObj.mqttRecvTVCmdInputMethodDelegate = self;
    self.mqttObj.mqttRecvTVCmdScreenShotDataDelegate = self;
    self.mqttObj.mqttRecvTVCmdVoiceStartControlDelegate = self;
    self.mqttObj.mqttRecvTVCmdVoiceStartRecognitionDelegate = self;
    self.mqttObj.mqttRecvTVCmdVoiceCloseControlDelegate = self;
    self.mqttObj.mqttRecvTVCmdTVSendScreenShotDelegate = self;
    self.mqttObj.mqttLostConnectionDelegate = self;
}

- (void)initPrivateObject {
    self.privaObj = [PrivateObject sharePrivateObj];
    self.privaObj.currentIp = self.currentIp;
    self.privaObj.prvtRecvTVCmdEditTVNameDelegate = self;
    self.privaObj.prvtRecvTVCmdInputMethodDelegate = self;
    self.privaObj.prvtRecvTVCmdScreenShotDataDelegate = self;
    self.privaObj.prvtRecvTVCmdVoiceStartControlDelegate = self;
    self.privaObj.prvtRecvTVCmdVoiceStartRecognitionDelegate = self;
    self.privaObj.prvtRecvTVCmdVoiceCloseControlDelegate = self;
    self.privaObj.prvtConnectionLostDelegate = self;
    [self.privaObj registerMsgCallBack];
}

#pragma mark - Connect and Disconnect
/**
 连接到dlna.curDev上，连接之前需要指定devTransportProtocol是Mqtt还是PrivateProtocol
 */
- (void)clientConnect {
    DLNAObject *dlnaObj = [DLNAObject shareDlnaObj];
    if (dlnaObj.curDevIndex != -1 && dlnaObj.curDevIndex != -2) {
        switch (self.devTransportProtocol) {
            case TransportProtocolPrivateObject: {
                [self.privaObj clientDisConn];//首先断开连接
                int clientConnTryTimes = 3;
                while (clientConnTryTimes-- >= 0) {
                    enum ClientType clientResult = [self.privaObj clientConn];
                    if (clientResult != NoClient) {
                        NSLog(@"MqttAndPrivateComu__private连接成功");
                        [self.connectResultDelegate clientConnectResult:YES];
                        break;
                    }
                }
                if(clientConnTryTimes < 0) {
                    NSLog(@"MqttAndPrivateComu__private连接失败");
                    [self.connectResultDelegate clientConnectResult:NO];;
                }
            }
                break;
                
            case TransportProtocolMQTT: {
                [self.mqttObj cmdMqttClientDisConnect];//首先断开连接
                [self.mqttObj cmdMqttClientConnectWithCompletionHandler:^(MQTTConnectionReturnCode code) {
                    if (code == ConnectionAccepted) {
                        NSLog(@"MqttAndPrivateComu__mqtt连接成功");
                        
                        [self.connectResultDelegate clientConnectResult:YES];
                        //[self.mqttObj cmdMqttReadyReceiveData];//注册信息接收的回调函数
                        [self mqttRegisterMsgCallBack];//注册信息接收的回调函数
                        [self mqttRegisterMsgCallBackTVScreenShot];//注册电视截屏信息回调函数
                        [self sendConnectMsg];
                        [self.mqttObj getTVScreenShot];//刚开机时主动抓取电视上已有的截屏
                    } else {
                        
                        NSLog(@"MqttAndPrivateComu__mqtt连接失败");
                        [self.connectResultDelegate clientConnectResult:NO];
                    }
                }];
            }
                break;
        }
    }
}


/**
 mqtt注册普通电视信息接收函数
 */
- (void)mqttRegisterMsgCallBack {
    NSString *subscribeTopic = [NSString stringWithFormat:@"/remoteapp/mobile/${%@}/#", CMD_MQTT_ID];
    [self.mqttObj cmdMqttReadyReceiveDataWithTopic:subscribeTopic];
}

/**
 mqtt注册电视主动截屏信息接收函数
 */
- (void)mqttRegisterMsgCallBackTVScreenShot {
    NSString *subScribeScreenShotTopic = [NSString stringWithFormat:@"/remoteapp/mobile/broadcast/#"];
    [self.mqttObj cmdMqttReadyReceiveDataWithTopic:subScribeScreenShotTopic];
}


/**
 mqtt取消注册电视主动截屏
 */
- (void)mqttUnregisterMsgCallBack {
    NSString *unSubscribeTopic = [NSString stringWithFormat:@"/remoteapp/mobile/broadcast/#"];
    [self.mqttObj cmdMqttRemoveTopic:unSubscribeTopic];
}

- (void)setCanRecvTVScreenShot:(BOOL)canRecvTVScreenShot {
    _canRecvTVScreenShot = canRecvTVScreenShot;
    if (canRecvTVScreenShot) {
        [self mqttRegisterMsgCallBackTVScreenShot];
    } else {
        [self mqttUnregisterMsgCallBack];
    }
}

/**
 发送手机已经连接电视的通知给电视
 */
- (void)sendConnectMsg {
    NSString *devType = [GlobalUtils getDevTypeStr];
    NSString *connectMsg = [NSString stringWithFormat:@"SEND_DEVICE_CONNECT$%@", devType];
    NSLog(@"__当前手机型号：%@", devType);
    [self.mqttObj cmdMqttSendkeyStr:connectMsg toTopic:MQTTAppTopicCmdDeviceConnect];
}

- (void)voiceClientConnect {
    switch (self.devTransportProtocol) {
        case TransportProtocolPrivateObject: {
            
        }
            break;
            
        case TransportProtocolMQTT: {
            [self.mqttObj voiceMqttClientConnectWithCompletionHandler:^(MQTTConnectionReturnCode code) {
                if (code == ConnectionAccepted) {
                    NSLog(@"MqttAndPrivateComu__voiceMqtt连接成功");
                    [self.voiceConnectResultDelegate voiceClientConnect:TransportProtocolMQTT Result:YES];
                } else {
                    NSLog(@"MqttAndPrivateComu__voiceMqtt连接失败");
                    [self.voiceConnectResultDelegate voiceClientConnect:TransportProtocolMQTT Result:NO];
                }
            }];
        }
            break;
    }
}

- (void)clientDisconnect {
    switch (self.devTransportProtocol) {
        case TransportProtocolPrivateObject: {
            [self.privaObj clientDisConn];
        }
            break;
            
        case TransportProtocolMQTT: {
            //断开连接前先发布将要断开连接topic
            [self.mqttObj cmdMqttSendkeyStr:@"SEND_DEVICE_DISCONNECT" toTopic:MQTTAppTopicCmdDeviceConnect];
            [self.mqttObj cmdMqttClientDisConnect];
        }
            break;
    }
    
}

- (void)voiceClientDisconnect {
    switch (self.devTransportProtocol) {
        case TransportProtocolPrivateObject: {
            
        }
            break;
            
        case TransportProtocolMQTT: {
            [self.mqttObj voiceMqttClientDisConnect];
        }
            break;
    }
}

#pragma mark - Send

- (void)sendKeyStr:(NSString *)keyStr type:(MqttAndPrivateCmd)type {
    switch (type) {
        case MqttAndPrivateCmdChangeTVName: {//更改电视名称
            switch (self.devTransportProtocol) {
                case TransportProtocolPrivateObject: {
                    NSString *sendKeyStr = [NSString stringWithFormat:@"%s$%@", SEND_CHANGE_TVNAME, keyStr];
                    [self.privaObj sendCtrlKey:(char *)sendKeyStr.UTF8String type:MSG_TYPE_INPUT];
                }
                    break;
                    
                case TransportProtocolMQTT: {
                    [self.mqttObj cmdMqttSendkeyStr:keyStr toTopic:MQTTAppTopicCmdChangeTVName];
                }
                    break;
            }
        }
            break;
            
        case MqttAndPrivateCmdSendKey: {//遥控器控制命令
            switch (self.devTransportProtocol) {
                case TransportProtocolPrivateObject: {
                    [self.privaObj sendCtrlKey:(char *)keyStr.UTF8String type:MSG_TYPE_KEY];
                }
                    break;
                    
                case TransportProtocolMQTT: {
                    [self.mqttObj cmdMqttSendkeyStr:keyStr toTopic:MQTTAppTopicCmdSendKey];
                }
                    break;
            }
        }
            break;
        case MqttAndPrivateCmdInput: {
            switch (self.devTransportProtocol) {
                case TransportProtocolPrivateObject: {
                    [self.privaObj sendCtrlKey:(char *)keyStr.UTF8String type:MSG_TYPE_INPUT];
                }
                    break;
                    
                case TransportProtocolMQTT: {
                    [self.mqttObj cmdMqttSendkeyStr:keyStr toTopic:MQTTAppTopicCmdInput];
                }
                    break;
            }
        }
            break;
        case MqttAndPrivateCmdScreenshot: {
            switch (self.devTransportProtocol) {
                case TransportProtocolPrivateObject: {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self.privaObj cutTVPic];
                    });
                }
                    break;
                    
                case TransportProtocolMQTT: {
                    [self.mqttObj cmdMqttSendkeyStr:keyStr toTopic:MQTTAppTopicCmdScreenshot];
                }
                    break;
            }
        }
            break;
        case MqttAndPrivateCmdVoice: {
            switch (self.devTransportProtocol) {
                case TransportProtocolPrivateObject: {
                    [self.privaObj sendCtrlKey:(char *)keyStr.UTF8String type:MSG_TYPE_VOICE];
                }
                    break;
                    
                case TransportProtocolMQTT: {
                    [self.mqttObj cmdMqttSendkeyStr:keyStr toTopic:MQTTAppTopicCmdVoice];
                }
                    break;
            }
        }
            break;
    }
}


/**
 发送语音数据

 @param voiceData 语音数据
 */
- (void)sendVoiceData:(NSData *)voiceData {
    switch (self.devTransportProtocol) {
        case TransportProtocolPrivateObject: {
            
        }
            break;
            
        case TransportProtocolMQTT: {
            [self.mqttObj voiceMqttSendVoiceData:voiceData];
        }
            break;
    }
}

#pragma mark - Receive

#pragma mark 更改电视名称

- (void)mqttRecvTVCmdEditTVName:(NSString *)result {
    NSLog(@"__进入更改名称回调一");
    [self.editTVNameDelegate1 mqttAndPrvtRecvTVCmdCallBack1];
    [self.editTVnameDelegate2 mqttAndPrvtRecvTVCmdCallBack2:self.changedName Result:result];
}

- (void)prvtRecvTVCmdEditTVName:(NSString *)result {
    [self.editTVNameDelegate1 mqttAndPrvtRecvTVCmdCallBack1];
    [self.editTVnameDelegate2 mqttAndPrvtRecvTVCmdCallBack2:self.changedName Result:result];
}

#pragma mark 输入法
//MqttAndPrvtRecvTVCmdInputMethodDelegate
- (void)mqttRecvTVCmdInputMethod:(NSString *)inputMsg {
    [self.inputMethodDelegate mqttAndPrvtRecvTVCmdInputMsg:inputMsg];
}

- (void)prvtRecvTVCmdInputMethod:(NSString *)inputMsg {
    [self.inputMethodDelegate mqttAndPrvtRecvTVCmdInputMsg:inputMsg];
}

#pragma mark 截屏

- (void)mqttRecvTVCmdScreenShotData:(NSData *)screenShotData {
    self.cutTVShowImgData = screenShotData;
    self.cutTVShowImg = [UIImage imageWithData:screenShotData];
    [self.screenShotDelegate MqttAndPrvtRecvTVCmdScreenShotData:screenShotData];
}

- (void)prvtRecvTVCmdScreenShotData:(NSData *)screenShotData {
    self.cutTVShowImgData = screenShotData;
    self.cutTVShowImg = [UIImage imageWithData:screenShotData];
    [self.screenShotDelegate MqttAndPrvtRecvTVCmdScreenShotData:screenShotData];
}

#pragma mark 语音助手

- (void)mqttRecvTVCmdVoiceStartControl:(BOOL)startResult {
    if (startResult) {
        [HSToast showAtDefWithText:NSLocalizedString(@"pleaseSay", nil)];
        if (self.pVoiceAssistant == nil) {
        self.pVoiceAssistant = [[VoiceAssistant alloc] init];
        }
        [self.pVoiceAssistant startRecorder];//开启手机录音
    } else {
        [self.pVoiceAssistant stopRecorder];
    }
}

- (void)prvtRecvTVCmdVoiceStartControl:(BOOL)startResult {
    if (startResult) {
        [HSToast showAtDefWithText:NSLocalizedString(@"pleaseSay", nil)];
        if (self.pVoiceAssistant == nil) {
            self.pVoiceAssistant = [[VoiceAssistant alloc] init];
        }
        [self.pVoiceAssistant startRecorder];//开启手机录音
    } else {
        [self.pVoiceAssistant stopRecorder];
    }
}

- (void)mqttRecvTVCmdVoiceStartRecognition:(BOOL)recognitionResult {
    if (recognitionResult) {
        [HSToast showAtDefWithText:NSLocalizedString(@"recognizing", nil)];
        [self.pVoiceAssistant stopRecorder];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.mqttObj cmdMqttSendkeyStr:@(CLOSE_VOICE_CONTROL) toTopic:MQTTAppTopicCmdVoice];
        });
        [self.mqttAndPrvtVoiceAssistantDelegate mqttAndPrvtVoiceAssistCallback:NO];
    }
}

- (void)prvtRecvTVCmdVoiceStartRecognition:(BOOL)recognitionResult {
    if (recognitionResult) {
        [HSToast showAtDefWithText:NSLocalizedString(@"recognizing", nil)];
        [self.pVoiceAssistant stopRecorder];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.privaObj sendCtrlKey:CLOSE_VOICE_CONTROL type:MSG_TYPE_VOICE];
        });
        [self.mqttAndPrvtVoiceAssistantDelegate mqttAndPrvtVoiceAssistCallback:NO];
    }
}

- (void)mqttRecvTVCmdVoiceCloseControl:(BOOL)closeResult {
    if (closeResult) {
        [self.pVoiceAssistant stopRecorder];
        [self.mqttAndPrvtVoiceAssistantDelegate mqttAndPrvtVoiceAssistCallback:NO];
    }
}

- (void)prvtRecvTVCmdVoiceCloseControl:(BOOL)closeResult {
    if (closeResult) {
        [self.pVoiceAssistant stopRecorder];
        [self.mqttAndPrvtVoiceAssistantDelegate mqttAndPrvtVoiceAssistCallback:NO];
    }
}

#pragma mark - 电视主动截屏

- (void)mqttRecvTVCmdTVSendScreenShot:(NSData *)screenShotData imageName:(NSString *)imageName {
    [self.mqttAndPrvtRecvTVCmdTVSendScreenShotDelegate mqttAndPrvtRecvTVCmdTVSendScreenShot:screenShotData imageName:imageName];
    
}

#pragma mark - 连接丢失

- (void)mqttLostConnection:(NSUInteger)code {
    NSLog(@"__mqtt连接丢失");
    [self.mqttAndPrvtConnectionLostDelegate mqttAndPrvtConnectionLost];
}

- (void)prvtConnectionLost {
    NSLog(@"__私有协议连接丢失");
    [self.mqttAndPrvtConnectionLostDelegate mqttAndPrvtConnectionLost];
}


@end
