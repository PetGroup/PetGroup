//
//  BeautifulImage.m
//  PetGroup
//
//  Created by wangxr on 13-11-30.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "BeautifulImage.h"

@implementation BeautifulImage
-(id)initWithNSDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.imageID = [NSString stringWithString:[dic objectForKey:@"id"]];
        self.totalCount = [[dic objectForKey:@"totalCount"] intValue];
        self.height = [[dic objectForKey:@"height"] floatValue];
        self.width = [[dic objectForKey:@"width"] floatValue];
    }
    return self;
}
@end
