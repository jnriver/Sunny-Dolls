//
//  SDVoiceGenerator.m
//  Sunny Dolls
//
//  Created by nangua on 13-3-29.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import "SDVoiceGenerator.h"

@implementation SDVoiceGenerator

- (id)init
{
    self = [super init];
    if (self) {
        self.audioPlayer = [[AVAudioPlayer alloc] init];
    }
    return self;
}

- (void)sayTimeAndWeather:(NSString *)weatherCondition
{
    // init dateComponents
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
    
    // get ampm voice
    NSString *ampmFileName = [NSString stringWithFormat:@"ampm_%ld_cn", [self getAmpmTypeByHour:dateComponents.hour]];
    NSURL *ampmURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:ampmFileName ofType:@"caf"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)ampmURL,&ampmVoice);
    
    AudioServicesPlaySystemSound(ampmVoice);
}

- (NSInteger)getAmpmTypeByHour:(NSInteger)hour
{
    // 凌晨
    if (hour >= 0 && hour < 6) {
        return 0;
    }
    // 早上
    if (hour >= 6 && hour < 9) {
        return 1;
    }
    // 上午
    if (hour >= 9 && hour < 12) {
        return 2;
    }
    // 中午
    if (hour >= 12 && hour < 13) {
        return 3;
    }
    // 下午
    if (hour >= 13 && hour < 17) {
        return 4;
    }
    // 傍晚
    if (hour >= 17 && hour < 18) {
        return 5;
    }
    // 晚上
    if (hour >= 18 && hour < 11) {
        return 6;
    }
    // 深夜
    if (hour >= 11) {
        return 7;
    }
    
    return 0;
}

@end
