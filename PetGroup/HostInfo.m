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
        self.region = ![[info objectForKey:@"city"] isKindOfClass:[NSNull class]]?[info objectForKey:@"city"]:@"未知";
//        self.headImgArray = [self getHeadImgArray:[NSString stringWithFormat:@"%@",[info objectForKey:@"img"]]];
        self.headImgStr = [NSString stringWithFormat:@"%@",[info objectForKey:@"img"]];
        [self getHead:[NSString stringWithFormat:@"%@",[info objectForKey:@"img"]]];
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
- (id)initWithNewHostInfo:(NSDictionary*)info PetsArray:(NSArray *)petsArray
{
    self = [super init];
    if (self) {
        self.userName = ![[info objectForKey:@"username"] isKindOfClass:[NSNull class]]?[info objectForKey:@"username"]:@"";
        self.userId = [NSString stringWithFormat:@"%@",![[info objectForKey:@"id"] isKindOfClass:[NSNull class]]?[info objectForKey:@"id"]:@""];
        self.nickName = ![[info objectForKey:@"nickname"] isKindOfClass:[NSNull class]]?[info objectForKey:@"nickname"]:@"";
        self.telNumber = ![[info objectForKey:@"username"] isKindOfClass:[NSNull class]]?[info objectForKey:@"username"]:@"";
        self.gender = ![[info objectForKey:@"gender"] isKindOfClass:[NSNull class]]?[info objectForKey:@"gender"]:@"";
        self.age = [NSString stringWithFormat:@"%@",![[info objectForKey:@"birthdate"] isKindOfClass:[NSNull class]]?[info objectForKey:@"birthdate"]:@""];
        self.signature = ![[info objectForKey:@"signature"] isKindOfClass:[NSNull class]]?[info objectForKey:@"signature"]:@"用户暂时还没有设置签名";
        self.hobby = ![[info objectForKey:@"hobby"] isKindOfClass:[NSNull class]]?[info objectForKey:@"hobby"]:@"用户暂时还没有设置爱好";
        self.latitude = [NSString stringWithFormat:@"%@",![[info objectForKey:@"latitude"] isKindOfClass:[NSNull class]]?[info objectForKey:@"latitude"]:@""];
        self.longitude = [NSString stringWithFormat:@"%@",![[info objectForKey:@"longitude"] isKindOfClass:[NSNull class]]?[info objectForKey:@"longitude"]:@""];
        self.region = ![[info objectForKey:@"city"] isKindOfClass:[NSNull class]]?[info objectForKey:@"city"]:@"未知";
        //        self.headImgArray = [self getHeadImgArray:[NSString stringWithFormat:@"%@",[info objectForKey:@"img"]]];
        self.headImgStr = [NSString stringWithFormat:@"%@",[info objectForKey:@"img"]];
        [self getHead:[NSString stringWithFormat:@"%@",[info objectForKey:@"img"]]];
        NSArray * petTempArray = petsArray;
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
-(void)getHead:(NSString *)headImgStr
{
    NSMutableArray * littleHeadArray = [NSMutableArray array];
    NSMutableArray * bigHeadArray = [NSMutableArray array];
    NSArray* i = [headImgStr componentsSeparatedByString:@","];
    if (i.count>1) {     
        for (NSString* a in i) {
            NSArray *arr = [a componentsSeparatedByString:@"_"];
            if (arr.count>1) {
                [littleHeadArray addObject:arr[0]];
                [bigHeadArray addObject:arr[1]];
            }
        }
    }//动态大图ID数组和小图ID数组
    self.headImgArray = littleHeadArray;
    self.headBigImgArray = bigHeadArray;
}
@end
