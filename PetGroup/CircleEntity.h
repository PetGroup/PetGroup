//
//  CircleEntity.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-17.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleEntity : NSObject
@property (nonatomic,retain)NSString* circleID;
@property (nonatomic,retain)NSString*name;
@property (nonatomic,retain)NSString*todayTotal;
@property (nonatomic,retain)NSString*totalCount;
@property (nonatomic,retain)NSString*totalReply;
@property (nonatomic,assign)BOOL atte;
@property (nonatomic,retain)NSString*imageID;
@property (nonatomic,assign)int totalAtte;
@property (nonatomic,retain)UIColor* theColor;
- (id)initWithDictionnary:(NSDictionary*)info;
@end
