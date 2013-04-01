//
//  SDWeather.m
//  Sunny Dolls
//
//  Created by nangua on 13-3-30.
//  Copyright (c) 2013年 jnriver. All rights reserved.
//

#import "SDWeather.h"

@implementation SDWeather

- (id)initWithDictionary:(NSDictionary *)weatherDict
{
    self = [super init];
    if (self) {
        NSInteger year = [[weatherDict valueForKeyPath:@"date.year"] integerValue];
        NSInteger month = [[weatherDict valueForKeyPath:@"date.month"] integerValue];
        NSInteger day = [[weatherDict valueForKeyPath:@"date.day"] integerValue];
        self.dateDescription = [NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day];
        self.dayDescription = [weatherDict valueForKeyPath:@"date.weekday"];
        
        self.condition = [weatherDict valueForKey:@"icon"];
        self.conditionDescription = [weatherDict valueForKey:@"conditions"];
        
        self.highCelsius = [[weatherDict valueForKeyPath:@"high.celsius"] integerValue];
        self.lowCelsius = [[weatherDict valueForKeyPath:@"low.celsius"] integerValue];
        
        self.humidity = [[weatherDict valueForKey:@"avehumidity"] integerValue];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n    dateDescription:%@\n    dayDescription:%@\n    conditionDescription:%@\n    conditionDescription:%@\n    highCelsius:%ld\n    lowCelsius:%ld\n    humidity:%ld",
            self.dateDescription,
            self.dayDescription,
            self.condition,
            self.conditionDescription,
            self.highCelsius,
            self.lowCelsius,
            self.humidity
            ];
}

@end
