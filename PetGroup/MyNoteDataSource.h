//
//  MyNoteDataSource.h
//  PetGroup
//
//  Created by wangxr on 13-11-29.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DataSource.h"

@interface MyNoteDataSource : DataSource<UITableViewDataSource>
@property (nonatomic,assign)int pageNo;
@property (nonatomic,assign)UIViewController* myController;
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end
