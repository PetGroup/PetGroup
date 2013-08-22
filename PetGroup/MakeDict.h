//
//  MakeDict.h
//  PetGroup
//
//  Created by Tolecen on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MakeDict : NSObject
+(NSDictionary *)dictWithUsualElements:(NSArray *)elements ForKeys:(NSArray *)key AndParams:(NSArray *)params ForParamsKey:(NSArray *)paramsKey;
@end
