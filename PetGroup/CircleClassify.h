//
//  CircleClassify.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-17.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleClassify : NSObject
@property (nonatomic,retain)NSString*name;
@property (nonatomic,retain)NSMutableArray*circleArray;
@property (nonatomic,assign)BOOL zhankai;
- (id)initWithDictionnary:(NSDictionary*)info;
@end
