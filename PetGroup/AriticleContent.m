//
//  AriticleContent.m
//  PetGroup
//
//  Created by  wangxr on 13-11-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "AriticleContent.h"

@implementation AriticleContent
- (id)initWithDictionnary:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.articleID = [info objectForKey:@"id"];
        self.name = [info objectForKey:@"name"];
        self.content = [AriticleContent _attributedStringForSnippetUsingiOS6Attributes:NO String:[info objectForKey:@"content"]];
        self.clientCount = [NSString stringWithFormat:@"%d",[[info objectForKey:@"clientCount"] integerValue]];
        self.replyCount = [NSString stringWithFormat:@"%d",[[info objectForKey:@"totalReply"] integerValue]];
        self.cTotalReply = [NSString stringWithFormat:@"%d",[[info objectForKey:@"cTotalReply"] integerValue]];
        self.userName = [info objectForKey:@"nickname"];
        NSArray *arr = [[info objectForKey:@"userIcon"] componentsSeparatedByString:@"_"];
        self.headImage = arr[0];
        self.ct =[Common noteContentCurrentTime:[Common getCurrentTime] AndMessageTime:[info objectForKey:@"ct"]];//发布时间
        self.userId = [info objectForKey:@"userId"];
    }
    return self;
}
+ (NSAttributedString *)_attributedStringForSnippetUsingiOS6Attributes:(BOOL)useiOS6Attributes String:(NSString *)contentStr
{
    NSData *data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:NULL];
	return attributedString;
}
@end
