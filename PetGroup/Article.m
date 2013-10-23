//
//  Article.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-18.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "Article.h"
#import "Common.h"
@implementation Article
- (id)initWithDictionnary:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.articleID = [info objectForKey:@"id"];
        self.name = [info objectForKey:@"name"];
        self.clientCount = [NSString stringWithFormat:@"%d",[[info objectForKey:@"clientCount"] integerValue]];
       
        self.replyCount = [NSString stringWithFormat:@"%d",[[info objectForKey:@"totalReply"] integerValue]];
        self.userName = [info objectForKey:@"nickname"];
        self.headImage = [info objectForKey:@"userIcon"];
        self.isEute = [[info objectForKey:@"isEute"]boolValue];
        self.isTop = [[info objectForKey:@"isTop"] boolValue];
        NSArray *arr = [[info objectForKey:@"userIcon"] componentsSeparatedByString:@"_"];
        self.headImage = arr[0];
        NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
        dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = [dateF dateFromString:[info objectForKey:@"ct"]];
        NSTimeInterval cT = [date timeIntervalSince1970];
        self.ct =[Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:[NSString stringWithFormat:@"%f",cT]];//发布时间
        [info objectForKey:@"ct"];
    }
    return self;
}
@end
