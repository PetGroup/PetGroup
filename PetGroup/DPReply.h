//
//  DPReply.h
//  PetGroup
//
//  Created by wangxr on 13-11-30.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPReply : NSObject
@property (nonatomic,retain)NSString* nickname;//评价人
@property (nonatomic,retain)NSString* excerpt;//评价内容
@property (nonatomic,assign)int rating;//评价等级
-(id)initWithNSDictionary:(NSDictionary*)dic;
@end
