//
//  CircleEntity.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-17.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "CircleEntity.h"

@implementation CircleEntity
- (id)initWithDictionnary:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.circleID = [info objectForKey:@"id"];
        self.name = [info objectForKey:@"name"];
        self.todayTotal = [info objectForKey:@"totalToday"];
        self.totalCount = [info objectForKey:@"totalCount"];
        self.totalReply = [info objectForKey:@"totalReply"];
        self.atte = [[info objectForKey:@"atte"] boolValue];
        self.imageID = [info objectForKey:@"logoImg"];
        self.totalAtte = [info objectForKey:@"totalAtte"];
        UIColor * color1 = [UIColor colorWithRed:0.6 green:0.7 blue:0.2 alpha:1];
        UIColor * color2 = [UIColor colorWithRed:0.2 green:0.6 blue:0.4 alpha:1];
        UIColor * color3 = [UIColor colorWithRed:0.1 green:0.3 blue:0.8 alpha:1];
        UIColor * color4 = [UIColor colorWithRed:0.7 green:0.3 blue:0.6 alpha:1];
        UIColor * color5 = [UIColor colorWithRed:0.6 green:0.5 blue:0.2 alpha:1];
        NSArray * array = [NSArray arrayWithObjects:color1,color2,color4,color5,color3, nil];
        int g = arc4random()%4;
        self.theColor = array[g];
    }
    return self;
}
@end
