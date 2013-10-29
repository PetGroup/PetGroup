//
//  DynamicDataSource.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-25.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DataSource.h"
#import "DynamicCell.h"
#import "TableViewDatasourceDidChange.h"
@interface DynamicDataSource : DataSource<UITableViewDataSource>
@property (nonatomic,assign)NSString* lastStateid;
@property (nonatomic,assign)UIViewController<DynamicCellDelegate>* myController;
@property (nonatomic,retain)NSMutableDictionary*replyCountDic;
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end
