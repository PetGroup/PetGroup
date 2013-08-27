//
//  FriendDynamicDelegateAndDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FriendDynamicDelegateAndDataSource.h"
#import "DynamicCell.h"

@implementation FriendDynamicDelegateAndDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FriendCell";
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.viewC = self.viewC;
    cell.textLabel.text = @"嘿嘿";
    return cell;
}

@end
