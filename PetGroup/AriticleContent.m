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
        self.contentStr = [info objectForKey:@"content"];
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
    NSString * regExStr = @"\\[([a-zA-Z0-9\\u4e00-\\u9fa5]+?)\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regExStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    NSString *facefilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImageThird.plist"];
    NSDictionary *m_pEmojiDic = [[NSDictionary alloc] initWithContentsOfFile:facefilePath];

//    __block NSMutableArray  * keyArray = [NSMutableArray array];
    __block NSMutableArray  * rangeArray = [NSMutableArray array];
    __block NSMutableArray  * lengthArray = [NSMutableArray array];
    __block NSMutableArray  * replacementArray = [NSMutableArray array];
    [regex enumerateMatchesInString:contentStr options:0 range:NSMakeRange(0, [contentStr length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString * resultStr = [contentStr substringWithRange:[result rangeAtIndex:1]];
        NSLog(@"images = %@",resultStr);
        NSLog(@"range = %d,%d",[result rangeAtIndex:1].location,[result rangeAtIndex:1].length);
//        [keyArray addObject:resultStr];
        [rangeArray addObject:[NSNumber numberWithInt:([result rangeAtIndex:1].location-1)]];
        [lengthArray addObject:[NSNumber numberWithInt:([result rangeAtIndex:1].length+2)]];
        if (m_pEmojiDic[resultStr]) {
            [replacementArray addObject:[NSString stringWithFormat:@"<img src=\"%@\" width=\"18\" height=\"18\" />",m_pEmojiDic[resultStr]]];
        }
        else
            [replacementArray addObject:resultStr];
 //       [timeTimes addObject:[tmp substringWithRange:[result rangeAtIndex:1]]];
    }];
    NSMutableString * uu = [[NSMutableString alloc] initWithString:contentStr];
    int lengthC = uu.length;
    for (int i = 0; i<rangeArray.count;i++) {
        int d = uu.length - lengthC;
        [uu replaceCharactersInRange:NSMakeRange([rangeArray[i] integerValue]+d, [lengthArray[i] integerValue]) withString:replacementArray[i]];
    }
    NSData *data = [uu dataUsingEncoding:NSUTF8StringEncoding];
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:NULL];
	return attributedString;
}
@end
