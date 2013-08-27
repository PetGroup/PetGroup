//
//  UnreadCount.h
//  PetGroup
//
//  Created by Tolecen on 13-8-27.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSUnreadCount : NSManagedObject

@property (nonatomic, retain) NSString * receivedHellosUnread;
@property (nonatomic, retain) NSString * publicUnread;
@property (nonatomic, retain) NSString * subscribedUnread;

@end
