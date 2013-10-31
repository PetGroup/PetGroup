//
//  HostInfo.h
//  PetGroup
//
//  Created by Tolecen on 13-8-21.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PetInfo;
@interface HostInfo : NSObject
@property (strong,nonatomic) NSString * userName;
@property (strong,nonatomic) NSString * userId;
@property (strong,nonatomic) NSString * nickName;
@property (strong,nonatomic) NSString * telNumber;
@property (strong,nonatomic) NSString * gender;
@property (strong,nonatomic) NSString * age;
@property (strong,nonatomic) NSString * signature;
@property (strong,nonatomic) NSString * hobby;
@property (strong,nonatomic) NSString * region;
@property (strong,nonatomic) NSString * latitude;
@property (strong,nonatomic) NSString * longitude;
@property (strong,nonatomic) NSString * headImgStr;
@property (strong,nonatomic) NSArray * headImgArray;
@property (strong,nonatomic) NSArray * headBigImgArray;
@property (strong,nonatomic) NSArray * petsArray;
@property (strong,nonatomic) NSArray * petsHeadArray;
@property (strong,nonatomic) NSString* backgroundImg;
- (id)initWithHostInfo:(NSDictionary*)info;
- (id)initWithNewHostInfo:(NSDictionary*)info PetsArray:(NSArray *)petsArray;
@end
