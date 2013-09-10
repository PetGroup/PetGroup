//
//  Dynamic.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-30.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "Dynamic.h"
#import "Common.h"


@implementation Dynamic
- (id)initWithNSDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.ifZhankaied = 0;
        self.petUser =[[HostInfo alloc]initWithHostInfo: [dic objectForKey:@"petUserView"]];//动态的用户
        self.replyViews = [[NSMutableArray alloc]init];//动态的品论数组
        NSArray *replys = [dic objectForKey:@"replyViews"];
        for (NSDictionary* a in replys) {
            Reply* reply = [[Reply alloc]initWithDictionary:a];
            [_replyViews addObject:reply];
        }
        self.countReplys = [dic objectForKey:@"countReplys"];//动态的总品论数
        self.msg = [dic objectForKey:@"msg"];//动态内容
        self.dynamicID = [dic objectForKey:@"id"];//动态ID
        self.imageID = [dic objectForKey:@"imgid"];//动态的imageID,转发时使用
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
        }//动态大图ID数组和小图ID数组
        self.distance = [[dic objectForKey:@"distance"] isKindOfClass:[NSNull class]]?@"":[dic objectForKey:@"distance"];//动态的位置
        self.submitTime =[Common CurrentTime:[Common getCurrentTime] AndMessageTime:[NSString stringWithFormat:@"%f",[[dic objectForKey:@"submitTime"]doubleValue]/1000 ]];//发布时间
        self.ifTransmitMsg = [[dic objectForKey:@"ifTransmitMsg"]intValue];//是否是转发
        self.transmitMsg = [dic objectForKey:@"transmitMsg"];//转发内容
        self.countZan = [[dic objectForKey:@"countZan"] intValue];//赞的数目
        self.ifIZaned = [[dic objectForKey:@"ifIZaned"]boolValue];//我是否赞过，0 没攒，1 赞。
        
        self.rowHigh = 65;
        if (self.ifTransmitMsg!=0) {
            CGSize size = [_transmitMsg sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240, 90) lineBreakMode:NSLineBreakByWordWrapping];
            self.rowHigh+=(size.height+10);
             CGSize msgSize = [_msg sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240, 200) lineBreakMode:NSLineBreakByWordWrapping];
            if (msgSize.height>90) {
                self.rowHigh+=28;
            }else{
                self.rowHigh+=(size.height+10);
            }
        }else{
            CGSize size = [_msg sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240, 200) lineBreakMode:NSLineBreakByWordWrapping];
            if (size.height>=180) {
                self.rowHigh+=28;
            }else if(size.height>=90){
                self.rowHigh+=126;
            }else{
                self.rowHigh+=(size.height+10);
            }
        }
    }
    if (self.smallImage.count>=1&&self.smallImage.count<=3) {
        self.rowHigh+=85;
    }else if(self.smallImage.count>3&&self.smallImage.count<=6){
        self.rowHigh+=170;
    }else if(self.smallImage.count>6){
        self.rowHigh+=255;
    }
    self.rowHigh +=28*self.replyViews.count;
    return self;
}
@end
