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

@interface SDAppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) SDWeatherGetter *weatherGetter;
@property (strong, nonatomic) SDVoiceGenerator *voiceGenerator;

@property (strong, nonatomic) IBOutlet NSStatusItem *statusItem;
@property (strong, nonatomic) IBOutlet NSMenu *statusMenu;

@end
