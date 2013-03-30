//
//  SDStstusView.m
//  Sunny Dolls
//
//  Created by nangua on 13-3-30.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import "SDStstusView.h"
#import "SDAppDelegate.h"

@implementation SDStstusView

- (void)mouseUp:(NSEvent *)theEvent
{
    SDAppDelegate *delegate = [NSApplication sharedApplication].delegate;
    [delegate say];
}

- (void)rightMouseUp:(NSEvent *)theEvent
{
    SDAppDelegate *delegate = [NSApplication sharedApplication].delegate;
    [delegate popMenu];
}

@end
