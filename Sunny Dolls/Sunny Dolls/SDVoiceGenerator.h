//
//  SDVoiceGenerator.h
//  Sunny Dolls
//
//  Created by nangua on 13-3-29.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SDVoiceGenerator : NSObject
{
    SystemSoundID ampmVoice;
}
@property (strong, nonatomic)AVAudioPlayer *audioPlayer;

- (void)sayTimeAndWeather:(NSString *)weather;


@end
