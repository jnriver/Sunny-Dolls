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
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [self.statusItem setImage:[NSImage imageNamed:@"clear"]];
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
