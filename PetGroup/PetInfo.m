//
//  PetInfo.m
//  PetGroup
//
//  Created by Tolecen on 13-8-21.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PetInfo.h"

@implementation PetInfo
- (id)initWithPetInfo:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.petNickname = ![[info objectForKey:@"nickname"]isKindOfClass:[NSNull class]]?[info objectForKey:@"nickname"]:@"宠物";
        self.petType = [NSString stringWithFormat:@"%@",![[info objectForKey:@"type"]isKindOfClass:[NSNull class]]?[info objectForKey:@"type"]:@""];
        self.petTrait = ![[info objectForKey:@"trait"] isKindOfClass:[NSNull class]]?[info objectForKey:@"trait"]:@"平凡";
        self.headImgArray = [self getHeadImgArray:[NSString stringWithFormat:@"%@",[info objectForKey:@"img"]]];
        self.petGender = [info objectForKey:@"gender"]?[info objectForKey:@"gender"]:@"";
        self.petAge = [NSString stringWithFormat:@"%@",[info objectForKey:@"birthdate"]?[info objectForKey:@"birthdate"]:@""];
        self.hostID = [NSString stringWithFormat:@"%@",[info objectForKey:@"userid"]?[info objectForKey:@"userid"]:@""];
        
    }
    return self;
}

- (NSArray *)getHeadImgArray:(NSString *)headImgStr
{
    NSRange range=[headImgStr rangeOfString:@","];
    if (range.location!=NSNotFound) {
        NSArray *imageArray = [headImgStr componentsSeparatedByString:@","];
        self.firstHead = [imageArray objectAtIndex:0];
        return imageArray;
    }
    else if(headImgStr.length>0)
    {
        NSArray * imageArray = [NSArray arrayWithObject:headImgStr];
        self.firstHead = headImgStr;
        return imageArray;
    }
    else
    {
        self.firstHead = headImgStr;
        return nil;
    }
  
}
@end
