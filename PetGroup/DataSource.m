//
//  DataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-12.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource
- (id)init
{
    self = [super init];
    if (self) {
        self.dataSourceArray = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    
}
-(void)loadHistorySuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    
}
@end
