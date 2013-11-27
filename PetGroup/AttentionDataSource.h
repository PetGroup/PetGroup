//
//  AttentionDataSource.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DataSource.h"
@interface AttentionDataSource : DataSource<UITableViewDataSource>
@property (nonatomic,retain)NSMutableArray* dynamicArray;
@property (nonatomic,assign)UIViewController<UITableViewDelegate>* myController;
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
-(void)loadHistorySuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end
