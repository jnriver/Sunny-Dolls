//
//  SDAppDelegate.m
//  Sunny Dolls
//
//  Created by nangua on 13-3-29.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import "SDAppDelegate.h"
#import "SDWeather.h"

NSDateFormatter *dateFormatter;

@implementation SDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self initUserDefaults];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    self.weatherBox = [[NSMutableArray alloc] init];
    self.weatherLoader = [[SDWeatherLoader alloc] init];
    self.voiceGenerator = [[SDVoiceGenerator alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.lastWeather = [[SDWeather alloc] initWithDictionary:[defaults valueForKey:kSDLastWeather]];
    
    [self initStatusItem];
    [self initStatusMenu];
    
    self.checkTimer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(check) userInfo:nil repeats:YES];
    
    [self.weatherLoader loadWeathers];
    [[NSRunLoop mainRunLoop] addTimer:self.checkTimer forMode:NSRunLoopCommonModes];
}

- (void)initStatusItem
{    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    
    self.statusView = [[SDStstusView alloc] init];
    NSImage *img = [NSImage imageNamed:@"Cloud-Download"];
    [img setSize:NSMakeSize(32, 32)];
    [self.statusView setImage:img];
    [self.statusItem setView:self.statusView];
}

- (void)initStatusMenu
{
    self.statusMenu = [[NSMenu alloc] init];
    NSMenuItem *menuItem;
    
    if (self.lastWeather) {
        menuItem = [self getWeatherMenuItemByWeather:self.lastWeather];
        [self.statusMenu addItem:menuItem];
        menuItem = [NSMenuItem separatorItem];
        [self.statusMenu addItem:menuItem];
    }
    
    menuItem = [[NSMenuItem alloc] initWithTitle:@"Sync" action:@selector(loadWeather) keyEquivalent:@""];
    [menuItem setTarget:self];
    [self.statusMenu addItem:menuItem];
    menuItem = [NSMenuItem separatorItem];
    [self.statusMenu addItem:menuItem];
    menuItem = [[NSMenuItem alloc] initWithTitle:@"Quit Sunny Dolls" action:@selector(terminate:) keyEquivalent:@""];
    [menuItem setTarget:NSApp];
    [self.statusMenu addItem:menuItem];
}

- (void)initUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{
                   kSDLocation:@"zhuhai",
                   kSDLastDate:@"19000101",
                kSDLastWeather:@{}
    }];
}

#pragma mark - private method

- (NSMenuItem *)getWeatherMenuItemByWeather:(SDWeather *)weather
{
    NSString *menuItemString = [self getWeatherMenuStringByWeather:weather];
    NSImage *menuItemImage = [NSImage imageNamed:weather.condition];
    NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:menuItemString action:nil keyEquivalent:@""];
    [menuItem setImage:menuItemImage];
    [menuItem setEnabled:NO];
    return menuItem;
}

- (NSString *)getWeatherMenuStringByWeather:(SDWeather *)weather
{
    return [NSString stringWithFormat:@"%@%@ %@ %ld˚C~%ld˚C %ld%%", weather.dateDescription, weather.dayDescription, weather.conditionDescription, weather.lowCelsius, weather.highCelsius, weather.humidity];
}

#pragma mark - status actions

- (void)check
{
    NSString *todayString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *lastString = [[NSUserDefaults standardUserDefaults] valueForKey:kSDLastDate];
    if (![todayString isEqualToString:lastString] && !self.weatherLoader.isLoading) {
        [self loadWeather];
    }
    if (!self.lastWeather && [self.weatherBox count] > 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:[[self.weatherBox objectAtIndex:0] weatherDictionary] forKey:kSDLastWeather];
        [userDefaults synchronize];
    }
}

- (void)loadWeather
{
    if ([self.weatherLoader isLoading]) {
        return;
    }
    NSImage *img = [NSImage imageNamed:@"Cloud-Download"];
    [img setSize:NSMakeSize(32, 32)];
    [self.statusView setImage:img];
    [self.weatherLoader loadWeathers];
}

- (void)say
{
    SDWeather *todayWeather = nil;
    if ([self.weatherBox count] > 0) {
        todayWeather = [self.weatherBox objectAtIndex:0];
    }
    [self.voiceGenerator sayTimeAndWeather:todayWeather];
}

- (void)popMenu
{
    [self.statusItem popUpStatusItemMenu:self.statusMenu];
}

- (void)receiveWeatherBox
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // update last weather
    NSString *todayString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *lastString = [[NSUserDefaults standardUserDefaults] valueForKey:kSDLastDate];
    if (!self.lastWeather || (![todayString isEqualToString:lastString] && self.lastWeather)) {
        if ([self.weatherBox count] > 0) {
            self.lastWeather = [self.weatherBox objectAtIndex:0];
        } else {
            self.lastWeather = [[SDWeather alloc] initWithDictionary:[userDefaults valueForKey:kSDLastWeather]];
        }
    }
    
    // update user defaults
    [userDefaults setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:kSDLastDate];
    if (self.lastWeather) {
        [userDefaults setValue:self.lastWeather.weatherDictionary forKey:kSDLastWeather];
    }
    [userDefaults synchronize];
    
    // update my weatherBox
    [self.weatherBox removeAllObjects];
    [self.weatherBox addObjectsFromArray:self.weatherLoader.weatherBox];
    
    // refresh status item image
    NSImage *statusImage = [NSImage imageNamed:[(SDWeather *)[self.weatherBox objectAtIndex:0] condition]];
    [self.statusView setImage:statusImage];
    
    // refresh menu
    [self.statusMenu removeAllItems];
    NSMenuItem *menuItem;
    
    menuItem = [self getWeatherMenuItemByWeather:[self.weatherBox objectAtIndex:0]];
    [self.statusMenu addItem:menuItem];
    menuItem = [NSMenuItem separatorItem];
    [self.statusMenu addItem:menuItem];
    
    if (self.lastWeather) {
        menuItem = [self getWeatherMenuItemByWeather:self.lastWeather];
        [self.statusMenu addItem:menuItem];
    }
    for (NSInteger i = 1; i <= [self.weatherBox count] - 1; i ++) {
        SDWeather *weather = [self.weatherBox objectAtIndex:i];
        menuItem = [self getWeatherMenuItemByWeather:weather];
        [self.statusMenu addItem:menuItem];
    }
    menuItem = [NSMenuItem separatorItem];
    [self.statusMenu addItem:menuItem];
    
    menuItem = [[NSMenuItem alloc] initWithTitle:@"Sync" action:@selector(loadWeather) keyEquivalent:@""];
    [menuItem setTarget:self];
    [self.statusMenu addItem:menuItem];
    menuItem = [NSMenuItem separatorItem];
    [self.statusMenu addItem:menuItem];
    menuItem = [[NSMenuItem alloc] initWithTitle:@"Quit Sunny Dolls" action:@selector(terminate:) keyEquivalent:@""];
    [menuItem setTarget:NSApp];
    [self.statusMenu addItem:menuItem];
}

@end
