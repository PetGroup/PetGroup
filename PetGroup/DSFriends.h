//
//  DSFriends.h
//  PetGroup
//
//  Created by Tolecen on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSFriends : NSManagedObject

@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * headImgID;
@property (nonatomic, retain) NSString * hobby;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSNumber * petCount;
@property (nonatomic, retain) NSString * petsID;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * phoneNumber;

@end
