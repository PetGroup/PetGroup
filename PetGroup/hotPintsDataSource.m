//
//  hotPintsDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "hotPintsDataSource.h"
#import "articleCell.h"
@implementation hotPintsDataSource
- (id)init
{
    self = [super init];
    if (self) {
        self.pageNo = 1;
        self.forumPid = @"0";
    }
    return self;
}
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    
}
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    
}
#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NearbyCell";
    articleCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[articleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.article = self.dataSourceArray[indexPath.row];
    return cell;
}
@end
