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
@property (strong,nonatomic) NSString * nickName;
@property (strong,nonatomic) NSString * telNumber;
@property (strong,nonatomic) NSString * gender;
@property (strong,nonatomic) NSString * age;
@property (strong,nonatomic) NSString * signature;
@property (strong,nonatomic) NSString * hobby;
@property (strong,nonatomic) NSString * headImgID;
@property (strong,nonatomic) NSArray * petsArray;
@end
