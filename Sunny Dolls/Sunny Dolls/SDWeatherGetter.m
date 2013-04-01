//
//  SDWeatherGetter.m
//  Sunny Dolls
//
//  Created by nangua on 13-3-29.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import <SBJson/SBJson.h>
#import "SDWeatherGetter.h"

@implementation SDWeatherGetter

- (id)init
{
    self = [super init];
    if (self) {
        NSString *loc = [[NSUserDefaults standardUserDefaults] stringForKey:kSDLocation];
        NSString *requestStr = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/lang:CN/q/CN/%@.json", kSDWeatherAPIID, loc];
        NSURL *requestURL = [[NSURL alloc] initWithString:requestStr];
        self.weatherRequst = [[NSURLRequest alloc] initWithURL:requestURL];
    }
    return self;
}

- (void)getWeather
{
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
    DLog(@"%@", [NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *dataStr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    
    DLog(@"connectionDidFinishLoading:%@",dataStr);
}

@end
