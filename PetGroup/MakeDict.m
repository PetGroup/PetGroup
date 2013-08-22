//
//  MakeDict.m
//  PetGroup
//
//  Created by Tolecen on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "MakeDict.h"

@implementation MakeDict
+(NSDictionary *)dictWithUsualElements:(NSArray *)elements ForKeys:(NSArray *)key AndParams:(NSArray *)params ForParamsKey:(NSArray *)paramsKey
{
    NSMutableDictionary * theParamsDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    for (int i = 0; i<params.count;i++) {
        [theParamsDict setObject:[params objectAtIndex:i] forKey:[paramsKey objectAtIndex:i]];
    }
    for (int i = 0; i<elements.count; i++) {
        [postDict setObject:[elements objectAtIndex:i] forKey:[key objectAtIndex:i]];
        if ([[key objectAtIndex:i] isEqualToString:@"connectTime"]||[[key objectAtIndex:i] isEqualToString:@"createTime"]) {
            NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
            [postDict setObject:[NSString stringWithFormat:@"%lld",(long long)(cT*1000)] forKey:[key objectAtIndex:i]];
        }
    }
    [postDict setObject:theParamsDict forKey:@"params"];
    return postDict;
    
}
@end
