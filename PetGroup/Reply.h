//
//  Reply.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostInfo.h"
@interface Reply : NSObject
@property (nonatomic,strong)NSMutableArray* replyComment;
@property (nonatomic,strong)NSString*replyID;
@property (nonatomic,strong)NSString*msg;
@property (nonatomic,strong)NSString*dynamicID;
@property (nonatomic,strong)HostInfo*petUser;
- (id)initWithDictionary:(NSDictionary*)dic;
@end
