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
        DLog(@"requestStr:%@", requestStr);
        NSURL *requestURL = [[NSURL alloc] initWithString:requestStr];
        weatherRequst = [[NSURLRequest alloc] initWithURL:requestURL];
    }
    return self;
}

- (NSString *)getWeather
{
    finished = NO;
    __unused NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:weatherRequst delegate:self];
    while(!finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return nil;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    NSLog(@"willSendRequest");
    return weatherRequst;
}
//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
//{
//    DLog(@"willCacheResponse");
//}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    [responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    [responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    NSLog(@"%@", [NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    DLog(@"connectionDidFinishLoading");
}
@end
