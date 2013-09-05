//
//  HostInfo.m
//  PetGroup
//
//  Created by Tolecen on 13-8-21.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "HostInfo.h"
#import "PetInfo.h"
@implementation HostInfo
- (id)initWithHostInfo:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.userName = ![[info objectForKey:@"username"] isKindOfClass:[NSNull class]]?[info objectForKey:@"username"]:@"";
        self.userId = [NSString stringWithFormat:@"%@",![[info objectForKey:@"userid"] isKindOfClass:[NSNull class]]?[info objectForKey:@"userid"]:@""];
        self.nickName = ![[info objectForKey:@"nickname"] isKindOfClass:[NSNull class]]?[info objectForKey:@"nickname"]:@"";
        self.telNumber = ![[info objectForKey:@"username"] isKindOfClass:[NSNull class]]?[info objectForKey:@"username"]:@"";
        self.gender = ![[info objectForKey:@"gender"] isKindOfClass:[NSNull class]]?[info objectForKey:@"gender"]:@"";
        self.age = [NSString stringWithFormat:@"%@",![[info objectForKey:@"birthdate"] isKindOfClass:[NSNull class]]?[info objectForKey:@"birthdate"]:@""];
        self.signature = ![[info objectForKey:@"signature"] isKindOfClass:[NSNull class]]?[info objectForKey:@"signature"]:@"用户暂时还没有设置签名";
        self.hobby = ![[info objectForKey:@"hobby"] isKindOfClass:[NSNull class]]?[info objectForKey:@"hobby"]:@"用户暂时还没有设置爱好";
        self.latitude = [NSString stringWithFormat:@"%@",![[info objectForKey:@"latitude"] isKindOfClass:[NSNull class]]?[info objectForKey:@"latitude"]:@""];
        self.longitude = [NSString stringWithFormat:@"%@",![[info objectForKey:@"longitude"] isKindOfClass:[NSNull class]]?[info objectForKey:@"longitude"]:@""];
        self.headImgArray = [self getHeadImgArray:[NSString stringWithFormat:@"%@",[info objectForKey:@"img"]]];
        NSArray * petTempArray = [info objectForKey:@"petInfoViews"];
        NSMutableArray * tempArray = [NSMutableArray array];
        NSMutableArray * petH = [NSMutableArray array];
        for (NSDictionary * dict in petTempArray) {
            PetInfo * petinfo = [[PetInfo alloc] initWithPetInfo:dict];
            [tempArray addObject:petinfo];
            [petH addObject:petinfo.firstHead];
        }
        self.petsArray = tempArray;
        self.petsHeadArray = petH;
        
    }
    return self;
}
- (NSArray *)getHeadImgArray:(NSString *)headImgStr
{
    NSRange range=[headImgStr rangeOfString:@","];
    if (range.location!=NSNotFound) {
        NSArray *imageArray = [headImgStr componentsSeparatedByString:@","];
        return imageArray;
    }
    else if(headImgStr.length>0)
    {
        NSArray * imageArray = [NSArray arrayWithObject:headImgStr];
        return imageArray;
    }
    else
        return nil;
    
    
}
@end
