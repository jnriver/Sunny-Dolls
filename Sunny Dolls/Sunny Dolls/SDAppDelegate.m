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
NSDateFormatter *hourFormatter;

@implementation SDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self initUserDefaults];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    hourFormatter = [[NSDateFormatter alloc] init];
    [hourFormatter setDateFormat:@"HH"];
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
    NSImage *img = [NSImage imageNamed:@"Cloud-Refresh"];
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
    
    menuItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    [menuItem setTarget:NSApp];
    [self.statusMenu addItem:menuItem];
}

- (void)initUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{
                   kSDLocation:@"zhuhai",
             kSDLastUpdateDate:@"19000101",
         kSDLastUpdateTimeHour:@"00",
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
    NSString *nowDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *lastDate = [[NSUserDefaults standardUserDefaults] valueForKey:kSDLastUpdateDate];
    
    NSString *nowHour = [hourFormatter stringFromDate:[NSDate date]];
    NSString *lastHour = [[NSUserDefaults standardUserDefaults] valueForKey:kSDLastUpdateTimeHour];
    
    if ((![nowDate isEqualToString:lastDate] || ![nowHour isEqualToString:lastHour])&& !self.weatherLoader.isLoading) {
        [self loadWeather];
    }
}

- (void)loadWeather
{
    if ([self.weatherLoader isLoading]) {
        return;
    }
    NSImage *img = [NSImage imageNamed:@"Cloud-Refresh"];
    [img setSize:NSMakeSize(32, 32)];
    [self.statusView setImage:img];
    [self.weatherLoader loadWeathers];
}

- (void)say
{
    SDWeather *todayWeather = nil;
    if ([self.weatherBox count] == 0) {
        return;
    }
    
    [self.statusView setImage:[NSImage imageNamed:@"Say"]];
    todayWeather = [self.weatherBox objectAtIndex:0];
    [self.voiceGenerator sayTimeAndWeather:todayWeather];
}

- (void)finishSay
{
    if ([self.weatherBox count] != 0) {
        NSImage *statusImage = [NSImage imageNamed:[(SDWeather *)[self.weatherBox objectAtIndex:0] condition]];
        [self.statusView setImage:statusImage];
    } else {
        NSImage *img = [NSImage imageNamed:@"Cloud-Refresh"];
        [img setSize:NSMakeSize(32, 32)];
        [self.statusView setImage:img];
    }
}

- (void)popMenu
{
    [self.statusItem popUpStatusItemMenu:self.statusMenu];
}

- (void)receiveWeatherError
{
    NSImage *statusImage;
    if ([self.weatherBox count] > 0) {
        statusImage = [NSImage imageNamed:[(SDWeather *)[self.weatherBox objectAtIndex:0] condition]];
        [self.statusView setImage:statusImage];
    }
}

- (void)receiveWeatherBox
{
    if ([self.weatherBox count] == 0) {
        [self.weatherBox addObjectsFromArray:self.weatherLoader.weatherBox];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nowDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *lastDate = [[NSUserDefaults standardUserDefaults] valueForKey:kSDLastUpdateDate];
    // same day, don't update lastWeather
    if (![nowDate isEqualToString:lastDate]) {
        // update UserDefaults
        [userDefaults setValue:[[self.weatherBox objectAtIndex:0] weatherDictionary] forKey:kSDLastWeather];
        [userDefaults setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:kSDLastUpdateDate];
        [userDefaults synchronize];
        
        // update self.lastWeather
        self.lastWeather = [self.weatherBox objectAtIndex:0];
    } else {
        // update UserDefaults
        NSString *nowHour = [hourFormatter stringFromDate:[NSDate date]];
        [userDefaults setValue:nowHour forKey:kSDLastUpdateTimeHour];
        [userDefaults synchronize];
    }
    
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
    [self.statusView setToolTip:menuItem.title];
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
    
    menuItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    [menuItem setTarget:NSApp];
    [self.statusMenu addItem:menuItem];
}

@end
