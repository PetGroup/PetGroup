//
//  FriendCircleDataSource.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DataSource.h"
#import "DynamicCell.h"
#import "TableViewDatasourceDidChange.h"
@interface FriendCircleDataSource : DataSource<UITableViewDataSource>
@property (nonatomic,assign)UIViewController<DynamicCellDelegate>* myController;
@property (nonatomic,retain)NSMutableDictionary*replyCountDic;
//@property (nonatomic,retain)NSMutableArray*rowHighArray;
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end
