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
    self.weatherGetter = [[SDWeatherGetter alloc] init];
    self.voiceGenerator = [[SDVoiceGenerator alloc] init];
    [self initStatusMenu];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    
    self.statusView = [[SDStstusView alloc] init];
    NSImage *img = [NSImage imageNamed:@"sunny"];
    [img setSize:NSMakeSize(16, 16)];
    [self.statusView setImage:img];
    [self.statusItem setView:self.statusView];
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
