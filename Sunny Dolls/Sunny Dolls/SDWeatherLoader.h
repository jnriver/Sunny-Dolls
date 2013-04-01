//
//  SDWeatherLoader.h
//  Sunny Dolls
//
//  Created by nangua on 13-3-29.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDWeatherLoader : NSObject <NSURLConnectionDelegate>

@property (strong, nonatomic) NSMutableArray *weatherBox;
@property (strong, nonatomic) NSURLRequest *weatherRequst;
@property (strong, nonatomic) NSMutableData *responseData;

@property (getter = isLoading, nonatomic) BOOL loading;

- (void)loadWeathers;

@end
