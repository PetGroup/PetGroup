//
//  DSReceivedHellos.h
//  PetGroup
//
//  Created by Tolecen on 13-8-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSReceivedHellos : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * headImgID;
@property (nonatomic, retain) NSString * ifFriend;
@property (nonatomic, retain) NSString * addtionMsg;
@property (nonatomic, retain) NSString * acceptStatus;
@property (nonatomic, retain) NSDate * receiveTime;
@property (nonatomic, retain) NSString * unreadCount;


@end
