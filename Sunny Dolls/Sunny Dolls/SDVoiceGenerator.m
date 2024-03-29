//
//  SDVoiceGenerator.m
//  Sunny Dolls
//
//  Created by nangua on 13-3-29.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import "SDVoiceGenerator.h"
#import "SDAppDelegate.h"

@implementation SDVoiceGenerator

- (id)init
{
    self = [super init];
    if (self) {
        voiceArray = [[NSMutableArray alloc] init];
        dataArray = [[NSMutableArray alloc] init];
        self.saying = NO;
    }
    return self;
}

- (void)sayTimeAndWeather:(SDWeather *)weather;
{
    if (self.isSaying) {
        self.canceled = YES;
        return;
    }
    self.canceled = NO;
    
    self.saying = YES;
    [voiceArray removeAllObjects];
    
    // init dateComponents
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
    
    // get ampm voice
    SystemSoundID ampmVoice;
    NSString *ampmFileName = [NSString stringWithFormat:@"ampm_%ld_cn", [self getAmpmTypeByHour:dateComponents.hour]];
    NSURL *ampmURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:ampmFileName ofType:@"caf"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)ampmURL,&ampmVoice);
    [voiceArray addObject:[NSNumber numberWithUnsignedInt:ampmVoice]];
    
    // get hour voice
    SystemSoundID hourVoice;
    NSInteger hour = dateComponents.hour;
    if (hour > 12) {
        hour -= 12;
    }
    if (hour == 0) {
        hour = 12;
    }
    NSString *hourFileName = [NSString stringWithFormat:@"hour_%@_cn", [NSString stringWithFormat:@"%02ld", hour]];
    NSURL *hourURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:hourFileName ofType:@"caf"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)hourURL,&hourVoice);
    [voiceArray addObject:[NSNumber numberWithUnsignedInt:hourVoice]];
    
    // get hour suffix voice
    SystemSoundID hourSuffixVoice;
    NSString *hourSuffixFileName = @"oclock";
    NSURL *hourSuffixURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:hourSuffixFileName ofType:@"caf"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)hourSuffixURL,&hourSuffixVoice);
    [voiceArray addObject:[NSNumber numberWithUnsignedInt:hourSuffixVoice]];
    
    // get min voice
    SystemSoundID minVoice;
    NSString *minFileName = [NSString stringWithFormat:@"min_%@_cn", [NSString stringWithFormat:@"%02ld", dateComponents.minute]];
    NSURL *minURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:minFileName ofType:@"caf"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)minURL,&minVoice);
    [voiceArray addObject:[NSNumber numberWithUnsignedInt:minVoice]];
    
    // get day voice
    SystemSoundID dayVoice;
    NSString *dayFileName = [NSString stringWithFormat:@"week_%ld_cn", dateComponents.weekday - 1];
    NSURL *dayURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:dayFileName ofType:@"caf"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)dayURL,&dayVoice);
    [voiceArray addObject:[NSNumber numberWithUnsignedInt:dayVoice]];
    
    // get weather voice
    SystemSoundID weatherVoice;
    NSString *weatherFileName = [NSString stringWithFormat:@"weather_%@_cn", weather ? weather.conditionVoice : @""];
    NSString *weatherPath = [[NSBundle mainBundle] pathForResource:weatherFileName ofType:@"caf"];
    if (weatherPath) {
        NSURL *weatherURL = [NSURL fileURLWithPath:weatherPath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)weatherURL,&weatherVoice);
        [voiceArray addObject:[NSNumber numberWithUnsignedInt:weatherVoice]];
    }
    
    [self playVoiceArray];
}

- (void)playVoiceArray
{
    SDAppDelegate *delegate = [NSApplication sharedApplication].delegate;
    if ([voiceArray count] <= 0) {
        [delegate finishSay];
        self.saying = NO;
        return;
    }
    
    SystemSoundID sound = [[voiceArray objectAtIndex:0] unsignedIntValue];
    DLog(@"sound:%d",sound);
    [voiceArray removeObjectAtIndex:0];
    
    [dataArray removeAllObjects];
    [dataArray addObject:self];
    [dataArray addObject:@"playVoiceArray"];
    
    if (!self.canceled) {
        AudioServicesAddSystemSoundCompletion(sound, nil, nil, playSoundFinished, (__bridge void *)(dataArray));
        AudioServicesPlaySystemSound(sound);
    } else {
        [delegate finishSay];
        self.saying = NO;
        AudioServicesRemoveSystemSoundCompletion(sound);
        AudioServicesDisposeSystemSoundID(sound);
    }
}

void playSoundFinished(SystemSoundID sound, void *data)
{
    NSArray *dataArray = (__bridge NSArray *)data;
    AudioServicesRemoveSystemSoundCompletion(sound);
    AudioServicesDisposeSystemSoundID(sound);
    
    id obj = [dataArray objectAtIndex:0];
    SEL method = NSSelectorFromString([dataArray objectAtIndex:1]);

    [obj performSelector:method];
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
    if (hour >= 18 && hour < 23) {
        return 6;
    }
    // 深夜
    if (hour >= 23) {
        return 7;
    }
    
    return 0;
}

@end
