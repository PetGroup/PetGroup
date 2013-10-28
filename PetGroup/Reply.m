//
//  Reply.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "Reply.h"
#import "NSAttributedString+Attributes.h"
#import "OHASBasicHTMLParser.h"
@implementation Reply
- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.replyID = [dic objectForKey:@"id"];
        self.submitTime = [Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:[dic objectForKey:@"ct"]];
        self.msg = [OHASBasicHTMLParser attributedStringByProcessingMarkupInString:[dic objectForKey:@"msg"]];
        [_msg setFont:[UIFont systemFontOfSize:15]];
        [_msg setTextAlignment:kCTTextAlignmentLeft lineBreakMode:kCTLineBreakByWordWrapping];
        self.userHeadImage = [[dic objectForKey:@"userImage"] componentsSeparatedByString:@"_"][0];
        self.nickName = [dic objectForKey:@"nickname"];
        self.userID = [dic objectForKey:@"userid"];
    }
    return self;
}
@end
