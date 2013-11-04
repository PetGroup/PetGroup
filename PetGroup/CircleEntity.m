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
    }
    return self;
}
@end
