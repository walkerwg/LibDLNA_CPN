//
//  OpenALPlayer.m
//  HsShare3.5
//
//  Created by Lisa Xun on 15/9/6.
//  Copyright (c) 2015年 com.hisense. All rights reserved.
//

#import "OpenALPlayer.h"
#import <OpenAL/alc.h>
#import <OpenAL/al.h>

#ifdef DEBUG
#   define HSLog(fmt, ...) NSLog((@"[HS-HCI] %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define HSLog(...)
#endif
@interface OpenALPlayer () {
    ALCdevice *alcDevice;      //play device
    ALCcontext *alcContext;    //play environment
    ALuint sourceId;           //play sound source id
    NSCondition *playerLock;
}

@end

@implementation OpenALPlayer

- (BOOL)initPlayer {
    if (alcDevice == nil) {
        alcDevice = alcOpenDevice(NULL);
    }
    if (alcDevice == nil) {
        return NO;
    }
    
    if (alcContext == nil) {
        alcContext = alcCreateContext(alcDevice, NULL);
        alcMakeContextCurrent(alcContext);
    }
    if (alcContext == nil) {
        return NO;
    }
    
    alGenSources(1, &sourceId);//init sound source id
    alSourcei(sourceId, AL_LOOPING, AL_FALSE);//set loop mode--false
    alSourcef(sourceId, AL_SOURCE_TYPE, AL_STREAMING);//set source type--pcm stream
    alSourcef(sourceId, AL_GAIN, 1.0);//set source volume--1.0(max)
    //alDopplerVelocity(1.0);//cope with Doppler effect
    //alDopplerFactor(1.0);//same as last
    alSpeedOfSound(1.0);//set play speed--1.0(max)
    
//    ALenum error;
//    if ((error = alGetError()) != AL_NO_ERROR) {
//        return NO;
//    }
    
    if (playerLock == nil) {
        playerLock = [[NSCondition alloc] init];
    }
    if (playerLock == nil) {
        return NO;
    }
    
    return YES;
}

//put the PCM date into buffer then get it to play
- (BOOL)openPlayerWithBuff:(char *)buff length:(UInt32)length sampleRate:(int)sampleRate {
    [playerLock lock];
    
    ALenum error = AL_NO_ERROR;
    if ((error = alGetError()) != AL_NO_ERROR) {
        [playerLock unlock];
        return NO;
    }
    
    if (buff == NULL) {
        [playerLock unlock];
        return NO;
    }
    
    [self updateQueueBufferAndPlay]; //clean buffer and play
    if ((error = alGetError()) != AL_NO_ERROR) {
        [playerLock unlock];
        return NO;
    }
    
    //create a buffer and initial it to save audio data
    ALuint bufferId = 0;
    alGenBuffers(1, &bufferId);
    if ((error = alGetError()) != AL_NO_ERROR) {
        HSLog(@"create buffer failed");
        [playerLock unlock];
        return NO;
    }
    
    NSData *data = [NSData dataWithBytes:buff length:length];
    alBufferData(bufferId, AL_FORMAT_STEREO16, (char *)[data bytes], (ALsizei)[data length], sampleRate);//put data into buffer(AL_FORMAT_MONO16 double sound track, track type is AL_FORMAT_MONO8, AL_FORMAT_MONO16, AL_FORMAT_STETERO8, AL_FORMAT_STETERO16)
    if ((error = alGetError()) != AL_NO_ERROR) {
        HSLog(@"initial buffer failed");
        [playerLock unlock];
        return NO;
    }
    
    alSourceQueueBuffers(sourceId, 1, &bufferId);
    if ((error = alGetError()) != AL_NO_ERROR) {
        HSLog(@"add buffer to queue failed");
        [playerLock unlock];
        return NO;
    }
    
    if ((error = alGetError()) != AL_NO_ERROR) {
        HSLog(@"play buffer failed");
        alDeleteBuffers(1, &bufferId);
        [playerLock unlock];
        return NO;
    }
    
    [playerLock unlock];
    return YES;
}

- (void)updateQueueBufferAndPlay {
    ALint state;
    alGetSourcei(sourceId, AL_SOURCE_STATE, &state);
    if (state != AL_PLAYING) {
        alSourcePlay(sourceId);
    } else {
        int processId, queueId;
        alGetSourcei(sourceId, AL_BUFFERS_PROCESSED, &processId);
        alGetSourcei(sourceId, AL_BUFFERS_QUEUED, &queueId);
        
//        HSLog(@"AL_BUFFERS_PROCESSED is %d", processId);
//        HSLog(@"AL_BUFFERS_QUEUED is %d", queueId);
        
        while (processId--) {
            ALuint bufferId;
            alSourceUnqueueBuffers(sourceId, 1, &bufferId);
            alDeleteBuffers(1, &bufferId);
        }
    }
}

- (void)stopSound {
    ALint state;
    alGetSourcei(sourceId, AL_SOURCE_STATE, &state);
    if (state != AL_STOPPED) {
        alSourceStop(sourceId);
    }
    
    alDeleteSources(1, &sourceId);
    
    if (alcContext != nil) {
        alcDestroyContext(alcContext);
        alcContext = nil;
    }
    
    if (alcDevice != nil) {
        alcCloseDevice(alcDevice);
        alcDevice = nil;
    }
}

@end
