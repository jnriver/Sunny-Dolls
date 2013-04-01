//
//  SDAppDelegate.h
//  Sunny Dolls
//
//  Created by nangua on 13-3-29.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SDWeatherGetter.h"
#import "SDVoiceGenerator.h"
#import "SDWeather.h"
#import "SDStstusView.h"

@interface SDAppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) SDWeatherGetter *weatherGetter;
@property (strong, nonatomic) SDVoiceGenerator *voiceGenerator;

@property (strong, nonatomic) NSMutableArray *weatherBox;

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) SDStstusView *statusView;
@property (strong, nonatomic) NSMenu *statusMenu;

- (void)say;
- (void)popMenu;

@end
