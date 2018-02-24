//
//  VoiceRecorder.m
//  HsShare3.5
//
//  Created by Lisa Xun on 15/9/7.
//  Copyright (c) 2015年 com.hisense. All rights reserved.
//

#import "VoiceRecorder.h"
#import "GlobalUtils.h"
#define DEF_SAMPLE_RATE         16000
#define DEF_FRAME_SIZE          4800
#define kBufferDurationSeconds  0.15

@interface VoiceRecorder () {
    NSTimer *timer;
}

@end

@implementation VoiceRecorder

int ComputeRecordBufferSize(const AudioStreamBasicDescription *format, float seconds)
{
    int packets, frames, bytes = 0;
    @try {
        frames = (int)ceil(seconds * format->mSampleRate);
        
        if (format->mBytesPerFrame > 0)
            bytes = frames * format->mBytesPerFrame;
        else {
            UInt32 maxPacketSize;
            if (format->mBytesPerPacket > 0)
                maxPacketSize = format->mBytesPerPacket;	// constant packet size
            else {
//                UInt32 propertySize = sizeof(maxPacketSize);
//                XThrowIfError(AudioQueueGetProperty(mQueue, kAudioQueueProperty_MaximumOutputPacketSize, &maxPacketSize,
//                                                    &propertySize), "couldn't get queue's maximum output packet size");
            }
            if (format->mFramesPerPacket > 0)
                packets = frames / format->mFramesPerPacket;
            else
                packets = frames;	// worst-case scenario: 1 frame in a packet
            if (packets == 0)		// sanity check
                packets = 1;
            bytes = packets * maxPacketSize;
        }
    } @catch (NSException *e) {
        return 0;
    }
    HSLog(@"");
    return bytes;
}

void aqInputCallback (void *inRecorder, AudioQueueRef inAudioQueueRef, AudioQueueBufferRef inAudioQueueBufRef, const AudioTimeStamp *inStartTime, unsigned long inPacketNum, const AudioStreamPacketDescription *inPacketDes){
    VoiceRecorder *thisRecorder = (__bridge VoiceRecorder *)inRecorder;
    if (thisRecorder != nil) {
        if (inPacketNum > 0) {
            [thisRecorder processAudioBuffer:inAudioQueueBufRef queue:inAudioQueueRef];
        }
        
        if (thisRecorder.aqCb.run) {
            AudioQueueEnqueueBuffer(thisRecorder.aqCb.audioQueue, inAudioQueueBufRef, 0, NULL);
        }
    }
}

- (VoiceRecorder *)init {
    self = [super init];
    if (self) {
        _aqCb.audioStreamBasicDes.mSampleRate = DEF_SAMPLE_RATE;
        _aqCb.audioStreamBasicDes.mFormatID = kAudioFormatLinearPCM;
        _aqCb.audioStreamBasicDes.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        _aqCb.audioStreamBasicDes.mFramesPerPacket = 1;
        _aqCb.audioStreamBasicDes.mChannelsPerFrame = 1;
        _aqCb.audioStreamBasicDes.mBitsPerChannel = 16;
        _aqCb.audioStreamBasicDes.mBytesPerFrame = 2;
        _aqCb.audioStreamBasicDes.mBytesPerPacket = 2;
        
//        _aqCb.frameSize = ComputeRecordBufferSize(&_aqCb.audioStreamBasicDes, kBufferDurationSeconds);
        _aqCb.frameSize = DEF_FRAME_SIZE;
        
        AudioQueueNewInput(&_aqCb.audioStreamBasicDes, (AudioQueueInputCallback)aqInputCallback, (__bridge void * _Nullable)(self), NULL, kCFRunLoopDefaultMode, 0, &_aqCb.audioQueue);
        
        for (int i=0; i<BUF_NUM; i++) {
            AudioQueueAllocateBuffer(_aqCb.audioQueue, (UInt32)_aqCb.frameSize, &_aqCb.audioQueueBuf[i]);
            AudioQueueEnqueueBuffer(_aqCb.audioQueue, _aqCb.audioQueueBuf[i], 0, NULL);
        }
        
        _aqCb.run = 1;
    }
    return self;
}

- (void) dealloc
{
    timer = nil;
    
    AudioQueueStop(_aqCb.audioQueue, false);
    _aqCb.run = 0;
    
    @try
    {
        AudioQueueDispose(_aqCb.audioQueue, false);
    }
    @catch (NSException *exception)
    {
        HSLog(@"AudioQueueDispose throw exception %@", exception.description);
    }
    @finally
    {
        
    }
    
    _aqCb.audioQueue = nil;
}

- (void)start {
    OSStatus rest = AudioQueueStart(_aqCb.audioQueue, NULL);
    HSLog(@"AudioQueueStart result is %d", (int)rest);
    UInt32 on = 1;
    AudioQueueSetProperty(_aqCb.audioQueue, kAudioQueueProperty_EnableLevelMetering, &on, sizeof(on));
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updatePower) userInfo:nil repeats:YES];
}

- (void)updatePower {
    UInt32 ioDataSize = sizeof(AudioQueueLevelMeterState);
    AudioQueueLevelMeterState *levelMeterState = (AudioQueueLevelMeterState *)calloc(ioDataSize, 1);
    AudioQueueGetProperty(_aqCb.audioQueue, kAudioQueueProperty_CurrentLevelMeter, levelMeterState, &ioDataSize);
    free(levelMeterState);
    levelMeterState = NULL;
}

- (void)stop {
    [timer invalidate];
    timer = nil;
    
    @try {
        AudioQueueStop(_aqCb.audioQueue, false);
    }
    @catch (NSException *exception) {
        HSLog(@"AudioQueueStop throw exception %@",exception.description);
    }
    @finally {
        
    }
    
    _aqCb.audioQueue = nil;
}

- (void)processAudioBuffer:(AudioQueueBufferRef)bufRef queue:(AudioQueueRef)queueRef {
    @autoreleasepool {
        [_recorderDelegate processAudioData:bufRef->mAudioData size:bufRef->mAudioDataByteSize];
    }
}

@end
