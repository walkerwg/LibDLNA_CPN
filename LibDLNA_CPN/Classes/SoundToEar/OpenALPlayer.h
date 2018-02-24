//
//  OpenALPlayer.h
//  HsShare3.5
//
//  Created by Lisa Xun on 15/9/6.
//  Copyright (c) 2015年 com.hisense. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenALPlayer : NSObject

- (BOOL)initPlayer;
- (BOOL)openPlayerWithBuff:(char *)buff length:(UInt32)length sampleRate:(int)sampleRate;
- (void)stopSound;

@end
