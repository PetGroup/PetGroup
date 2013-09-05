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
@property (nonatomic,assign)int countZan;
@property (nonatomic,assign)BOOL ifIZaned;
@property (nonatomic,assign)int ifZhankaied;
@property (nonatomic,strong)NSDictionary*petUser;
@property (nonatomic,strong)NSMutableArray* replyViews;
@property (nonatomic,assign)float rowHigh;
@property (nonatomic,strong)NSString *imageID;
-(id)initWithNSDictionary:(NSDictionary*)dic;
@end
