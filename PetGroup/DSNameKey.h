//
//  DSNameKey.h
//  PetGroup
//
//  Created by Tolecen on 14-2-11.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSNameKey : NSManagedObject

@property (nonatomic, retain) NSString * nameKey;
@property (nonatomic, retain) NSString * nameIndex;
@property (nonatomic, retain) NSString * username;

@end
