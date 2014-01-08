//
//  Subject.h
//  PetGroup
//
//  Created by wangxr on 14-1-6.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subject : NSObject
@property (nonatomic,retain)NSString * title;
@property (nonatomic,retain)NSString * content;
@property (nonatomic,retain)NSURL * imageURL;
@property (nonatomic,retain)NSString * articleID;
@property (nonatomic,retain)NSString* time;
-(id)initWithNSDictionary:(NSDictionary*)dic;
@end
