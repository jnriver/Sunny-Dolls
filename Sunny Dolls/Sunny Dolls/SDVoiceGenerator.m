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

- (void)sayTimeAndWeather:(NSString *)weather
{
    // init dateComponents
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
    
    // get ampm voice
    NSURL *ampmURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ampm_0_cn" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)ampmURL,&ampmVoice);
    
    AudioServicesPlaySystemSound(ampmVoice);
}

@end
