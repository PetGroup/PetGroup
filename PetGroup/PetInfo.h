//
//  PetInfo.h
//  PetGroup
//
//  Created by Tolecen on 13-8-21.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HostInfo;
@interface PetInfo : NSObject
@property (strong,nonatomic) NSString * petNickname;
@property (strong,nonatomic) NSString * petType;
@property (strong,nonatomic) NSString * petTrait;
@property (strong,nonatomic) NSArray * headImgArray;
@property (strong,nonatomic) NSArray * headBigImgArray;
@property (strong,nonatomic) NSString * petGender;
@property (strong,nonatomic) NSString * petAge;
@property (strong,nonatomic) NSString * hostID;
@property (strong,nonatomic) NSString * firstHead;

- (id)initWithPetInfo:(NSDictionary*)info;
@end
