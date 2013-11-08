//
//  DataSource.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-12.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject
@property(nonatomic,retain)NSMutableArray* dataSourceArray;
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
-(void)loadHistorySuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end
