//
//  SDVoiceGenerator.h
//  Sunny Dolls
//
//  Created by nangua on 13-3-29.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SDWeather.h"

@interface SDVoiceGenerator : NSObject
{
    NSMutableArray *voiceArray;
    NSMutableArray *dataArray;
}

@property (getter = isSaying, nonatomic) BOOL saying;
@property (getter = isCanceled, nonatomic) BOOL canceled;

- (void)sayTimeAndWeather:(SDWeather *)weather;


@end
