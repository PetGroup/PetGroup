//
//  DrawMood.m
//  PetGroup
//
//  Created by Tolecen on 14-1-2.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "JudgeDrawMood.h"

@implementation JudgeDrawMood
- (id)initWithArrays
{
    self = [super init];
    if (self) {

        aNewyearArray = @[
                          @"新年快乐",
                          @"新年好",
                          @"过年好",
                          @"Happy new year",
                          @"happy new year",
                          ];
        christmasArray = @[
                          @"圣诞快乐",
                          @"剩蛋快乐",
                          @"Merry Christmas",
                          ];
        birthdayArray = @[
                           @"生日快乐",
                           @"Happy birthday",
                           ];
    }
    return self;
}
-(void)isExsitKeyWordsInTheSentence:(NSString *)theSentence ExsitYES:(void (^)(NSString * theType))exsistYES ExsitNO:(void (^)())exsistNO
{
    __block int nums = 0;
    if (theSentence) {
        if (nums==1) {
            return;
        }
        [aNewyearArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",obj];
            *stop = [predicate evaluateWithObject:theSentence];
            NSLog(@"%@---%d---%@",obj,*stop,theSentence);
            if (*stop) {
                nums++;
                if (nums==1) {
                    exsistYES(@"NewYear");
                    return;
                }
                
            }
            else
            {
                exsistNO();
            }
        }];
        if (nums==1) {
            return;
        }
        [christmasArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",obj];
            *stop = [predicate evaluateWithObject:theSentence];
            NSLog(@"%@---%d---%@",obj,*stop,theSentence);
            if (*stop) {
                nums++;
                if (nums==1) {
                     exsistYES(@"Christmas");
                    return;
                }
               
            }
            else
            {
                exsistNO();
            }
        }];
        if (nums==1) {
            return;
        }
        [birthdayArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",obj];
            *stop = [predicate evaluateWithObject:theSentence];
            NSLog(@"%@---%d---%@",obj,*stop,theSentence);
            if (*stop) {
                nums++;
                if (nums==1) {
                    exsistYES(@"Birthday");
                    return;
                }
                
            }
            else
            {
                exsistNO();
            }
        }];
    }
    else
    {
        exsistNO();
    }

}
@end
