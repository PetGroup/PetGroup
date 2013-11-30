//
//  DPReply.m
//  PetGroup
//
//  Created by wangxr on 13-11-30.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DPReply.h"

@implementation DPReply
-(id)initWithNSDictionary:(NSDictionary*)dic;
{
    self = [super init];
    if (self) {
        self.nickname = [NSString stringWithString:[dic objectForKey:@"user_nickname"]];
        self.excerpt = [NSString stringWithString:[dic objectForKey:@"text_excerpt"]];
        self.rating = [[dic objectForKey:@"review_rating"] intValue];
    }
    return self;
}
@end
