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
        OHParagraphStyle* paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
        paragraphStyle.textAlignment = kCTJustifiedTextAlignment;
        paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
        paragraphStyle.firstLineHeadIndent = 0.f; // indentation for first line
        paragraphStyle.lineSpacing = 5.f; // increase space between lines by 3 points
        [_msg setParagraphStyle:paragraphStyle];
        [_msg setFont:[UIFont systemFontOfSize:15]];
        [_msg setTextAlignment:kCTTextAlignmentLeft lineBreakMode:kCTLineBreakByWordWrapping];
        self.userHeadImage = [[dic objectForKey:@"userImage"] componentsSeparatedByString:@"_"][0];
        self.nickName = [dic objectForKey:@"nickname"];
        self.userID = [dic objectForKey:@"userid"];
    }
    return self;
}
@end
