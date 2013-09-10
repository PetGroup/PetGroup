//
//  ReplyComment.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-10.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostInfo.h"
@interface ReplyComment : NSObject
@property (nonatomic,strong)NSString* replyCommentID;
@property (nonatomic,strong)NSString* commentsMsg;
@property (nonatomic,strong)NSString* userStateid;
@property (nonatomic,strong)NSString* replyID;
@property (nonatomic,strong)HostInfo* replyUserView;
@property (nonatomic,strong)HostInfo* commentUserView;
- (id)initWithDictionary:(NSDictionary*)dic;
@end
