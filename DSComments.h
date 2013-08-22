//
//  DSComments.h
//  PetGroup
//
//  Created by Tolecen on 13-8-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSComments : NSManagedObject

@property (nonatomic, retain) NSString * dynamicID;
@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSString * commentContent;
@property (nonatomic, retain) NSDate * commentTime;
@property (nonatomic, retain) NSString * readed;
@property (nonatomic, retain) NSString * commentID;

@end
