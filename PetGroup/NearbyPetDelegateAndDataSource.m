//
//  NearbyPetDelegateAndDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-27.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NearbyPetDelegateAndDataSource.h"

@implementation NearbyPetDelegateAndDataSource

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
