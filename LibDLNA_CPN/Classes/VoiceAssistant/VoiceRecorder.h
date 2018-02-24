//
//  VoiceRecorder.h
//  HsShare3.5
//
//  Created by Lisa Xun on 15/9/7.
//  Copyright (c) 2015年 com.hisense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioQueue.h>
#import <CoreAudio/CoreAudioTypes.h>

#define BUF_NUM     4

typedef struct AQCallbackStruct {
    AudioStreamBasicDescription audioStreamBasicDes;
    AudioQueueRef audioQueue;
    AudioQueueBufferRef audioQueueBuf[BUF_NUM];
    
    unsigned long frameSize;
    int run;
} AQCallbackStruct;

@protocol RecorderDelegate <NSObject>
@optional
- (void)processAudioData:(SInt16 *)inData size:(NSUInteger)inSize;
@end

@interface VoiceRecorder : NSObject

@property (assign, nonatomic) AQCallbackStruct aqCb;
@property (assign, nonatomic) id<RecorderDelegate> recorderDelegate;

- (void)start;
- (void)stop;

@end
