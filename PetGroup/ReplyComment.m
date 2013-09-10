//
//  ReplyComment.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-10.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ReplyComment.h"

@implementation ReplyComment
- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.replyCommentID = [dic objectForKey:@"id"];
        self.userStateid = [dic objectForKey:@"userStateid"];
        self.replyID = [dic objectForKey:@"replyid"];
        self.commentsMsg = [dic objectForKey:@"commentsMsg"];
        self.replyUserView = [[HostInfo alloc]initWithHostInfo:[dic objectForKey:@"replyUserView"]];
        self.commentUserView = [[HostInfo alloc]initWithHostInfo:[dic objectForKey:@"commentUserView"]];
        NSLog(@"%@",self.commentsMsg);
    }
    return self;
}
@end
