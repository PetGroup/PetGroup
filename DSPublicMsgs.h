//
//  DSPublicMsgs.h
//  PetGroup
//
//  Created by Tolecen on 13-8-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSPublicMsgs : NSManagedObject

@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSString * senderNickname;
@property (nonatomic, retain) NSString * receiver;
@property (nonatomic, retain) NSString * msgContent;
@property (nonatomic, retain) NSString * msgType;
@property (nonatomic, retain) NSString * msgFilesID;
@property (nonatomic, retain) NSString * articlesID;
@property (nonatomic, retain) NSDate * sendTime;

@end
