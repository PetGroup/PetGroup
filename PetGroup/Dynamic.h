//
//  Dynamic.h
//  PetGroup
//
//  Created by 阿铛 on 13-8-30.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostInfo.h"
#import "Reply.h"

@interface Dynamic : NSObject
@property (nonatomic,assign)int countZan;
@property (nonatomic,strong)NSString*submitTime;
@property (nonatomic,strong)NSString*dynamicID;
@property (nonatomic,assign)BOOL ifIZaned;
@property (nonatomic,assign)int ifTransmitMsg;
@property (nonatomic,retain)NSString* imageID;
@property (nonatomic,strong)NSMutableArray* smallImage;
@property (nonatomic,strong)NSMutableArray* imgIDArray;
@property (nonatomic,strong)NSMutableAttributedString* msg;
@property (nonatomic,strong)NSString* userHeadImage;
@property (nonatomic,strong)NSString* nickName;
@property (nonatomic,strong)NSString* userID;
@property (nonatomic,strong)NSString* state;
@property (nonatomic,strong)NSMutableAttributedString*transmitMsg;
@property (nonatomic,strong)NSString* transmitUrl;
-(id)initWithNSDictionary:(NSDictionary*)dic;
@end
