//
//  Reply.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Reply : NSObject
@property (nonatomic,strong)NSString*replyID;
@property (nonatomic,strong)NSString*submitTime;
@property (nonatomic,strong)NSMutableAttributedString* msg;
@property (nonatomic,strong)NSString* userHeadImage;
@property (nonatomic,strong)NSString* nickName;
@property (nonatomic,strong)NSString* userID;
- (id)initWithDictionary:(NSDictionary*)dic;
@end
