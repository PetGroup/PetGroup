//
//  PersonalDynamic.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostInfo.h"
#import "Reply.h"
@interface PersonalDynamic : NSObject
@property (nonatomic,strong)NSString* msg;
@property (nonatomic,strong)NSString*dynamicID;
@property (nonatomic,strong)NSMutableArray* smallImage;
@property (nonatomic,strong)NSMutableArray* imgIDArray;
@property (nonatomic,strong)NSString*distance;
@property (nonatomic,strong)NSString*submitTime;
@property (nonatomic,assign)int ifTransmitMsg;
@property (nonatomic,strong)NSString*transmitMsg;
@property (nonatomic,assign)int countZan;
@property (nonatomic,assign)BOOL ifIZaned;
@property (nonatomic,assign)int ifZhankaied;
@property (nonatomic,strong)HostInfo*petUser;
@property (nonatomic,strong)NSMutableArray* replyViews;
@property (nonatomic,assign)float rowHigh;
@property (nonatomic,strong)NSString *imageID;
@property (nonatomic,strong)NSString *countReplys;
-(id)initWithNSDictionary:(NSDictionary*)dic;
@end
