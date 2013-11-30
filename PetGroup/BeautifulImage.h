//
//  BeautifulImage.h
//  PetGroup
//
//  Created by wangxr on 13-11-30.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeautifulImage : NSObject
@property (nonatomic,retain)NSString* imageID;
@property (nonatomic,assign)int totalCount;
@property (nonatomic,assign)float height;
@property (nonatomic,assign)float width;
-(id)initWithNSDictionary:(NSDictionary*)dic;
@end
