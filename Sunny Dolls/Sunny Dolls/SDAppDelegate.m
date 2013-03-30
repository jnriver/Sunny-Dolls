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
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    
    NSImage *img = [NSImage imageNamed:@"sunny"];
    [img setSize:NSMakeSize(16, 16)];
    [self.statusItem setImage:img];
    [self.statusItem setTarget:self];
    [self.statusItem setAction:@selector(say)];
}

- (void)say
{
    [self.voiceGenerator sayTimeAndWeather:self.weather.condition];
}

- (void)initStatusMenu
{
    self.statusMenu = [[NSMenu alloc] init];
    NSMenuItem *menuItem;
    
    menuItem = [NSMenuItem separatorItem];
    [self.statusMenu addItem:menuItem];
    menuItem = [[NSMenuItem alloc] initWithTitle:@"Quit Sunny Dolls" action:@selector(terminate:) keyEquivalent:@""];
    [menuItem setTarget:NSApp];
    [self.statusMenu addItem:menuItem];
}


@end
