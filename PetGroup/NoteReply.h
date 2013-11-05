//
//  NoteReply.h
//  PetGroup
//
//  Created by Tolecen on 13-11-5.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteReply : NSObject
@property (nonatomic,retain) NSString* replyID;
@property (nonatomic,retain) NSString* ParentID;
@property (nonatomic,retain) NSString* noteID;
@property (nonatomic,retain) NSString* userID;
@property (nonatomic,retain) NSString* userName;
@property (nonatomic,retain) NSString* headImage;
@property (nonatomic,retain) NSString* ct;
@property (nonatomic,retain) NSAttributedString* content;
@property (nonatomic,retain) NSString* state;
- (id)initWithDictionnary:(NSDictionary*)info;
@end
