//
//  Reply.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reply : NSObject
@property (nonatomic,strong)NSDictionary*petUser;
@property (nonatomic,strong)NSMutableArray* replyComment;
@property (nonatomic,strong)NSString*replyID;
@property (nonatomic,strong)NSString*msg;
@property (nonatomic,strong)NSString*dynamicID;
- (id)initWithDictionary:(NSDictionary*)dic;
@end
