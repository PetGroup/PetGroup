//
//  CircleClassify.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-17.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "CircleClassify.h"
#import "CircleEntity.h"
@implementation CircleClassify
- (id)initWithDictionnary:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.name = [info objectForKey:@"name"];
        NSArray* array = [info objectForKey:@"child"];
        self.circleArray = [NSMutableArray array];
        for (NSDictionary* dic in array) {
            CircleEntity* circle = [[CircleEntity alloc]initWithDictionnary:dic];
            [_circleArray addObject:circle];
        }
        self.zhankai = NO;
    }
    return self;
}
@end
