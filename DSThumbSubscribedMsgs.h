//
//  DSThumbSubscribedMsgs.h
//  PetGroup
//
//  Created by Tolecen on 13-8-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSThumbSubscribedMsgs : NSManagedObject

@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSString * senderNickname;
@property (nonatomic, retain) NSString * receiver;
@property (nonatomic, retain) NSString * msgContent;
@property (nonatomic, retain) NSDate * sendTime;
@property (nonatomic, retain) NSString * msgType;

@end
