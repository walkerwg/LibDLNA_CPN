//
//  VoiceAssistant.m
//  HsShare3.5
//
//  Created by Lisa Xun on 15/9/8.
//  Copyright (c) 2015年 com.hisense. All rights reserved.
//

#import "VoiceAssistant.h"

#import "DLNAObject.h"
#import "VoiceRecorder.h"
#import "MqttAndPrivateComu.h"

#import <sys/socket.h>
#import <netdb.h>
#import "GlobalUtils.h"
#import "HSToast.h"

@interface VoiceAssistant () <RecorderDelegate, VoiceConnectResultDelegate> {
    NSOperationQueue *sendQueue;
    int socket_fd;
    
    VoiceRecorder *pVoiceRecorder;
}

@property (nonatomic, strong) DLNAObject *dlnaObj;
@property (nonatomic, strong) MqttAndPrivateComu *mqttAndPrivateComu;

@end

@implementation VoiceAssistant

- (VoiceAssistant *)init {
    self = [super init];
    if (self) {
        sendQueue = [[NSOperationQueue alloc] init];
        sendQueue.maxConcurrentOperationCount = 1;
        
        self.dlnaObj = [DLNAObject shareDlnaObj];
        [self initVoiceComuOjb];
    }
    return self;
}

- (void)initVoiceComuOjb {
    self.mqttAndPrivateComu = [MqttAndPrivateComu shareMqttAndPrivateComu];
    self.mqttAndPrivateComu.voiceConnectResultDelegate = self;
}

- (void)startRecorder {
    switch (self.mqttAndPrivateComu.devTransportProtocol) {
        case TransportProtocolPrivateObject: {
            [self PrvtStartRecorder];
        }
            break;
            
        case TransportProtocolMQTT: {
            [self mqttStartRecorder];
        }
            break;
    }
}

- (BOOL)PrvtStartRecorder {
    if (self.dlnaObj.curDevIndex != -1 && self.dlnaObj.curDevIndex != -2) {
        socket_fd = socket(AF_INET, SOCK_STREAM, 0);
        if (socket_fd < 0) {
            HSLog(@"create socket failed");
            return NO;
        }
        
        NSString *curIpStr = [self.dlnaObj.devArr objectAtIndex:self.dlnaObj.curDevIndex][kIp];
        struct hostent *remoteHostent = gethostbyname(curIpStr.UTF8String);
        if (remoteHostent == NULL) {
            HSLog(@"create host failed");
            close(socket_fd);
            return NO;
        }
        
        struct in_addr *remoteInAddr = (struct in_addr *)remoteHostent->h_addr_list[0];
        
        //set socket parameters
        struct sockaddr_in socketParam;
        socketParam.sin_family = AF_INET;
        socketParam.sin_addr = *remoteInAddr;
        HSLog(@"voice assistant port is %d", self.dlnaObj.voicePort);
        socketParam.sin_port = htons(self.dlnaObj.voicePort);
        
        int socketRes = connect(socket_fd, (struct sockaddr *)&socketParam, sizeof(socketParam));
        if (socketRes < 0) {
            HSLog(@"connect socket failed");
            close(socket_fd);
            return NO;
        }
        HSLog(@"connect socket OK");
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRecorder) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        pVoiceRecorder = [[VoiceRecorder alloc] init];
        pVoiceRecorder.recorderDelegate = self;
        [pVoiceRecorder start];
        
        return YES;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HSToast showAtDefWithText:NSLocalizedString(@"noConnectedDev", nil)];
        });
        return NO;
    }
}

- (void)mqttStartRecorder {
    if (self.dlnaObj.curDevIndex != -1 && self.dlnaObj.curDevIndex != -2) {
        //建立新的mqtt通信连接通道
        [self.mqttAndPrivateComu voiceClientConnect];
        //新的mqtt通信连接通道连接成功与否都在voiceConnectResultDelegate函数中处理
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HSToast showAtDefWithText:NSLocalizedString(@"noConnectedDev", nil)];
        });
    }
}

#pragma mark - VoiceConnectResultDelegate

- (void)voiceClientConnect:(TransportProtocol)transport Result:(BOOL)result {
    switch (transport) {
        case TransportProtocolPrivateObject: {
            
        }
            break;
            
        case TransportProtocolMQTT: {
            if (result) {//连接成功
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mqttStopRecorder) name:UIApplicationDidEnterBackgroundNotification object:nil];
                
                pVoiceRecorder = [[VoiceRecorder alloc] init];
                pVoiceRecorder.recorderDelegate = self;
                [pVoiceRecorder start];
                [self.mqttAndPrivateComu.mqttAndPrvtVoiceAssistantDelegate mqttAndPrvtVoiceAssistCallback:YES];
            } else {//连接失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HSToast showAtDefWithText:NSLocalizedString(@"noConnectedDev", nil)];
                });
            }
        }
            break;
    }
}

/**
 停止手机录音
 */
- (void)stopRecorder {
    switch (self.mqttAndPrivateComu.devTransportProtocol) {
        case TransportProtocolPrivateObject: {
            [self prvtStopRecorder];
        }
            break;
            
        case TransportProtocolMQTT: {
            [self mqttStopRecorder];
        }
            break;
    }
}


- (void)mqttStopRecorder {
    if (pVoiceRecorder) {
        [pVoiceRecorder stop];
        pVoiceRecorder.recorderDelegate = nil;
        [self.mqttAndPrivateComu voiceClientDisconnect];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

- (void)prvtStopRecorder {
    if (pVoiceRecorder) {
        [pVoiceRecorder stop];
        pVoiceRecorder.recorderDelegate = nil;
        close(socket_fd);
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

#pragma RecorderDelegate
- (void)processAudioData:(SInt16 *)inData size:(NSUInteger)inSize {
    switch (self.mqttAndPrivateComu.devTransportProtocol) {
        case TransportProtocolPrivateObject: {
            int optval;
            socklen_t optlen = sizeof(int);
            getsockopt(socket_fd, SOL_SOCKET, SO_ERROR,(char*) &optval, &optlen);
            if (optval == 0) {
                NSData *data = [NSData dataWithBytes:inData length:inSize];
                NSInvocationOperation *sendOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(putData:) object:data];
                [sendQueue addOperation:sendOperation];
            } else {
                [self stopRecorder];
            }
        }
            break;
            
        case TransportProtocolMQTT: {
            NSData *autdioData = [NSData dataWithBytes:inData length:inSize];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self.mqttAndPrivateComu sendVoiceData:autdioData];
            });
        }
            break;
    }
    
}

- (void)putData:(NSData *)inData {
    //HSLog(@"begin to write");
    signal(SIGPIPE, SIG_IGN);
    ssize_t res = write(socket_fd, (char *)inData.bytes, inData.length);
    //HSLog(@"write to socket res is %zd", res);
    if (res < 0) {
        [self stopRecorder];
    }
}


@end
