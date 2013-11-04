//
//  Article.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-18.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject
@property (nonatomic,retain) NSString* articleID;
@property (nonatomic,retain) NSString* name;
//@property (nonatomic,retain) NSString* content;
@property (nonatomic,retain) NSString* clientCount;
@property (nonatomic,retain) NSString* replyCount;
@property (nonatomic,retain) NSString* userName;
@property (nonatomic,retain) NSString* headImage;
@property (nonatomic,retain) NSString* ct;
@property (nonatomic,assign) BOOL isEute;
@property (nonatomic,assign) BOOL isTop;
- (id)initWithDictionnary:(NSDictionary*)info;
@end
