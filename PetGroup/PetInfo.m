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
        self.petNickname = [info objectForKey:@"nickname"];
        self.petType = [NSString stringWithFormat:@"%@",[info objectForKey:@"type"]];
        self.petTrait = [info objectForKey:@"trait"];
        self.headImgArray = [self getHeadImgArray:[NSString stringWithFormat:@"%@",[info objectForKey:@"img"]]];
        self.petGender = [info objectForKey:@"gender"];
        self.petAge = [NSString stringWithFormat:@"%@",[info objectForKey:@"birthdate"]];
        self.hostID = [NSString stringWithFormat:@"%@",[info objectForKey:@"userid"]];
        
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
    else
    {
        NSArray * imageArray = [NSArray arrayWithObject:headImgStr];
        self.firstHead = headImgStr;
        return imageArray;
    }
  
}
@end
