//
//  AnimationStoreManager.h
//  testTab
//
//  Created by liuxiaoyu on 14-1-3.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationStoreManager : NSObject

+ (instancetype)sharedManager;

- (void)doAnimationWithTypeArray:(NSArray *)typeArray view:(UIView *)view;

@end
