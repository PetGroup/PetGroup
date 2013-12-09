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
//        self.content = [info objectForKey:@"content"];
        self.clientCount = [NSString stringWithFormat:@"%d",[[info objectForKey:@"clientCount"] integerValue]];
        self.replyCount = [NSString stringWithFormat:@"%d",[[info objectForKey:@"totalReply"] integerValue]];
        self.userName = [info objectForKey:@"nickname"];
        self.circleName = @"什么什么圈";
//        self.headImage = [info objectForKey:@"userIcon"];
        self.isEute = [[info objectForKey:@"isEute"]boolValue];
        self.isTop = [[info objectForKey:@"isTop"] boolValue];
        NSArray *arr = [[info objectForKey:@"userIcon"] componentsSeparatedByString:@"_"];
        self.headImage = arr[0];
        self.ct =[Common noteCurrentTime:[Common getCurrentTime] AndMessageTime:[info objectForKey:@"ct"]];//发布时间
        if ([[info objectForKey:@"type"] isEqualToString:@"img"]) {
            self.haveImage = 1;
        }else{
            self.haveImage = 0;
        }
        NSString* str = [info objectForKey:@"name"];
        if ((self.haveImage||self.isTop||self.isEute)&&str.length>26) {
            self.name = [NSString stringWithFormat:@"%@%@",[str substringToIndex:26],@"..."];
        }else{
            self.name = str;
        }
    }
    return self;
}
@end
