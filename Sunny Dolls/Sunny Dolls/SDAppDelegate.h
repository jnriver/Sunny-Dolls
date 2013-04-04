//
//  SDAppDelegate.h
//  Sunny Dolls
//
//  Created by nangua on 13-3-29.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SDWeatherLoader.h"
#import "SDVoiceGenerator.h"
#import "SDWeather.h"
#import "SDStstusView.h"

@interface SDAppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) SDWeatherLoader *weatherLoader;
@property (strong, nonatomic) SDVoiceGenerator *voiceGenerator;

@property (strong, nonatomic) NSMutableArray *weatherBox;

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) SDStstusView *statusView;
@property (strong, nonatomic) NSMenu *statusMenu;

@property (strong, nonatomic) SDWeather *lastWeather;
@property (strong, nonatomic) SDWeather *todayWeather;

@property (strong, nonatomic) NSTimer *checkTimer;

- (void)say;
- (void)popMenu;

- (void)finishSay;

- (void)receiveWeatherBox;
- (void)receiveWeatherError;

@end
