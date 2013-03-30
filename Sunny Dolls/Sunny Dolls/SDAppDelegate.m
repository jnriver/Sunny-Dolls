//
//  SDAppDelegate.m
//  Sunny Dolls
//
//  Created by nangua on 13-3-29.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import "SDAppDelegate.h"

@implementation SDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self initUserDefaults];
    self.weatherGetter = [[SDWeatherGetter alloc] init];
    self.voiceGenerator = [[SDVoiceGenerator alloc] init];
    [self initStatusMenu];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    
    self.statusView = [[SDStstusView alloc] init];
    NSImage *img = [NSImage imageNamed:@"Cloud-Download"];
    [img setSize:NSMakeSize(32, 32)];
    [self.statusView setImage:img];
    [self.statusItem setView:self.statusView];
    
    [self.weatherGetter getWeather];
}

- (void)initStatusMenu
{
    self.statusMenu = [[NSMenu alloc] init];
    NSMenuItem *menuItem;
    
    //    menuItem = [NSMenuItem separatorItem];
    //    [self.statusMenu addItem:menuItem];
    menuItem = [[NSMenuItem alloc] initWithTitle:@"Quit Sunny Dolls" action:@selector(terminate:) keyEquivalent:@""];
    [menuItem setTarget:NSApp];
    [self.statusMenu addItem:menuItem];
}

- (void)initUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{
                   kSDLocation:@"zhuhai"
    }];
}

#pragma mark - status actions

- (void)say
{
    [self.voiceGenerator sayTimeAndWeather:self.weather.condition];
}

- (void)popMenu
{
    [self.statusItem popUpStatusItemMenu:self.statusMenu];
}

@end
