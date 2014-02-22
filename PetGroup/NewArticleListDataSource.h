//
//  NewArticleListDataSource.h
//  PetGroup
//
//  Created by wangxr on 14-2-21.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "DataSource.h"

@interface NewArticleListDataSource : DataSource<UITableViewDataSource>
@property (nonatomic,assign)int pageNo;
@property (nonatomic,retain)NSString* assortID;
@property (nonatomic,assign)UIViewController* myController;
+ (void)viewController:(UIViewController*)viewController loadTagListSuccess:(void (^)(NSArray * tagArray))success failure:(void (^)(void))failure;
- (id)initWithAssortID:(NSString*)assortID;
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;

@end
