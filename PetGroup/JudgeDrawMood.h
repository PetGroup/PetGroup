//
//  DrawMood.h
//  PetGroup
//
//  Created by Tolecen on 14-1-2.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JudgeDrawMood : NSObject
{
    NSArray * aNewyearArray;
    NSArray * christmasArray;
    NSArray * birthdayArray;
    
}
- (id)initWithArrays;
-(void)isExsitKeyWordsInTheSentence:(NSString *)theSentence ExsitYES:(void (^)(NSString * theType))exsistYES ExsitNO:(void (^)())exsistNO;
@end
