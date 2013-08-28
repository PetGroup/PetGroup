//
//  NearbyPersonDelegateAndDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-27.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NearbyPersonDelegateAndDataSource.h"

@implementation NearbyPersonDelegateAndDataSource
-(void)reloadDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    
}
-(void)loadMoreDataSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = @"嘿嘿";
    return cell;
}

@end
