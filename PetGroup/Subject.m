//
//  Subject.m
//  PetGroup
//
//  Created by wangxr on 14-1-6.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "Subject.h"

@implementation Subject
-(id)initWithNSDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.title = dic[@"name"];
        self.content = dic[@"summary"];;
        self.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl@"%@",dic[@"img"]]];
        self.articleID = dic[@"noteId"];;
        self.time = dic[@"et"];
    }
    return self;
}
@end
