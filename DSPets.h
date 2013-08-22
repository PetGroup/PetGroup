//
//  DSPets.h
//  PetGroup
//
//  Created by Tolecen on 13-8-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSPets : NSManagedObject

@property (nonatomic, retain) NSString * friendName;
@property (nonatomic, retain) NSString * friendNickname;
@property (nonatomic, retain) NSString * petNickname;
@property (nonatomic, retain) NSString * petType;
@property (nonatomic, retain) NSString * petTrait;
@property (nonatomic, retain) NSString * petHeadImgID;
@property (nonatomic, retain) NSString * petGender;
@property (nonatomic, retain) NSString * petAge;
@property (nonatomic, retain) NSString * petID;
@property (nonatomic, retain) NSDate * creatTime;

@end
