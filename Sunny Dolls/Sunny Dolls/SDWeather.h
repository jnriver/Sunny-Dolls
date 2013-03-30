//
//  SDWeather.h
//  Sunny Dolls
//
//  Created by nangua on 13-3-30.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDWeather : NSObject

@property (strong, nonatomic) NSString *condition;
@property (strong, nonatomic) NSString *conditionDescription;
@property (nonatomic) NSInteger highCelsius;
@property (nonatomic) NSInteger lowCelsius;

@end
