//
//  Dynamic.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-30.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "Dynamic.h"
#import "Common.h"
#import "NSAttributedString+Attributes.h"
#import "OHASBasicHTMLParser.h"
@implementation Dynamic
- (id)initWithNSDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.countZan = [[dic objectForKey:@"totalPat"] integerValue];
        self.submitTime = [Common DynamicCurrentTime:[Common getCurrentTime] AndMessageTime:[dic objectForKey:@"ct"]];
        self.dynamicID = [dic objectForKey:@"id"];
        self.ifIZaned = [[dic objectForKey:@"didIpat"] boolValue];
        self.ifTransmitMsg = [[dic objectForKey:@"ifTransmitMsg"] intValue];
        self.imageID = [dic objectForKey:@"imgid"];
        NSArray* i = [[dic objectForKey:@"imgid"] componentsSeparatedByString:@","];
        if (i.count>1) {
            self.smallImage = [NSMutableArray array];
            self.imgIDArray = [NSMutableArray array];
            for (NSString* a in i) {
                NSArray *arr = [a componentsSeparatedByString:@"_"];
                if (arr.count>1) {
                    [self.smallImage addObject:arr[0]];
                    [self.imgIDArray addObject:arr[1]];
                }
            }
        }
        self.msg = [OHASBasicHTMLParser attributedStringByProcessingMarkupInString:[dic objectForKey:@"msg"]];
        [_msg setFont:[UIFont systemFontOfSize:15]];
        [_msg setTextAlignment:kCTTextAlignmentLeft lineBreakMode:kCTLineBreakByWordWrapping];
        self.userHeadImage = [[dic objectForKey:@"userImage"] componentsSeparatedByString:@"_"][0];
        self.nickName = [dic objectForKey:@"nickname"];
        self.userID = [dic objectForKey:@"userid"];
        self.state = [dic objectForKey:@"state"];
        NSString * transmitMsg = [dic objectForKey:@"transmitMsg"];
        if (!transmitMsg) {
            transmitMsg = @" ";
        }

        self.transmitMsg =[OHASBasicHTMLParser attributedStringByProcessingMarkupInString:transmitMsg];
  
        
        [_transmitMsg setFont:[UIFont systemFontOfSize:15]];
        [_transmitMsg setTextAlignment:kCTTextAlignmentLeft lineBreakMode:kCTLineBreakByWordWrapping];
        self.transmitUrl = [dic objectForKey:@"transmitUrl"];
    }
    return self;
}
@end
