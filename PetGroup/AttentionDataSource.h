//
//  AttentionDataSource.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DataSource.h"
#import "CircleCell.h"

@interface AttentionDataSource : DataSource<UITableViewDataSource>
@property (nonatomic,retain)NSMutableArray* dynamicArray;
@property (nonatomic,assign)UIViewController<CircleCellDelegate>* myController;
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
-(void)loadHistorySuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end
