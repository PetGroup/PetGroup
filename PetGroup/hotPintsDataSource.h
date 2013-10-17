//
//  hotPintsDataSource.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DataSource.h"

@interface hotPintsDataSource : DataSource<UITableViewDataSource>
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end
