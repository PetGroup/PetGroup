//
//  Dynamic.h
//  PetGroup
//
//  Created by 阿铛 on 13-8-30.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dynamic : NSObject
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* headID;
@property (nonatomic,strong)NSString* msg;
@property (nonatomic,strong)NSString*dynamicID;
@property (nonatomic,strong)NSString*userID;
@property (nonatomic,strong)NSMutableArray* smallImage;
@property (nonatomic,strong)NSMutableArray* imgIDArray;
@property (nonatomic,strong)NSString*distance;
@property (nonatomic,strong)NSString*submitTime;
@property (nonatomic,assign)int ifTransmitMsg;
@property (nonatomic,strong)NSString*transmitMsg;
@property (nonatomic,strong)NSString*zanString;
@property (nonatomic,assign)int ifIZaned;
@property (nonatomic,assign)int ifZhankaied;
@property (nonatomic,strong)NSDictionary*petUser;
@property (nonatomic,strong)NSArray* replyViews;
@property (nonatomic,assign)float rowHigh;
-(id)initWithNSDictionary:(NSDictionary*)dic;
@end
