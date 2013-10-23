//
//  hotPintsDataSource.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DataSource.h"

@interface hotPintsDataSource : DataSource<UITableViewDataSource>
@property (nonatomic,assign)int pageNo;
@property (nonatomic,retain)NSString* forumPid;
@property (nonatomic,assign)UIViewController* myController;
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end
