//
//  MyDynamicDataSource.h
//  PetGroup
//
//  Created by admin on 13-11-7.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DataSource.h"
#import "PersonalDynamicCell.h"
@interface MyDynamicDataSource : DataSource<UITableViewDataSource>
@property (nonatomic,assign)int pageNo;
@property (nonatomic,assign)UIViewController<DynamicCellDelegate>* myController;
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end
