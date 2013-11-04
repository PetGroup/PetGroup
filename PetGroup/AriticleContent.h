//
//  AriticleContent.h
//  PetGroup
//
//  Created by  wangxr on 13-11-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AriticleContent : NSObject
@property (nonatomic,retain) NSString* articleID;
@property (nonatomic,retain) NSString* name;
@property (nonatomic,retain) NSAttributedString* content;
@property (nonatomic,retain) NSString* clientCount;
@property (nonatomic,retain) NSString* replyCount;
@property (nonatomic,retain) NSString* userName;
@property (nonatomic,retain) NSString* headImage;
@property (nonatomic,retain) NSString* ct;
- (id)initWithDictionnary:(NSDictionary*)info;
@end
