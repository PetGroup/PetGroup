//
//  Reply.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "Reply.h"

@implementation Reply
- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.replyID = [dic objectForKey:@"id"];
        self.msg = [dic objectForKey:@"msg"];
        self.dynamicID = [dic objectForKey:@"userStateid"];
        self.petUser =[[HostInfo alloc]initWithHostInfo:[dic objectForKey:@"petUserView"]];
        self.replyComment = [NSMutableArray arrayWithArray:[dic objectForKey:@"replyCommentViews"]];
    }
    return self;
}
@end
