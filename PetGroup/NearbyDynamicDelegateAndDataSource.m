//
//  NearbyDynamicDelegateAndDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NearbyDynamicDelegateAndDataSource.h"
#import "DynamicCell.h"

@implementation NearbyDynamicDelegateAndDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NearbyCell";
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.viewC = self.viewC;
    cell.textLabel.text = @"哈哈";
    return cell;
}

@end
