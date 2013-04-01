//
//  SDWeatherLoader.m
//  Sunny Dolls
//
//  Created by nangua on 13-3-29.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import <SBJson/SBJson.h>
#import "SDWeatherLoader.h"
#import "SDAppDelegate.h"
#import "SDWeather.h"

@implementation SDWeatherLoader

- (id)init
{
    self = [super init];
    if (self) {
        self.weatherBox = [[NSMutableArray alloc] init];
        NSString *loc = [[NSUserDefaults standardUserDefaults] stringForKey:kSDLocation];
        NSString *requestStr = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/lang:CN/q/CN/%@.json", kSDWeatherAPIID, loc];
        NSURL *requestURL = [[NSURL alloc] initWithString:requestStr];
        self.weatherRequst = [[NSURLRequest alloc] initWithURL:requestURL];
    }
    return self;
}

- (void)loadWeathers
{
    self.loading = YES;
    __unused NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.weatherRequst delegate:self];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    DLog(@"willSendRequest");
    return self.weatherRequst;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    DLog(@"didReceiveResponse");
    self.responseData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    DLog(@"didReceiveData");
    [self.responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLog(@"didFailWithError");
    self.loading = NO;
    DLog(@"%@", [NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    DLog(@"connectionDidFinishLoading");
    self.loading = NO;
    NSString *dataStr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *weatherInfoDict = [jsonParser objectWithString:dataStr];
    [self loadWeathersFromDictionary:weatherInfoDict];
}

- (void)loadWeathersFromDictionary:(NSDictionary *)weatherInfoDict
{
    [self.weatherBox removeAllObjects];
    NSArray *weatherDictArray = [weatherInfoDict valueForKeyPath:@"forecast.simpleforecast.forecastday"];
    for (NSDictionary *weatherDict in weatherDictArray) {
        SDWeather *weather = [[SDWeather alloc] initWithDictionary:weatherDict];
        [self.weatherBox addObject:weather];
        DLog(@"weather:%@", weather);
    }
    
    SDAppDelegate *delegate = [NSApplication sharedApplication].delegate;
    [delegate receiveWeatherBox];
}

@end
